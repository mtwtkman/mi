local hl = require("theme").hl
local pallet = require("theme.mono.color_pallet")

-- builtin
hl("Comment", pallet.grey, nil, false)
hl("LineNr", pallet.grey, nil, false)
hl("DiffAdd", pallet.dark_green, nil, false)
hl("DiffDelete", pallet.dark_red, nil, false)
hl("ErrorMsg", pallet.dark_red, nil, false)
hl("Search", pallet.white, pallet.dark_grey, false)
hl("WarningMsg", pallet.dark_red, nil, false)
hl("Error", pallet.dark_red, nil, false)
hl("NvimInternalError", pallet.dark_red, nil, false)
hl("Special", pallet.dark_blue, nil, false)
hl("Function", pallet.white, nil, false)
hl("Identifier", pallet.white, nil, false)

-- treesitter
hl("@comment", pallet.grey, nil, false)
hl("@keyword", pallet.white, nil, false)
hl("@string", pallet.white, nil, false)
hl("@punctuation.bracket", pallet.white, nil, false)
hl("@punctuation.delimiter", pallet.white, nil, false)
hl("@variable", pallet.white, nil, false)
hl("@variable.member", pallet.white, nil, false)
hl("@variable.parameter", pallet.white, nil, false)
hl("@number", pallet.white, nil, false)
hl("@property", pallet.white, nil, false)
hl("@operator", pallet.white, nil, false)
hl("@constructor", pallet.white, nil, false)
hl("@constant.builtin", pallet.white, nil, false)
hl("@boolean", pallet.white, nil, false)
hl("@function", pallet.white, nil, false)
hl("@function.method", pallet.white, nil, false)
hl("@diff.plus", pallet.dark_green, nil, false)
hl("@diff.minus", pallet.dark_red, nil, false)
hl("@diff.delta", pallet.dark_yellow, nil, false)

-- lsp
hl("DiagnosticError", pallet.dark_red, nil, false)
hl("DiagnosticWarn", pallet.dark_yellow, nil, false)
hl("DiagnosticInfo", pallet.dark_blue, nil, false)
hl("Directory", pallet.white, nil, false)
hl("DiagnosticUnnecessary", pallet.dark_grey, nil, false)
hl("DiagnosticVirtualTextError", pallet.dark_red, nil, false)
hl("DiagnosticSignError", pallet.dark_red, nil, false)

-- telescope
hl("TelescopeMatching", pallet.grey, nil, false)
