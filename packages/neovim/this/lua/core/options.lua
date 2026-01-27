vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 0
vim.g.mapleader = ","

vim.opt.hidden = true
vim.opt.undofile = true
vim.opt.encoding = "UTF-8"
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.showmatch = true
vim.opt.whichwrap = {
  b = true,
  s = true,
  h = true,
  l = true,
  ["<"] = true,
  [">"] = true,
  ["["] = true,
  ["]"] = true,
}
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.history = 1000
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.foldmethod = "marker"
vim.opt.mouse = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.updatetime = 300
vim.opt.shortmess:append("c")
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.switchbuf = { "useopen", "uselast" }
