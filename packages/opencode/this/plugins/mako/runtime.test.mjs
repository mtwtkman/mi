import assert from "node:assert/strict"
import { test } from "node:test"
import { createHandler } from "./runtime.mjs"

function fixture() {
  const alerts = []
  const location = { directory: "/project" }
  const handler = createHandler({
    location,
    session: { get: async ({ sessionID }) => ({
      title: sessionID,
      location: { directory: sessionID === "other" ? "/other" : "/project" },
      ...(sessionID === "child" ? { parentID: "main" } : {}),
    }) },
  }, async (...args) => alerts.push(args))
  let id = 0
  return { alerts, send: (type, data, where = location, eventID = String(++id)) =>
    handler({ type, data, location: where, id: eventID }) }
}

test("main task completion alerts once; later tasks alert again", async () => {
  const { alerts, send } = fixture()
  await send("session.execution.succeeded", { sessionID: "main" }, undefined, "done1")
  await send("session.execution.succeeded", { sessionID: "main" }, undefined, "done1")
  await send("session.execution.succeeded", { sessionID: "main" }, undefined, "done2")
  assert.deepEqual(alerts, [["completed", "main"], ["completed", "main"]])
})

test("real V2 durable completion has no location; resolve it from the session", async () => {
  const { alerts, send } = fixture()
  await send("session.execution.succeeded", { sessionID: "main" }, null, "done1")
  await send("session.execution.succeeded", { sessionID: "main" }, null, "done1")
  await send("session.execution.succeeded", { sessionID: "main" }, null, "done2")
  await send("session.execution.succeeded", { sessionID: "other" }, null)
  await send("session.execution.succeeded", { sessionID: "child" }, null)
  assert.deepEqual(alerts, [["completed", "main"], ["completed", "main"]])
})

test("progress, idle, subagent completion, failure and interruption are silent", async () => {
  const { alerts, send } = fixture()
  for (const type of ["session.execution.started", "session.step.completed", "session.idle",
    "session.execution.failed", "session.execution.interrupted", "message.updated"]) {
    await send(type, { sessionID: "main" })
  }
  await send("session.execution.succeeded", { sessionID: "child" })
  assert.deepEqual(alerts, [])
})

test("questions and approval requests alert, including blocked children", async () => {
  const { alerts, send } = fixture()
  const form = { id: "q1", sessionID: "main" }
  await send("form.created", { form })
  await send("form.created", { form })
  await send("permission.asked", { id: "p1", sessionID: "child" })
  assert.deepEqual(alerts, [["action-required", "main"], ["action-required", "child"]])
})

test("pending input cannot be misreported as completion", async () => {
  const { alerts, send } = fixture()
  await send("form.created", { form: { id: "q1", sessionID: "main" } })
  await send("session.execution.succeeded", { sessionID: "main" })
  await send("form.replied", { id: "q1", sessionID: "main" })
  await send("session.execution.succeeded", { sessionID: "main" })
  assert.deepEqual(alerts, [["action-required", "main"], ["completed", "main"]])
})

test("other locations, workspaces and non-task forms are ignored", async () => {
  const { alerts, send } = fixture()
  await send("session.execution.succeeded", { sessionID: "main" }, { directory: "/other" })
  await send("session.execution.succeeded", { sessionID: "main" }, { directory: "/project", workspaceID: "other" })
  await send("form.created", { form: { id: "q1", sessionID: "global" } })
  assert.deepEqual(alerts, [])
})

test("replied permissions and cancelled forms allow subsequent completion", async () => {
  const { alerts, send } = fixture()
  await send("permission.asked", { id: "p1", sessionID: "main" })
  await send("permission.replied", { requestID: "p1", sessionID: "main" })
  await send("form.created", { form: { id: "q1", sessionID: "main" } })
  await send("form.cancelled", { id: "q1", sessionID: "main" })
  await send("session.execution.succeeded", { sessionID: "main" })
  assert.equal(alerts.at(-1)[0], "completed")
})
