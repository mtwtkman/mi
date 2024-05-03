local utils = require("utils")
local lsp = require("lsp")

local make_config = function(server_info)
  local default = lsp.make_default_config()

  if server_info.config == nil then
    return default
  end

  return utils.merge_table(default, server_info.config)
end

local configure_lsp = function(langtype)
  local server_info = require("plugins.nvim-lspconfig.lang." .. langtype)
  local config = make_config(server_info)
  require("lspconfig")[server_info.servername].setup(config)
end

require("lspconfig.ui.windows").default_options = {
  border = "rounded",
}

local path = {
  source = utils.get_dir(debug.getinfo(1, "S").source) .. "/lang",
}
utils.iterate_child_modules(path, configure_lsp)
