local utils = require("utils")
local grapple = require("grapple")

utils.nmap("<leader>mg", grapple.toggle)
utils.nmap("<leader>mn", function() grapple.cycle_tags("next") end)
utils.nmap("<leader>mp", function() grapple.cycle_tags("prev") end)

grapple.setup({
  statusline = {
    icon = "G",
  },
})
