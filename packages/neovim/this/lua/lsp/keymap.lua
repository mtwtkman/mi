local utils = require("utils")
local nmap = utils.nmap

return {
  register = function(bufnr)
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
    nmap("<space>ca", vim.lsp.buf.code_action, { buffer = bufnr })
    nmap("<space>f", function() vim.lsp.buf.format { async = true } end, { silent = true, buffer = bufnr })
  end
}
