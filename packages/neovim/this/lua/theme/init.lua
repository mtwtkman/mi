M = {}

function M.hl(name, fg, bg, bold)
  local opt = { fg = fg, bg = bg, bold = bold }
  vim.api.nvim_set_hl(0, name, opt)
end

function M.mono()
  require("theme.mono").scheme()
end

return M
