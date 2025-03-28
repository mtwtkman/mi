local navic = require("nvim-navic")
local utils = require("utils")
local nmap = utils.nmap

local setup_diagnostic_signs = function()
  local hl = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
    [vim.diagnostic.severity. WARN] = "DiagnosticSignWarn",
    [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    [vim.diagnostic.severity. HINT] = "DiagnosticSignHint"
  }
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "󰌵"
      },
      linehl = hl,
      numhl = hl,
    },
  })
end

local setup_keymaps = function(bufnr)
  nmap("<space>e", vim.diagnostic.open_float, { silent = true })
  nmap("[d", function() vim.diagnostic.jump({count=1, float=true}) end, { silent = true })
  nmap("]d", function() vim.diagnostic.jump({count=-1, float=true}) end, { silent = true })
  nmap("gD", vim.lsp.buf.declaration, { silent = true, buffer = bufnr })
  nmap("gd", vim.lsp.buf.definition, { silent = true, buffer = bufnr })
  nmap("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, { silent = true, buffer = bufnr })
  nmap("gi", vim.lsp.buf.implementation, { silent = true, buffer = bufnr })
  nmap("g<C-k>", vim.lsp.buf.signature_help, { silent = true, buffer = bufnr })
  nmap("<space>wa", vim.lsp.buf.add_workspace_folder, { silent = true, buffer = bufnr })
  nmap("<space>wr", vim.lsp.buf.remove_workspace_folder, { silent = true, buffer = bufnr })
  nmap("<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { silent = true, buffer = bufnr })
  nmap("<space>D", vim.lsp.buf.type_definition, { silent = true, buffer = bufnr })
  nmap("<space>rn", vim.lsp.buf.rename, { silent = true, buffer = bufnr })
  nmap("<space>ca", require("actions-preview").code_actions, { silent = true, buffer = bufnr })
  nmap("<space>f", function() vim.lsp.buf.format { async = true } end, { silent = true, buffer = bufnr })
end

local on_attach = function(client, bufnr)
  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  setup_diagnostic_signs()
  setup_keymaps(bufnr)
end

local lsp_flags = {
  debounce_text_changes = 150
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local make_default_config = function()
  return {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
  }
end

vim.diagnostic.config({
  float = { border = "rounded" },
})

return {
  make_default_config = make_default_config
}
