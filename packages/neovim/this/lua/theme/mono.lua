local function hl(name, fg, bg, bold)
  local opt = { fg = fg, bg = bg, bold = bold }
  vim.api.nvim_set_hl(0, name, opt)
end

local white = "#BBBBBB"
local dark_grey = "#494949"
local grey = "#8D8A8A"
local dark_red = "#914343"
local dark_yellow = "#757440"
local dark_blue = "#3A3C95"
local dark_green = "#45663B"

-- builtin
hl("Comment", grey, nil, false)
hl("LineNr", grey, nil, false)
hl("DiffAdd", dark_green, nil, false)
hl("DiffDelete", dark_red, nil, false)
hl("ErrorMsg", dark_red, nil, false)
hl("Search", white, dark_grey, false)
hl("WarningMsg", dark_red, nil, false)
hl("Error", dark_red, nil, false)
hl("NvimInternalError", dark_red, nil, false)
hl("Special", dark_blue, nil, false)

-- treesitter
hl("@comment", grey, nil, false)
hl("@keyword", white, nil, false)
hl("@string", white, nil, false)
hl("@punctuation.bracket", white, nil, false)
hl("@punctuation.delimiter", white, nil, false)
hl("@variable", white, nil, false)
hl("@variable.member", white, nil, false)
hl("@variable.parameter", white, nil, false)
hl("@number", white, nil, false)
hl("@property", white, nil, false)
hl("@operator", white, nil, false)
hl("@constructor", white, nil, false)
hl("@constant.builtin", white, nil, false)
hl("@boolean", white, nil, false)
hl("@function", white, nil, false)
hl("@function.method", white, nil, false)
hl("@diff.plus", dark_green, nil, false)
hl("@diff.minus", dark_red, nil, false)
hl("@diff.delta", dark_yellow, nil, false)

-- lsp
hl("DiagnosticError", dark_red, nil, false)
hl("DiagnosticWarn", dark_yellow, nil, false)
hl("DiagnosticInfo", dark_blue, nil, false)
hl("Directory", white, nil, false)
hl("DiagnosticUnnecessary", dark_grey, nil, false)
hl("DiagnosticVirtualTextError", dark_red, nil, false)
hl("DiagnosticSignError", dark_red, nil, false)
