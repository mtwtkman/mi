local util = require("utils")
if vim.fn.executable("rg") == 1 then
  vim.o.grepprg = "rg --vimgrep --smart-case --hidden"
  vim.o.grepformat = "%f:%l:%c:%m"
end

vim.api.nvim_create_user_command("Grep", function(opts)
  vim.cmd("silent grep! " .. opts.args)
  vim.cmd("redraw!")
  vim.cmd("cwindow")
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "quickfix" then
      vim.api.nvim_set_current_win(win)
      break
    end
  end
end, { nargs = "+" })

local function fzf_to_qf(fzf_source_cmd, label, extra_opts)
  local temp_file = vim.fn.tempname()
  local opts = extra_opts or ""
  local fzf_cmd = fzf_source_cmd .. " | fzf " .. opts .. " > " .. temp_file

  local old_shada = vim.o.shada
  vim.o.shada = ""

  vim.cmd("split")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)

  vim.fn.termopen(fzf_cmd, {
    on_exit = function()
      vim.o.shada = old_shada
      local lines = {}
      local f = io.open(temp_file, "r")
      if f then
        for line in f:lines() do table.insert(lines, line) end
        f:close()
      end
      os.remove(temp_file)

      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end

      if #lines > 0 then
        local items = {}
        for _, line in ipairs(lines) do
          local filename, lnum, text

          local f_path, f_lnum, f_text = line:match("([^:]+):(%d+):(.*)")
          if f_path and vim.fn.filereadable(f_path) == 1 then
            filename, lnum, text = f_path, f_lnum, f_text
          else
            local b_lnum, b_text = line:match("(%d+):(.*)")
            if b_lnum then
              filename = vim.api.nvim_buf_get_name(0)
              lnum, text = b_lnum, b_text
            else
              filename, lnum, text = line, 1, label or "FZF"
            end
          end
          if filename and filename ~= "" then
            table.insert(items, { filename = filename, lnum = tonumber(lnum) or 1, col = 1, text = text or "" })
          end
        end

        if #items == 0 then return end

        vim.fn.setqflist(items)
        vim.cmd("botright copen 10")
        local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
        if qf_winid > 0 then vim.api.nvim_set_current_win(qf_winid) end
      end
    end
  })
  vim.cmd("startinsert")
end

local function fzf_files()
  fzf_to_qf("fd --type f --strip-cwd-prefix", "Files")
end
util.nmap("<leader>ff", fzf_files, { silent = true })

local function fzf_recent_buffers()
  local bufs = vim.api.nvim_list_bufs()
  local lines = {}

  for _, bufnr in ipairs(bufs) do
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name ~= "" and not name:match("term://") then
      local rel_path = vim.fn.fnamemodify(name, ":~:.")
      table.insert(lines, rel_path)
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
util.nmap("<leader>fb", fzf_recent_buffers, { silent = true })

local function fzf_buffer_search()
  local file = vim.fn.expand("%")
  local cmd = "grep -n '' " .. vim.fn.shellescape(file)
  fzf_to_qf(cmd, "Buffer Search", "--no-preview")
end
util.nmap("<leader>fl", fzf_buffer_search)

util.nmap("<leader>gw", ":Grep <C-r><C-w><CR>", { silent = true })
util.nmap("<Leader>G", ":Grep ")

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = { "grep", "vimgrep" },
  command = "cwindow",
})

