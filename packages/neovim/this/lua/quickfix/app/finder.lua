local fzf_to_qf = require("quickfix.processor").fzf_to_qf
local parser = require("quickfix.parser")

local M = {}

function M.find_files()
  fzf_to_qf("fd --type f -H -E '.git' --strip-cwd-prefix", "Files", "", parser.grep_style)
end

function M.find_recent_buffers()
  local bufs = vim.api.nvim_list_bufs()
  local lines = {}

  for _, bufnr in ipairs(bufs) do
    local name = vim.api.nvim_buf_get_name(bufnr)

    if vim.bo[bufnr].filetype == "netrw" or vim.fn.isdirectory(name) == 1 then
      goto continue
    end

    local status, is_fzf = pcall(vim.api.nvim_buf_getr_var, bufnr, "is_fzf_term")
    if status and is_fzf then
      goto continue
    end

    local rel_name = name:match("term://") and string.format("[%d] %s", bufnr, name) or vim.fn.fnamemodify(name, ":~:.")
    table.insert(lines, rel_name)
    ::continue::
  end
  if #lines == 0 then
    print("No buffer history in this session.")
    return
  end
  local seen = {}
  local unique_lines = {}
  for i = #lines, 1, -1 do
    if not seen[lines[i]] then
      table.insert(unique_lines, lines[i])
      seen[lines[i]] = true
    end
  end
  local source = "echo " .. vim.fn.shellescape(table.concat(unique_lines, "\n"))
  fzf_to_qf(source, "Buffers", "--prompt='Buffers> ' --tiebreak=index", parser.file_or_term)
end

function M.buffer_search()
  local file = vim.fn.expand("%")
  local cmd = "grep -n '' " .. vim.fn.shellescape(file)
  fzf_to_qf(cmd, "Buffer Search", "--no-preview", parser.buffer_local)
end

function M.live_grep(query)
  local search_query = query or ""
  if search_query == "" then
    search_query = vim.fn.input("Search Word > ")
    vim.cmd("redraw")
  end
  if search_query == "" then return end
  local word = vim.fn.shellescape(search_query)
  local cmd = string.format("rg --vimgrep --smart-case %s", word)
  fzf_to_qf(
    cmd,
    "Grep",
    "--prompt='Grep(" .. word .. ")> '",
    parser.grep_style
  )
end

return M
