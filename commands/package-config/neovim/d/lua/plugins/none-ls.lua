local cspell = require("cspell")

cspell.diagnostics.filetypes = { "text" }
cspell.code_actions.filetypes = { "text" }

require("null-ls").setup({
  sources = {
    cspell.diagnostics,
    cspell.code_actions,
  },
})
