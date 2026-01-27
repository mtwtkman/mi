return {
  bashls = {
    cmd = "bash-language-server",
    filetypes = { "sh", "bash" },
  },
  elmls = {
    cmd = { "npx", "elm-language-server" },
    filetypes = { "elm" },
    root_marker = { "elm.json" },
  },
  html = {
    cmd = { "npx", "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "templ" },
    init_options = {
      configurationSection = { "html", "css", "javascript" },
      embeddedLanguages = {
        css = true,
        javascript = true
      },
      provideFormatter = true,
    },
  },
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    settings = {
      Lua = {
        diagnostics = {
          globals = {"vim"},
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
  pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    settings = {
      analysis = {
        autoSearchPaths = true,
        diagnosticNode = "openFilesOnly",
        useLibraryCodeForTypes = true,
      },
    },
  },
  ruby_lsp = {
    cmd = { "ruby-lsp" },
    filetypes = { "ruby", "eruby" },
    init_option = {
      formattter = "auto"
    },
  },
  rust_analyzer = {
    cmd = { "rust-analyzer" },
    root_marker = { "Cargo.toml" },
    filetypes = { "rust" },
  },
  ts_ls = {
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
  },
}
