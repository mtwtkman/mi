local M = {}

function M.fzf_to_qf(fzf_source_cmd, label, extra_opts, parse_fn)
  local temp_file = vim.fn.tempname()
  local origin_buf = vim.api.nvim_get_current_buf()
  local origin_path = vim.api.nvim_buf_get_name(origin_buf)

  local fzf_cmd = fzf_source_cmd .. " | fzf " .. (extra_opts or "") .. " > " .. temp_file

  local old_shada = vim.o.shada
  vim.o.shada = ""

  vim.cmd("botright 10split")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_var(buf, "is_fzf_term", true)
  vim.bo[buf].buflisted = false

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

      if #lines <= 0 then return end

      local items = {}
      for _, line in ipairs(lines) do
        local res = parse_fn(line, origin_path)
        if not res then goto continue end
        local item = {
          text = res.text or label,
          lnum = res.lnum or 1,
          col = res.col or 1,
        }

        if res.bufnr then
          item.bufnr = res.bufnr
        elseif res.filename == origin_path then
          item.bufnr = origin_buf
        else
          item.filename = res.filename
        end
        table.insert(items, item)
        ::continue::
      end

      if #items <= 0 then return end

      vim.fn.setqflist(items, "r")
      vim.fn.setqflist({}, "a", { title = label })
      vim.cmd("botright copen 10")
      local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
      if qf_winid > 0 then vim.api.nvim_set_current_win(qf_winid) end
    end
  })
  vim.cmd("startinsert")
end

return M
