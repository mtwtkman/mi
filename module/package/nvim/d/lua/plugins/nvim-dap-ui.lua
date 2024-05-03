local nmap = require("utils").nmap
local dapui = require("dapui")
local dap = require("dap")

dapui.setup({
  controls = {
    enabled = false,
  },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

nmap("<leader>df", function() dapui.float_element("stacks", { enter = true }) end, { silent = true })
nmap("<leader>ds", function() dapui.float_element("scopes", { enter = true }) end, { silent = true })
