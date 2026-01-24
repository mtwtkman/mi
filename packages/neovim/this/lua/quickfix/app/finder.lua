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
    if rel_name ~= "" and vim.fn.isdirectory(vim.fn.expand(rel_name)) == 0 then table.insert(lines, rel_name) end
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

local is_mac = vim.loop.os_uname().sysname == "Darwin"
_G.fzf_to_qf_grep_preview_conf = {
  color_start = is_mac and [[\033[1m]] or [[\x1b[1m]],
  color_reset = is_mac and [[\033[0m]] or [[\x1b[0m]]
}

function M.live_grep(query)
  local search_query = query or ""
  local word = (search_query ~= "") and vim.fn.shellescape(search_query) or "' '"
  local cmd = string.format("rg --vimgrep --smart-case %s .", word)
  local cs = _G.fzf_to_qf_grep_preview_conf.color_start
  local cr = _G.fzf_to_qf_grep_preview_conf.color_reset
  local prompt_str = "--prompt='Grep" .. (search_query == "" and "" or "(" .. search_query ..")") .. ">'"
  local preview_cmd = string.format("--preview \"cat {1} | sed '{2}s/.*/%s&%s/'\"", cs, cr)
  local fzf_options = {
    prompt_str,
    "--delimiter ':'",
    preview_cmd,
    "--preview-window 'right:50%:border-left:+{2}-/2:~3'"
  }
  fzf_to_qf(
    cmd,
    "Grep",
    table.concat(fzf_options, " "),
    parser.grep_style
  )
end

function M.find_directories()
  fzf_to_qf(
    "fd --type d -H -E '.git' --strip-cwd-prefix",
    "Change Directory",
    "--preview 'ls -F {1}'",
    parser.directory_path
  )
end

return M
