local util = require("utils")
local finder = require("quickfix.app.finder")
local lsp = require("quickfix.app.lsp")

if vim.fn.executable("rg") == 1 then
  vim.o.grepprg = "rg --vimgrep --smart-case --hidden"
  vim.o.grepformat = "%f:%l:%c:%m"
end

vim.api.nvim_create_user_command("Grep", function(opts)
  finder.live_grep(opts.args)
end, { nargs = "*" })

util.nmap("<leader>gw", function() finder.live_grep(vim.fn.expand("<cword>")) end, { silent = true })
util.nmap("<Leader>gg", finder.live_grep, { silent = true })
util.nmap("<leader>b", finder.find_recent_buffers, { silent = true })
util.nmap("<leader>/", finder.buffer_search)
util.nmap("<leader>o", finder.find_files, { silent = true })
util.nmap("<leader>l", lsp.symbols, { silent = true })

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = { "grep", "vimgrep" },
  command = "cwindow",
})
