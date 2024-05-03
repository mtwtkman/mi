local catppuccin_theme = require("lualine.themes.catppuccin")
local catppuccin_palette = require("catppuccin.palettes").get_palette(require("catppuccin").flavour)
local catppuccin_bg = catppuccin_palette.mantle

catppuccin_theme.normal.c.bg = catppuccin_bg
catppuccin_theme.inactive.c.bg = catppuccin_bg

require("lualine").setup({
  options = {
    theme = catppuccin_theme,
  },
  sections = {
    lualine_b = { "grapple" },
    lualine_c = {
      {
        "filename",
        path = 1,
      },
      "lsp_progress",
    },
  },
  inactive_sections = {
    lualine_c = {
      {
        "filename",
        path = 1,
      },
    },
  },
})
