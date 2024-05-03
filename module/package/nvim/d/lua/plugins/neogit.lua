local utils = require("utils")
local neogit = require("neogit")

utils.nmap("<leader>gc", ":Neogit<CR>", { silent = true })
utils.nmap("<leader>Gc", function() neogit.open({ kind = "floating" }) end, { silent = true })

neogit.setup({
  integrations = {
    diffview = true,
    telescope = false,
  },
})
