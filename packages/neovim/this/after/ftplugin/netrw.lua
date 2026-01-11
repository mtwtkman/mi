local nmap = require("utils").nmap

nmap("a", "%", { buffer = true, remap = true })
nmap("q", "<cmd>Lexplore<CR>", { buffer = true, silent = true, nowait = true })
nmap("l", "<CR>", { buffer = true, remap = true, nowait = true })
