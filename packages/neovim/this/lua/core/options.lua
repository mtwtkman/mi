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

vim.cmd.syntax("enable")
vim.cmd.filetype({ "plugin", "indent", "on" })
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.ruler = true
vim.opt.title = true
vim.opt.showtabline = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.cmdheight = 2
vim.opt.wrap = false
vim.opt.scrolloff = 5
vim.opt.signcolumn = "yes"
vim.cmd.highlight({"Normal", "guibg=NONE", "ctermbg=NONE"})
vim.o.statusline = "%!v:lua.require('core.statusline').render()"
vim.cmd.colorscheme("mi")

vim.opt.completeopt = {
  menu = true,
  menuone = true,
  select = false,
}
