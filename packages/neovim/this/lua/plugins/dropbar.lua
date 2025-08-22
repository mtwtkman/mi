local nmap = require("utils").nmap
local dropbar = require("dropbar")

vim.ui.select = require("dropbar.utils.menu").select

nmap("<leader><space>", require("dropbar.api").pick, { silent = true })

dropbar.setup({
  icons = {
    enable = false,
    ui = {
      menu = {
        indicator = '> ',
      },
      bar = {
        separator = '> ',
      },
    },
  },
})
