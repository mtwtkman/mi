local hl = require("utils").hl
local c = require("color")

vim.g.colors_name = "mi"
vim.g.termguicolors = true

-- basic
hl("String", c.white, nil, false)
hl("Special", c.white, nil, false)
hl("StatusLine", c.black, c.white, false)
hl("Changed", c.light_yellow, nil, false)
hl("QuickFixLine", c.light_blue, nil, false)
hl("TabLine", c.white, c.black, false)
hl("Normal", c.white, c.black, false)
hl("LineNrAbove", c.light_grey3, nil, false)
hl("LineNr", c.white, nil, false)
hl("LineNrBelow", c.light_grey3, nil, false)
hl("CursorLineNr", c.white, nil, false)
hl("CursorLine", nil, nil, false)
hl("MoreMsg", c.light_blue, nil, false)
hl("TabLineSel", c.black, c.white, true)
hl("Question", c.white, nil, true)

-- diff
hl("DiffAdd", c.white, c.dark_green, false)
hl("DiffDelete", c.dark_red, nil, false)
hl("DiffText", c.white, c.dark_yellow, false)
hl("Added", c.light_green, nil, false)
hl("Removed", c.light_red, nil, false)

-- search
hl("Search", c.light_grey2, c.dark_grey4, false)
hl("IncSearch", c.black, c.light_grey1, false)
hl("Cursor", c.white, c.white, false)
hl("CurSearch", c.black, c.light_grey2, false)

-- nvim-tree
hl("Directory", c.white, nil, false)
hl("NvimTreeFolderIcon", c.white, nil, false)

-- nvim-cmp
hl("CmpItemAbbrDefault", c.white, nil, false)
hl("CmpItemAbbrMatchDefault", c.white, nil, false)

-- treesitter
hl("Function", c.white, nil, false)
hl("Identifier", c.white, nil, false)
hl("Comment", c.light_grey3, nil, false)
hl("Constant", c.white, nil, false)
hl("Operator", c.white, nil, false)
hl("Tag", c.white, nil, false)
hl("Macro", c.white, nil, false)
hl("Boolean", c.white, nil, false)
hl("Label", c.white, nil, false)
hl("Structure", c.white, nil, false)
hl("Type", c.white, nil, false)
hl("Keyword", c.white, nil, false)
hl("Delimiter", c.white, nil, false)
hl("@variable", c.white, nil, false)

-- neogit
hl("NeogitDiffAdd", c.white, c.dark_green, false)
hl("NeogitDiffDelete", c.white, c.dark_red, false)
hl("NeogitGraphAuthor", c.white, nil, false)
hl("NeogitRemote", c.light_green, nil, false)

--dropbar
hl("DropbarIconUIPickPivot", c.black, c.white, false)

-- telescope
hl("TelescopeMatching", c.white, c.light_grey4, false)

-- lsp
hl("DiagnosticInfo", c.light_blue, nil, false)
hl("DiagnosticWarn", c.light_yellow, nil, false)
hl("DiagnosticError", c.light_red, nil, false)
hl("DiagnosticOk", c.light_green, nil, false)
hl("DiagnosticHint", c.light_magenta, nil, false)

-- indent-breakline
hl("IblIndent", c.dark_grey4, nil, true)
hl("IblScope", c.white, nil, true)
hl("IblWhitespace", c.white, nil, true)

-- window-picker
hl("WindowPickerWinBar", c.white, c.light_red, false)
hl("WindowPickerWinBarNC", c.black, c.light_blue, false)
hl("WindowPickerStatusLine", c.white, c.light_red, false)
hl("WindowPickerStatusLineNC", c.black, c.light_blue, false)
