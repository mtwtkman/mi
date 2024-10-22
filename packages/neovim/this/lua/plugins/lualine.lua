local pallet = require("theme.mono").pallet()

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
          fg = pallet.black,
          bg = pallet.white,
        }
      },
      {
        "lsp_progress",
        color = {
          fg = pallet.black,
          bg = pallet.white,
        }
      },
    },
    lualine_x = {
      {
        'encoding',
        color = {
          fg = pallet.black,
          bg = pallet.white,
        },
      },
      {
        'fileformat',

        color = {
          fg = pallet.black,
          bg = pallet.white,
        },
      },
      {
        'filetype',
        color = {
          fg = pallet.black,
          bg = pallet.white,
        },
      }
    }
  },
  inactive_sections = {
    lualine_c = {
      {
        "filename",
        path = 1,
        color = {
          fg = pallet.black,
          bg = pallet.white,
        }
      },
    },
  },
})
