local nmap = require("utils").nmap

vim.ui.select = require("dropbar.utils.menu").select

nmap("<leader><space>", require("dropbar.api").pick, { silent = true })
