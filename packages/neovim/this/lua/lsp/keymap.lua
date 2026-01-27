return {
  register = function(bufnr)
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
}
