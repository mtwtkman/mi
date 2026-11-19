local M = {}

local term_buf = nil
local term_win = nil

function M.toggle()
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

function M.set_terminal_keymaps()
  local opts = { buffer = 0, silent = true }
  vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
  vim.keymap.set("t", "<C-\\>", M.toggle, opts)
end

function M.open_within_current_dir(winpos, cmd)
  local dir = vim.fn.expand("%:p:h")
  local shell_cmd = string.format("%s %s", vim.o.shell, (cmd == "" or cmd == nil)and "" or string.format("-lc '%s && %s'", cmd, vim.o.shell))
  vim.cmd(winpos .. " | terminal cd " .. vim.fn.shellescape(dir) .. " && " .. shell_cmd)
end

local group = vim.api.nvim_create_augroup("MyTerminalSettings", { clear = true })

vim.api.nvim_create_autocmd({ "TermEnter" }, {
  pattern = { "*" },
  callback = function(_)
    vim.cmd("setlocal nonumber")
    vim.cmd("setlocal norelativenumber")
  end,
  group = group,
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = group,
    pattern = "term://*",
    callback = function()
        vim.cmd("startinsert")
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        M.set_terminal_keymaps()
    end,
})
return M
