local c = require("color")
local theme = {
  normal = {
    a = { fg = c.black, bg = c.white },
    b = { fg = c.white, bg = c.black },
    c = { fg = c.black, bg = c.white },
    z = { fg = c.white, bg = c.black },
  },
  insert = { a = { fg = c.black, bg = c.white } },
  visual = { a = { fg = c.black, bg = c.white } },
  replace = { a = { fg = c.black, bg = c.white } },
}

require("lualine").setup({
  options = {
    theme = theme,
    icons_enabled = false,
  },
  sections = {
    lualine_b = {
      "grapple",
      "branch",
      "diagnostics",
    },
    lualine_c = {
      {
        "filename",
        path = 1,
        color = {
          fg = c.black,
          bg = c.white,
        }
      },
      {
        "lsp_status",
        color = {
          fg = c.black,
          bg = c.white,
        }
      },
    },
    lualine_x = {
      {
        "encoding",
        color = {
          fg = c.black,
          bg = c.white,
        },
      },
      {
        "fileformat",
        color = {
          fg = c.black,
          bg = c.white,
        },
      },
      {
        "filetype",
        colored = false,
        color = {
          fg = c.black,
          bg = c.white,
        },
      },
    },
    lualine_z = {
      {
        "location",
        color = {
          fg = c.black,
          bg = c.white,
        },
      }
    },
  },
  inactive_sections = {
    lualine_c = {
      {
        "filename",
        path = 1,
        color = {
          fg = c.white,
          bg = c.black,
        },
      },
    },
  },
})
