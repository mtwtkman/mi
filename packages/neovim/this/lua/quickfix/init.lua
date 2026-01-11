local util = require("utils")
local finder = require("quickfix.app.finder")

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

util.nmap("<leader>gw", ":Grep <C-r><C-w><CR>", { silent = true })
util.nmap("<Leader>gg", ":Grep ")
util.nmap("<leader>b", finder.find_recent_buffers, { silent = true })
util.nmap("<leader>/", finder.buffer_search)
util.nmap("<leader>o", finder.find_files, { silent = true })

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = { "grep", "vimgrep" },
  command = "cwindow",
})
