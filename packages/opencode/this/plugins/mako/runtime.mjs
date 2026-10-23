import { execFile } from "node:child_process"
import { existsSync } from "node:fs"
import { promisify } from "node:util"
import { setTimeout as delay } from "node:timers/promises"

const execute = promisify(execFile)
const bridge = "/usr/bin/distrobox-host-exec"

function host(command, args) {
  return existsSync("/run/.containerenv") && existsSync(bridge)
    ? execute(bridge, [command, ...args], { timeout: 10000 })
    : execute(command, args, { timeout: 10000 })
}

export async function desktopNotify(kind, title) {
  const action = kind === "action-required"
  const message = action
    ? "OpenCode is waiting for your answer or approval."
    : "OpenCode has finished your task."
  const body = title ? `${message}\n${title}` : message
  // Explicitly play one sound; don't also ask the notification daemon to play it.
  const results = await Promise.allSettled([
    host("notify-send", [
      "--app-name=OpenCode",
      `--category=opencode.${kind}`,
      `--urgency=${action ? "normal" : "low"}`,
      "--expire-time=2000",
      "--hint=boolean:suppress-sound:true",
      "--icon=dialog-information",
      "--", "OpenCode", body,
    ]),
    host("canberra-gtk-play", ["-i", action ? "dialog-warning" : "complete"]),
  ])
  const errors = results.filter((result) => result.status === "rejected")
  if (errors.length) throw new AggregateError(errors.map((result) => result.reason), "Desktop alert failed")
}

// Kept separate from the plugin entry point so event filtering can be tested
// without running a model or sending real desktop notifications.
export function createHandler(ctx, notify = desktopNotify) {
  const seen = new Set()
  const pending = new Map()

  function remember(key) {
    if (seen.has(key)) return false
    seen.add(key)
    if (seen.size > 1024) seen.delete(seen.values().next().value)
    return true
  }

  return async (event) => {
    if (!["form.created", "form.replied", "form.cancelled", "permission.asked",
      "permission.replied", "session.execution.succeeded"].includes(event.type)) return

    const data = event.data
    const sessionID = event.type === "form.created" ? data.form.sessionID : data.sessionID
    if (!sessionID || sessionID === "global") return
    // Durable execution events have no location in V2. Resolve their owning
    // session instead of silently dropping them (or alerting from every plugin).
    let session
    const location = event.location ?? (session = await ctx.session.get({ sessionID })).location
    // Each loaded location has its own plugin instance but the stream is global.
    if (location?.directory !== ctx.location.directory ||
        location?.workspaceID !== ctx.location.workspaceID) return

    if (event.type === "form.replied" || event.type === "form.cancelled") {
      pending.delete(data.id)
      return
    }
    if (event.type === "permission.replied") {
      pending.delete(data.requestID)
      return
    }

    if (event.type === "form.created" || event.type === "permission.asked") {
      const request = event.type === "form.created" ? data.form : data
      if (!request.sessionID || request.sessionID === "global") return
      if (!remember(`request:${request.id}`)) return
      pending.set(request.id, request.sessionID)
      // A child may require user approval too; only its completion is silent.
      session ??= await ctx.session.get({ sessionID: request.sessionID })
      await notify("action-required", session.title)
      return
    }

    // Do not use step completion, tool results, idle, or subagent events.
    if (event.type !== "session.execution.succeeded") return
    if (!remember(`done:${event.id}`)) return
    if ([...pending.values()].includes(data.sessionID)) return
    session ??= await ctx.session.get({ sessionID: data.sessionID })
    if (session.parentID) return
    await notify("completed", session.title)
  }
}

export function startNotifications(ctx) {
  const controller = new AbortController()
  const handle = createHandler(ctx)
  let queue = Promise.resolve()

  // Drain the event stream promptly: desktop commands must not block it and
  // cause OpenCode's live-only subscription to overflow. Preserve event order.
  void (async () => {
    while (!controller.signal.aborted) {
      try {
        for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
          queue = queue.then(() => {
            if (!controller.signal.aborted) return handle(event)
          }).catch((error) => console.error("OpenCode desktop alert:", error))
        }
      } catch (error) {
        if (!controller.signal.aborted) console.error("OpenCode alert stream:", error)
      }
      if (!controller.signal.aborted) {
        await delay(1000, undefined, { signal: controller.signal }).catch(() => {})
      }
    }
  })()

  return () => controller.abort()
}
