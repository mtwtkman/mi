local utils = require("utils")
local tmap = utils.tmap
local nmap = utils.nmap

nmap("<leader>tt", ":tabe<CR>:terminal<CR>", { silent = true })
nmap("<leader>tv", ":vsp<CR>:terminal<CR>", { silent = true })
nmap("<leader>ts", ":sp<CR>:terminal<CR>", { silent = true })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0, silent = true }
  tmap("<ESC>", [[<C-\><C-n>]], opts)
  tmap("<C-w>", [[<C-\><C-n><C-w>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

local terminal_buffer_group = vim.api.nvim_create_augroup("TerminalBuffer", { clear = true })

vim.api.nvim_create_autocmd({ "TermEnter" }, {
  pattern = { "*" },
  callback = function(ev)
    vim.cmd("setlocal nonumber")
    vim.cmd("setlocal norelativenumber")
  end,
  group = terminal_buffer_group,
})
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = { "*" },
  command = "startinsert",
  group = terminal_buffer_group,
})
