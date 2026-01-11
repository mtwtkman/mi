local nmap = require("utils").nmap;

local function open_qf_entry(cmd)
  local entry = vim.fn.getqflist()[vim.fn.line(".")]
  if not entry then return end

  vim.cmd("cclose")
  if entry.bufnr > 0 then
    vim.cmd(cmd .. " sbuffer " .. entry.bufnr)
  else
    local edit_cmd = (cmd == "vertical" and "vsplit" or (cmd == "tab" and "tabedit" or "edit"))
    vim.cmd(edit_cmd .. " " .. vim.fn.fnameescape(entry.filename))
  end
  vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })
end

vim.wo.wrap = false
nmap("q", ":q<CR>", { silent = true, buffer = true })
nmap("<CR>", function() open_qf_entry("") end, { buffer = true, silent = true })
nmap("s", function() open_qf_entry("") end, { buffer = true, silent = true })
nmap("v", function() open_qf_entry("vertical") end, { buffer = true, silent = true })
nmap("t", function() open_qf_entry("tab") end, { buffer = true, silent = true})
