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
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("plugins")
require("core.options")
require("core.terminal")
require("core.commands")
require("core.autocmds")
require("core.keymaps")
require("lsp")
