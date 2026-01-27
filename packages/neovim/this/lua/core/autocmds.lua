local utils = require("utils")

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  group = vim.api.nvim_create_augroup("AutoRemoveTrailBlanks", { clear = true }),
  command = ":%s/\\s\\+$//ge",
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("MkdirBeforeSave", { clear = true }),
  callback = function(event)
    local dir = vim.fn.fnamemodify(event.match, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

if utils.is_wsl() then
  local yank_to_clip = vim.api.nvim_create_augroup("YankToClip", { clear = true })
  vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    pattern = { "*" },
    group = yank_to_clip,
    command = ':call system("clip.exe", @")'
  })
end
