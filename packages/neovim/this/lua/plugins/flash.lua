local flash = require("flash")
flash.setup({
  modes = {
    char = {
      jump_labels = true,
    },
  },
})

vim.keymap.set({ "n", "x", "o" }, "<C-s>", flash.jump)
vim.keymap.set({ "n", "x", "o" }, "S", flash.treesitter)
vim.keymap.set({ "o" }, "r", flash.remote)
vim.keymap.set({ "x", "o" }, "R", flash.treesitter_search)
vim.keymap.set({ "c" }, "<C-s>", flash.toggle)
