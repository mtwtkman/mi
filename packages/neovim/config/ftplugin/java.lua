local jdtls = require("jdtls")
local root_markers = { 'gradlew', '.git' }
local root_dir = require('jdtls.setup').find_root(root_markers)
local home = os.getenv('HOME')
local workspace = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local cmd = { "jdtls", "-data", workspace }
local config = require("lsp").make_default_config()
local bundles = {}

config.cmd = cmd
config.root_dir = root_dir
config.init_options = {
  bundles = bundles,
}
jdtls.start_or_attach(config)
