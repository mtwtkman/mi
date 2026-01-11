local nmap = require("utils").nmap

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 20
vim.g.netrw_localrmdir = "rmdir"
vim.api.nvim_create_autocmd('filetype', {
  pattern = 'netrw',
  callback = function()
    nmap('a', '%', { buffer = true, remap = true })
  end
})
local function toggle_netrw()
  if vim.bo.filetype == "netrw" then
    vim.cmd("Rexplore")
  else
    vim.cmd("Lexplore")
  end
end

nmap("<leader>n", toggle_netrw, { silent = true })
