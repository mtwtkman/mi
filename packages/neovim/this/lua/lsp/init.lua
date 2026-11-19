local config = require("lsp.config").make_default()
local servers = require("lsp.servers")

vim.lsp.config("*", {
  capabilities = config.capabilities,
  on_attach = config.on_attach,
  flags = config.flags,
})

for server_name, server_config in pairs(servers) do
  vim.lsp.config[server_name] = server_config
  vim.lsp.enable(server_name)
end
