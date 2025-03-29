local utils = require("utils")
local config = require("lsp.config").make_default()

local lsp_info = function()
  vim.cmd("checkhealth vim.lsp")
end

local lsp_log = function()
  vim.cmd("tabe " .. vim.lsp.get_log_path())
end

local lsp_restart = function()
  vim.lsp.stop_client(vim.lsp.get_clients())
end

vim.api.nvim_create_user_command("LspInfo", lsp_info, {})
vim.api.nvim_create_user_command("LspLog", lsp_log, {})
vim.api.nvim_create_user_command("LspRestart", lsp_restart, {})

vim.lsp.config("*", {
  capabilities = config.capabilities,
  on_attach = config.on_attach,
  flags = config.flags,
})

local lsp_dir = {
  source = utils.get_dir(debug.getinfo(1, "S").source) .. "/../../lsp",
}

local enable_lsp_server = function(lsp)
  vim.lsp.enable(lsp:gsub(".lua", ""))
end

utils.iterate_child_modules(lsp_dir, enable_lsp_server)
