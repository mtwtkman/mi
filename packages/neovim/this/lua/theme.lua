local hl = require("utils").hl
local c = require("color")

vim.g.colors_name = "mi"
vim.g.termguicolors = true

-- basic
hl("String", c.white, nil, false)
hl("Special", c.white, nil, false)
hl("StatusLine", c.black, c.white, false)
hl("Changed", c.light_blue, nil, false)

-- diff
hl("DiffAdd", c.white, c.green, false)
hl("DiffDelete", c.red, nil, false)
hl("DiffText", c.white, c.yellow, false)

-- search
hl("Search", c.black, c.light_grey, false)
hl("IncSearch", c.black, c.light_grey, false)

-- nvim-tree
hl("Directory", c.white, nil, false)

-- nvim-cmp
hl("CmpItemAbbrDefault", c.white, nil, false)
hl("CmpItemAbbrMatchDefault", c.white, nil, false)

-- treesitter
hl("Function", c.white, nil, false)
hl("Identifier", c.white, nil, false)
hl("Comment", c.light_grey, nil, false)
hl("Constant", c.white, nil, false)
hl("@variable", c.white, nil, false)

-- neogit
hl("NeogitDiffAdd", c.white, c.green, false)
hl("NeogitDiffDelete", c.white, c.red, false)

--dropbar
hl("DropbarIconUIPickPivot", c.white, c.grey, false)
