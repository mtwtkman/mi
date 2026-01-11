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

local function fzf_fd_to_quickfix()
  local temp_file = vim.fn.tempname()
  local fd_cmd = "fd --type f --strip-cwd-prefix"
  local fzf_cmd = fd_cmd .. " | fzf > " .. temp_file
  vim.cmd("split | terminal " .. fzf_cmd)
  vim.cmd("startinsert")
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = vim.api.nvim_get_current_buf(),
    callback = function()
      local lines = {}
      local f = io.open(temp_file, "r")
      if f then
        for line in f:lines() do table.insert(lines, line) end
        f:close()
      end
      os.remove(temp_file)

      local term_win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_close(term_win, true)

      if #lines > 0 then
        local items = {}
        for _, line in ipairs(lines) do
          table.insert(items, { filename = line, lnum = 1, col = 1, text = line })
        end
        vim.fn.setqflist(items)
        vim.cmd("copen")

        local qf_info = vim.fn.getqflist({ winid = 0 })
        if qf_info.winid > 0 then
          vim.api.nvim_set_current_win(qf_info.winid)
        end
      end
    end
  })
end

util.nmap("<leader>ff", fzf_fd_to_quickfix)

util.nmap("<leader>gw", ":Grep <C-r><C-w><CR>", { silent = true })
util.nmap("<Leader>G", ":Grep ")

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = { "grep", "vimgrep" },
  command = "cwindow",
})

