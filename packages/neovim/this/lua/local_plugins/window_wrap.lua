local opposites = {
  h = "l",
  j = "k",
  k = "j",
  l = "h",
}

local M = {}

function M.wrap_wincmd(dir)
  local current = vim.api.nvim_get_current_win()

  vim.cmd.wincmd(dir)

  if vim.api.nvim_get_current_win() == current then
    vim.cmd("999wincmd " .. opposites[dir])
  end
end

return M
