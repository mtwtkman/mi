local util = require("utils")
local finder = require("quickfix.app.finder")
local directory_traveler = require("quickfix.app.directory_traveler")
local lsp = require("quickfix.app.lsp")

if vim.fn.executable("rg") == 1 then
  vim.o.grepprg = "rg --vimgrep --smart-case --hidden"
  vim.o.grepformat = "%f:%l:%c:%m"
end

vim.api.nvim_create_user_command("Grep", function(opts)
  finder.live_grep(opts.args)
end, { nargs = "*" })

util.nmap("<leader>gw", function() finder.live_grep(vim.fn.expand("<cword>")) end, { silent = true })
util.nmap("<Leader>gg", finder.live_grep, { silent = true })
util.nmap("<leader>b", finder.find_recent_buffers, { silent = true })
util.nmap("<leader>/", finder.buffer_search)
util.nmap("<leader>o", finder.find_files, { silent = true })
util.nmap("<leader>l", lsp.symbols, { silent = true })
util.nmap("<leader>n", finder.find_directories, { silent = true })

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = { "grep", "vimgrep" },
  command = "cwindow",
})

local function register_directory_selector()
  util.nmap("<CR>", function()
    local qf_info = vim.fn.getqflist({ title = 1, items = 1, idx = 0 })
    local item = qf_info.items[qf_info.idx]
    if not item then return end
    local path = vim.api.nvim_buf_get_name(item.bufnr)
    if qf_info.title == "Change Directory" then
      local path = ""
      if item.bufnr > 0 then
        path = vim.api.nvim_buf_get_name(item.bufnr)
      else
        path = item.filename or ""
      end
      vim.api.nvim_win_close(0, true)
      directory_traveler.push_directory(path)
      vim.cmd("Ex" .. vim.fn.fnameescape(path))
    else
      vim.api.nvim_win_close(0, true)
      vim.cmd(qf_info.idx .. "cc")
    end
  end, { buffer = true, silent = true })
end

util.nmap("<leader>p", directory_traveler.pop_directory, { silent = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    register_directory_selector()
  end,
})
