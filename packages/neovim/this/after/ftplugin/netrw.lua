local nmap = require("utils").nmap

local function toggle_netrw()
  if vim.bo.filetype == "netrw" then
    vim.cmd("Lexplore")
  else
    vim.cmd("Lexplore %:h")
  end
end

nmap("<leader>n", toggle_netrw, { silent = true })
nmap("a", "%", { buffer = true, remap = true })
nmap("l", "<CR>", { buffer = true, remap = true, nowait = true })
