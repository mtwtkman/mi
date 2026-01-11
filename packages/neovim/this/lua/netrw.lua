local nmap = require("utils").nmap

vim.g.netrw_keepdir = 0
vim.g.netrw_autochdir = 1
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 20
vim.g.netrw_localrmdir = "rmdir"
nmap("a", "%", { buffer = true, remap = true })
nmap("q", "<cmd>Lexplore<CR>", { buffer = true, silent = true, nowait = true })
nmap("l", "<CR>", { buffer = true, remap = true, nowait = true })
vim.opt_local.number = false
vim.opt_local.relativenumber = false
local function toggle_netrw()
  if vim.bo.filetype == "netrw" then
    vim.cmd("Rexplore")
  else
    vim.cmd("Lexplore")
  end
end
nmap("<leader>n", toggle_netrw, { silent = true })
