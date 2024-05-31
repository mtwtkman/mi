local utils = require("utils")
local nmap = utils.nmap
local vmap = utils.vmap

nmap("j", "gj")
nmap("k", "gk")
vmap("v", "$h")
nmap("<C-j>", "<C-w><C-j>")
nmap("<C-k>", "<C-w><C-k>")
nmap("<C-h>", "<C-w><C-h>")
nmap("<C-l>", "<C-w><C-l>")
