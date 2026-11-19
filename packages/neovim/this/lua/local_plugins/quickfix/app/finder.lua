local fzf_to_qf = require("local_plugins.quickfix.processor").fzf_to_qf
local parser = require("local_plugins.quickfix.parser")

local M = {}

function M.find_files()
  fzf_to_qf("fd --type f -H -E '.git' --strip-cwd-prefix", "Files", "", parser.grep_style)
end

function M.find_recent_buffers()
  local bufs = vim.api.nvim_list_bufs()
  local lines = {}

  for _, bufnr in ipairs(bufs) do
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      goto continue
    end

    local name = vim.api.nvim_buf_get_name(bufnr)

    if vim.bo[bufnr].filetype == "netrw" or vim.fn.isdirectory(name) == 1 then
      goto continue
    end

    local status, is_fzf = pcall(vim.api.nvim_buf_getr_var, bufnr, "is_fzf_term")

    if status and is_fzf then
      goto continue
    end

    local is_term = name:match("term://") == "term://"
    local rel_name = is_term and string.format("[%d] %s", bufnr, name) or vim.fn.fnamemodify(name, ":~:.")

    if rel_name == "" or vim.fn.isdirectory(vim.fn.expand(rel_name)) == 1 then
      goto continue
    end

    if is_term then
      local tmpdir = vim.fn.tempname()
      vim.fn.mkdir(tmpdir, "p")
      local tmp = vim.fs.joinpath(tmpdir, ("termbuf-%d"):format(bufnr))
      print(tmp)
      vim.fn.writefile(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), tmp)
      table.insert(lines, tmp)
      goto continue
    end
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

local ansi_esc = string.char(27)

function M.live_grep(query)
  local search_query = query or ""
  local word = (search_query ~= "") and vim.fn.shellescape(search_query) or "' '"
  local cmd = string.format("rg --vimgrep --smart-case %s . | awk -F: '!seen[$1\":\"$2]++'", word)
  local prompt_str = "--prompt='Grep" .. (search_query == "" and "" or "(" .. search_query ..")") .. ">'"
  local preview_cmd = string.format(
    "--preview \"cat {1} | sed '{2}s/.*/%s&%s/'\"",
    string.char(27) .. "[1;4m",
    string.char(27) .. "[0m"
  )
  local fzf_options = {
    prompt_str,
    "--delimiter ':'",
    preview_cmd,
    "--preview-window 'right:50%:border-left:+{2}-/2:~3'",
    "--ansi",
  }
  fzf_to_qf(
    cmd,
    "Grep",
    table.concat(fzf_options, " "),
    parser.grep_style
  )
end

return M
