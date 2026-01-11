local fzf_to_qf = require("quickfix.processor").fzf_to_qf
local M = {}

function M.find_files()
  fzf_to_qf("fd --type f --strip-cwd-prefix", "Files")
end

function M.find_recent_buffers()
  local bufs = vim.api.nvim_list_bufs()
  local lines = {}

  for _, bufnr in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      local name = vim.api.nvim_buf_get_name(bufnr)
      local status, is_fzf = pcall(vim.api.nvim_buf_getr_var, bufnr, "is_fzf_term")
      if status and is_fzf then
        -- noop
      elseif name ~= "" then
        local display = name:match("*term://") and string.format("[%d] %s", bufnr, name) or vim.fn.fnamemodify(name, ":~:.")
        table.insert(lines, display)
      end
    end
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
  local source = "echo '" .. table.concat(unique_lines, "\n") .. "'"
  fzf_to_qf(source, "Buffers")
end

function M.buffer_search()
  local file = vim.fn.expand("%")
  local cmd = "grep -n '' " .. vim.fn.shellescape(file)
  fzf_to_qf(cmd, "Buffer Search", "--no-preview")
end

return M
