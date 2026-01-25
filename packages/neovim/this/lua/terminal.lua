local utils = require("utils")
local tmap = utils.tmap
local nmap = utils.nmap

nmap("<leader>tt", ":tabe<CR>:terminal<CR>", { silent = true })
nmap("<leader>tv", ":vsp<CR>:terminal<CR>", { silent = true })
nmap("<leader>ts", ":botright 20split<CR>:terminal<CR>", { silent = true })

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

local function open_term_within_current_dir(winpos, cmd)
  local dir = vim.fn.expand("%:p:h")
  local shell_cmd = string.format("%s %s", vim.o.shell, cmd == "" and "" or string.format("-lc '%s && %s'", cmd, vim.o.shell))
  vim.cmd(winpos .. " | terminal cd " .. vim.fn.shellescape(dir) .. " && " .. shell_cmd)
end

nmap("<leader>ds", function() open_term_within_current_dir("20split") end, { silent = true })
nmap("<leader>dt", function() open_term_within_current_dir("tabnew") end, { silent = true })
nmap("<leader>dv", function() open_term_within_current_dir("vsplit") end, { silent = true })

local function show_directory()
  open_term_within_current_dir("20split", "ls -la")
end

nmap("<leader>n", show_directory, { silent = true })

local term_buf = nil
local term_win = nil

local function toggle_terminal()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_hide(term_win)
    term_win = nil
    return
  end

  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = vim.api.nvim_create_buf(false, true)
  end

  vim.cmd("botright 20split")
  term_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(term_win, term_buf)

  if vim.bo[term_buf].buftype ~= "terminal" then
    vim.fn.termopen(vim.o.shell)
    vim.opt_local.winfixheight = true
    vim.opt_local.winfixbuf = true
  end

  vim.cmd("startinsert")
end

nmap("<C-\\>", toggle_terminal, { silent = true })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0, silent = true }
  tmap("<ESC>", [[<C-\><C-n>]], opts)
  tmap("<C-w>", [[<C-\><C-n><C-w>]], opts)
  tmap("<C-\\>", toggle_terminal, opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
