# Local OpenCode desktop notifications (V2)

Globally discovered server plugin; works even with the TUI unfocused or closed
while the OpenCode service continues running. In Distrobox, desktop commands
are forwarded to the host using `distrobox-host-exec`.

- Main session `session.execution.succeeded`: green mako popup (2 seconds),
  Freedesktop `complete` sound.
  Durable events have no `location`; the plugin resolves the session's location
  before filtering so completion is not silently dropped or duplicated.
- `form.created` / `permission.asked`: amber popup (2 seconds),
  `dialog-warning` sound. Child approvals also alert because they need input.
- Progress, tool steps, idle, child completion, interruptions and failures are
  silent. Notifications mean an OpenCode execution finished, not that its
  result was independently verified. Free-text questions without a question
  tool/form cannot be reliably distinguished from other final responses.

Host colors: `/home/me/.config/mako/config`. Built-in TUI notifications are
disabled in the container's `~/.config/opencode/cli.json` to avoid duplicate
alerts and subagent sounds. Restart an existing TUI if it retains its built-in
notification plugin. Server plugins reload automatically on config changes.

Tests (Node is installed on the host):

```sh
distrobox-host-exec node --test ~/.config/opencode/plugins/mako/runtime.test.mjs
```

Preview a real notification and sound:

```sh
distrobox-host-exec node --input-type=module -e \
  'import { desktopNotify } from "file:///home/me/work/dev/.distrobox/home/.config/opencode/plugins/mako/runtime.mjs"; await desktopNotify("completed", "Notification test")'
```
