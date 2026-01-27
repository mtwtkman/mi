if vim.loader then
  vim.loader.enable()
end
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("core.options")
require("core.terminal")
require("plugins")
require("core.commands")
require("core.autocmds")
require("core.keymaps")

require("style")
require("lsp")
require("quickfix")
require("statusline")
vim.cmd.colorscheme("mi")
