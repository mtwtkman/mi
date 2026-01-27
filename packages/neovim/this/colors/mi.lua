local color_table = {
  white = "#ffffff",
  black = "#000000",
  dark_blue = "#004c63",
  dark_cyan = "#007373",
  dark_green = "#005523",
  dark_grey1 = "#07080D",
  dark_grey2 = "#14161B",
  dark_grey3 = "#2c2e33",
  dark_grey4 = "#4f5258",
  dark_magenta = "#470045",
  dark_red = "#590008",
  dark_yellow = "#6b5300",
  light_blue = "#A6DBFF",
  lilght_cyan = "#8cf8f7",
  light_green = "#b4f6c0",
  light_grey1 = "#eef1f8",
  light_grey2 = "#e0e2ea",
  light_grey3 = "#c4c6cd",
  light_grey4 = "#8b9ea4",
  light_magenta = "#ffcaff",
  light_orange = "#ffc089",
  orange = "#ee8f3c",
  light_yellow = "#fce094",
  light_red = "#e16a6a",
}
vim.g.colors_name = "mi"
vim.g.termguicolors = true

-- basic
vim.api.nvim_set_hl(0, "String", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "Special", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "StatusLine", { fg = color_table.black, bg = color_table.white, bold = false })
vim.api.nvim_set_hl(0, "Changed", { fg = color_table.light_yellow, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "QuickFixLine", { fg = color_table.light_blue, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "TabLine", { fg = color_table.white, bg = color_table.black, bold = false })
vim.api.nvim_set_hl(0, "Normal", { fg = color_table.white, bg = color_table.black, bold = false })
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = color_table.light_grey3, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "LineNr", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = color_table.light_grey3, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "CursorLine", { fg = nil, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "MoreMsg", { fg = color_table.light_blue, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "TabLineSel", { fg = color_table.black, bg = color_table.white, bold = true })
vim.api.nvim_set_hl(0, "Question", { fg = color_table.white, bg = nil, bold = true })

-- floating window
vim.api.nvim_set_hl(0, "NormalFloat", { fg = color_table.white, bg = color_table.black, bold = false })

-- statusline
vim.api.nvim_set_hl(0, "StatusLineGit", { fg = color_table.white, bg = color_table.black, bold = false })

-- diff
vim.api.nvim_set_hl(0, "DiffAdd", { fg = color_table.white, bg = color_table.dark_green, bold = false })
vim.api.nvim_set_hl(0, "DiffDelete", { fg = color_table.dark_red, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "DiffText", { fg = color_table.white, bg = color_table.dark_yellow, bold = false })
vim.api.nvim_set_hl(0, "Added", { fg = color_table.light_green, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "Removed", { fg = color_table.light_red, bg = nil, bold = false })

-- search
vim.api.nvim_set_hl(0, "Search", { fg = color_table.light_grey2, bg = color_table.dark_grey4, bold = false })
vim.api.nvim_set_hl(0, "IncSearch", { fg = color_table.black, bg = color_table.light_grey1, bold = false })
vim.api.nvim_set_hl(0, "Cursor", { fg = color_table.white, bg = color_table.white, bold = false })
vim.api.nvim_set_hl(0, "CurSearch", { fg = color_table.white, bg = color_table.dark_grey4, bold = false })

-- nvim-cmp
vim.api.nvim_set_hl(0, "CmpItemAbbrDefault", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchDefault", { fg = color_table.white, bg = nil, bold = false })

-- treesitter
vim.api.nvim_set_hl(0, "Function", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "Identifier", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "Comment", { fg = color_table.light_grey3, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "Constant", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "Operator", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "Tag", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "Macro", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "Boolean", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "Label", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "Structure", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "Type", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "Keyword", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "Delimiter", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "@variable", { fg = color_table.white, bg = nil, bold = false })

-- neogit
vim.api.nvim_set_hl(0, "NeogitDiffAdd", { fg = color_table.white, bg = color_table.dark_green, bold = false })
vim.api.nvim_set_hl(0, "NeogitDiffDelete", { fg = color_table.white, bg = color_table.dark_red, bold = false })
vim.api.nvim_set_hl(0, "NeogitGraphAuthor", { fg = color_table.white, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "NeogitRemote", { fg = color_table.light_green, bg = nil, bold = false })

-- lsp
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = color_table.light_blue, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = color_table.light_yellow, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = color_table.light_red, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "DiagnosticOk", { fg = color_table.light_green, bg = nil, bold = false })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = color_table.light_magenta, bg = nil, bold = false })

-- indent-breakline
vim.api.nvim_set_hl(0, "IblIndent", { fg = color_table.dark_grey4, bg = nil, bold = true })
vim.api.nvim_set_hl(0, "IblScope", { fg = color_table.white, bg = nil, bold = true })
vim.api.nvim_set_hl(0, "IblWhitespace", { fg = color_table.white, bg = nil, bold = true })

-- netrw
vim.api.nvim_set_hl(0, "Directory", { fg = color_table.white, bg = nil, bold = true })
