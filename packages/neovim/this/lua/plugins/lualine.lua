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
