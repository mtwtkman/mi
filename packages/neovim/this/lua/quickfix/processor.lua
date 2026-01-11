local M = {}

function M.fzf_to_qf(fzf_source_cmd, label, extra_opts)
  local temp_file = vim.fn.tempname()
  local opts = extra_opts or ""
  local fzf_cmd = fzf_source_cmd .. " | fzf " .. opts .. " > " .. temp_file

  local origin_buf = vim.api.nvim_get_current_buf()
  local origin_path = vim.api.nvim_buf_get_name(origin_buf)

  local old_shada = vim.o.shada
  vim.o.shada = ""

  vim.cmd("botright 10split")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_var(buf, "is_fzf_term", true)

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

          if line:match("^term://") then
            filename = line
            lnum = 1
            text = "Terminal"
          else
            local f_path, f_lnum, f_text = line:match("([^:]+):(%d+):(.*)")
            if f_path and vim.fn.filereadable(f_path) == 1 then
              filename, lnum, text = f_path, f_lnum, f_text
            else
              local b_lnum, b_text = line:match("^(%d+):(.*)")
              if b_lnum then
                filename = origin_path
                lnum, text = b_lnum, b_text
              else
                filename, lnum, text = line, 1, label or "FZF"
              end
            end
          end

          if filename and filename ~= "" then
            local bufnr = (filename == origin_path) and origin_buf or vim.fn.bufnr(filename)
            table.insert(items, {
              bufnr = bufnr > 0 and bufnr or nil,
              filename = filename,
              lnum = tonumber(lnum) or 1,
              col = 1,
              text = text or ""
            })
          end
        end

        vim.fn.setqflist(items)
        vim.cmd("botright copen 10")
        local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
        if qf_winid > 0 then vim.api.nvim_set_current_win(qf_winid) end
      end
    end
  })
  vim.cmd("startinsert")
end

return M
