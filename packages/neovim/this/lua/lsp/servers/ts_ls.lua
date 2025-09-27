return {
  cmd = { "npx", "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
  },
  root_markers = { "tsconfig.json", "package.json" },
}
