import { Plugin } from "@opencode/plugin"
import { startNotifications } from "./runtime.mjs"

export default Plugin.define({
  id: "local.mako-notifications",
  setup: startNotifications,
})
