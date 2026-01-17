local utils = require("utils")
local tmap = utils.tmap
local nmap = utils.nmap

nmap("<leader>tt", ":tabe<CR>:terminal<CR>", { silent = true })
nmap("<leader>tv", ":vsp<CR>:terminal<CR>", { silent = true })
nmap("<leader>ts", ":botright 20split<CR>:terminal<CR>", { silent = true })
nmap("<C-\\>", ":botright 20split<CR>:terminal<CR>", { silent = true })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0, silent = true }
  tmap("<ESC>", [[<C-\><C-n>]], opts)
  tmap("<C-w>", [[<C-\><C-n><C-w>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

local terminal_buffer_group = vim.api.nvim_create_augroup("TerminalBuffer", { clear = true })

vim.api.nvim_create_autocmd({ "TermEnter" }, {
  pattern = { "*" },
  callback = function(_)
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

local function open_term_within_current_dir(winpos)
  local dir = vim.fn.expand("%:p:h")
  vim.cmd(winpos .. " | terminal cd " .. vim.fn.shellescape(dir) .. " && " .. vim.o.shell)
end

nmap("<leader>ds", function() open_term_within_current_dir("20split") end, { silent = true })
nmap("<leader>dt", function() open_term_within_current_dir("tabnew") end, { silent = true })
nmap("<leader>dv", function() open_term_within_current_dir("vsplit") end, { silent = true })
