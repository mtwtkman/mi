local actions = require("diffview.actions")

require("diffview").setup({
  keymaps = {
    view = {
      { "n", "q", actions.close, { desc = "Close the diffview buffer" } },
    },
  },
})
