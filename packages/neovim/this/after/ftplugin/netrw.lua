local nmap = require("utils").nmap

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 20
vim.g.netrw_localrmdir = "rmdir"
nmap("a", "%", { buffer = true, remap = true })
nmap("q", "<cmd>Lexplore<CR>", { silent = true, buffer = true, nowait = true })
vim.opt_local.number = false
vim.opt_local.relativenumber = false
local function toggle_netrw()
  if vim.bo.filetype == "netrw" then
    vim.cmd("Rexplore")
  else
    vim.cmd("Lexplore")
  end
end
nmap("<leader>n", toggle_netrw, { silent = true })

local function mark_target_with_feedback()
  vim.cmd('normal mt')
  local target = vim.g.netrw_targetlocal or "Not Set"
  print("Target set to: " .. target)
end

vim.keymap.set('n', 't', mark_target_with_feedback, { buffer = true, desc = "Mark target and show path" })
vim.keymap.set('n', '?', function()
  local target = vim.g.netrw_targetlocal or "None"
  local marks = vim.fn.NetrwMarkList()
  print("Target: " .. target .. " | Marked: " .. table.concat(marks, ", "))
end, { buffer = true, desc = "Show Netrw status" })
