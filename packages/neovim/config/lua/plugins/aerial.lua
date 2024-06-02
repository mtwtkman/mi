local aerial = require("aerial")
local nmap = require("utils").nmap

aerial.setup({
  on_attach = function(bufnr)
    nmap("{", "<cmd>AerialPrev<cr>", { buffer = bufnr })
    nmap("}", "<cmd>AerialNext<cr>", { buffer = bufnr })
  end,
})

nmap("<leader>l", ":lua require('aerial').toggle({focus = true})<cr>", { silent = true })
