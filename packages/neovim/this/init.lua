if vim.loader then
  vim.loader.enable()
end
require("plugins")
require("core.options")
require("core.terminal")
require("core.commands")
require("core.autocmds")
require("core.keymaps")
require("lsp")
