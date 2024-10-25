local c = require("color")
require("lualine").setup({
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
          bg = c.white
        }
      },
      {
        "lsp_progress",
        color = {
          fg = c.black,
          bg = c.white
        }
      },
    },
    lualine_x = {
      {
        "encoding",
        color = {
          fg = c.black,
          bg = c.white
        },
      },
      {
        "fileformat",
        color = {
          fg = c.black,
          bg = c.white
        },
      },
      {
        "filetype",
        color = {
          fg = c.black,
          bg = c.white
        },
      },
    },
    lualine_z = {
      {
        "location",
        color = {
          fg = c.black,
          bg = c.white
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
