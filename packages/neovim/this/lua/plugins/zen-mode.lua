local nmap = require("utils").nmap

nmap("<leader>z", require("zen-mode").toggle, { silent = true})
