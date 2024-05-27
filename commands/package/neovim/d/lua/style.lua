local cmd = vim.cmd
local set = vim.opt
local nmap = require("utils").nmap

cmd.syntax("enable")
cmd.filetype({ "plugin", "indent", "on" })

set.termguicolors = true
set.number = true
set.relativenumber = true
set.ruler = true
set.title = true
set.showtabline = 2
set.tabstop = 2
set.expandtab = true
set.cmdheight = 2
set.wrap = false
set.scrolloff = 5
set.signcolumn = "yes"
local fixsize = function(params)
  vim.fn.execute("resize " .. params.args)
  set.wfh = true
  set.wfw = true
end
vim.api.nvim_create_user_command("FW", fixsize, { nargs = 1 })
nmap("<leader>w", ":FW<space>", { silent = true })
cmd.highlight({"Normal", "guibg=NONE", "ctermbg=NONE"})

local relative_number_toggle = function()
  vim.opt.relativenumber = not vim.o.relativenumber
end

vim.api.nvim_create_user_command("RelativeNumberToggle", relative_number_toggle, {})
nmap("<leader>rn", ":RelativeNumberToggle<CR>", { silent = true })
