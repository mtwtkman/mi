local appearance = require("lsp.appearance")
local keymap = require("lsp.keymap")

local on_attach = function(client, bufnr)
  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

  appearance.register()
  keymap.register(bufnr)
end

local lsp_flags = {
  debounce_text_changes = 150
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local make_default = function()
  return {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
  }
end

return {
  make_default = make_default,
}
