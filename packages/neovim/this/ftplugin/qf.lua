local nmap = require("utils").nmap;

local function open_qf_entry(cmd)
  local entry = vim.fn.getqflist()[vim.fn.line(".")]
  if not entry then return end

  local current_buf = vim.api.nvim_get_current_buf()
  local target_buf = entry.bufnr > 0 and entry.bufnr or vim.fn.bufnr(entry.filename)

  local should_jump_only = (cmd == "" and targert_buf == current_buf)

  vim.cmd("cclose")

  if should_jump_only then
    -- noop
  elseif target_buf > 0 then
    local prefix = (cmd ~= "" and cmd .. " sbuffer " or "buffer ")
    vim.cmd(prefix .. target_buf)
  else
    local edit_cmd = (cmd == "vertical" and "vsplit" or (cmd == "tab" and "tabedit" or "edit"))
    vim.cmd(edit_cmd .. " " .. vim.fn.fnameescape(entry.filename))
  end
  vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })
  vim.cmd("normal! zz")
end

vim.wo.wrap = false
nmap("q", ":q<CR>", { silent = true, buffer = true })
nmap("<CR>", function() open_qf_entry("") end, { buffer = true, silent = true })
nmap("s", function() open_qf_entry("") end, { buffer = true, silent = true })
nmap("v", function() open_qf_entry("vertical") end, { buffer = true, silent = true })
nmap("t", function() open_qf_entry("tab") end, { buffer = true, silent = true})
