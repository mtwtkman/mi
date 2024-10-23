local hl = require("utils").hl
local c = require("color")

vim.g.colors_name = "mi"
vim.g.termguicolors = true

-- basic
hl("String", c.white, nil, false)
hl("Special", c.white, nil, false)
hl("StatusLine", c.black, c.white, false)
hl("Changed", c.light_yellow, nil, false)
hl("LineNr", c.light_grey3, nil, false)
hl("QuickFixLine", c.light_blue, nil, false)
hl("TabLine", c.white, c.black, false)
hl("Normal", c.white, c.black, false)

-- diff
hl("DiffAdd", c.white, c.dark_green, false)
hl("DiffDelete", c.dark_red, nil, false)
hl("DiffText", c.white, c.dark_yellow, false)

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
hl("Comment", c.light_grey4, nil, false)
hl("Constant", c.white, nil, false)
hl("@variable", c.white, nil, false)

-- neogit
hl("NeogitDiffAdd", c.white, c.dark_green, false)
hl("NeogitDiffDelete", c.white, c.dark_red, false)
hl("NeogitGraphAuthor", c.white, nil, false)
hl("NeogitRemote", c.light_green, nil, false)

--dropbar
hl("DropbarIconUIPickPivot", c.white, c.light_grey1, false)

-- telescope
hl("TelescopeMatching", c.white, c.light_grey4, false)
