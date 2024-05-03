require("gitlinker").setup()

vim.keymap.set({ "n", "v" }, "<leader>gl", "<CMD>GitLink<CR>", { silent = true, noremap = true, desc = "Copy git permalink to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>gL", "<CMD>GitLink!<CR>", { silent = true, noremap = true, desc = "Open git permalink to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>gb", "<CMD>GitLink blame<CR>", { silent = true, noremap = true, desc = "Copy git blame permalink to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>gB", "<CMD>GitLink! blame<CR>", { silent = true, noremap = true, desc = "Open git blame permalink to clipboard" })
