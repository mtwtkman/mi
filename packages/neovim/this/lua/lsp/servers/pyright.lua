return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  settings = {
    analysis = {
      autoSearchPaths = true,
      diagnosticNode = "openFilesOnly",
      useLibraryCodeForTypes = true,
    },
  },
}
