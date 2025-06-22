local config = require("lsp.config").make_default()

require("lean").setup({
  lsp = {
    on_attach = config.on_attach,
  },
})
