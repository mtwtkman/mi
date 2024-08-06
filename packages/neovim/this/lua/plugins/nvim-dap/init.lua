local utils = require("utils")
local dap = require("dap")
local nmap = utils.nmap

nmap("<F5>", dap.continue, { silent = true })
nmap("<F2>", dap.step_over, { silent = true })
nmap("<F3>", dap.step_into, { silent = true })
nmap("<F4>", dap.step_out, { silent = true })
nmap("<leader>db", dap.toggle_breakpoint, { silent = true })
nmap("<leader>dl", dap.run_last, { silent = true })

local load_setting = function(langtype)
  local config = require("plugins.nvim-dap." .. langtype)
  dap.adapters[langtype] = config.adapter
  dap.configurations[langtype] = config.client
end

utils.iterate_child_modules(debug.getinfo(1, "S"), load_setting)
