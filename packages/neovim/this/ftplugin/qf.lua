local nmap = require("utils").nmap;

vim.wo.wrap = false
nmap("q", ":q<CR>", { silent = true, buffer = true })
nmap("<CR>", "<CR><cmd>cclose<CR>", { buffer = true, silent = true })
nmap("s", "<C-w><CR><cmd>cclose<CR>", { buffer = true, silent = true })
nmap("v", "<C-w><CR><C-w>L<cmd>cclose<CR>", { buffer = true, silent = true })
