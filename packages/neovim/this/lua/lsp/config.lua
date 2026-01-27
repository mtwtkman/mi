local hl = {
  [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
  [vim.diagnostic.severity. WARN] = "DiagnosticSignWarn",
  [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
  [vim.diagnostic.severity. HINT] = "DiagnosticSignHint"
}

local on_attach = function(client, bufnr)
  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "󰌵"
      },
      numhl = hl,
    },
    float = { border = "rounded" },
  })

  vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { silent = true })
  vim.keymap.set("n", "[d", function() vim.diagnostic.jump({count=1, float=true}) end, { silent = true })
  vim.keymap.set("n", "]d", function() vim.diagnostic.jump({count=-1, float=true}) end, { silent = true })
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { silent = true, buffer = bufnr })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true, buffer = bufnr })
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, { silent = true, buffer = bufnr })
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { silent = true, buffer = bufnr })
  vim.keymap.set("n", "g<C-k>", vim.lsp.buf.signature_help, { silent = true, buffer = bufnr })
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { silent = true, buffer = bufnr })
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { silent = true, buffer = bufnr })
  vim.keymap.set("n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { silent = true, buffer = bufnr })
  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, { silent = true, buffer = bufnr })
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { silent = true, buffer = bufnr })
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr })
  vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format { async = true } end, { silent = true, buffer = bufnr })
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
