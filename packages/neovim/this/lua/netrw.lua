local nmap = require("utils").nmap

vim.g.netrw_keepdir = 0
vim.g.netrw_autochdir = 1
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 20
vim.g.netrw_localrmdir = "rmdir"
vim.opt_local.number = false
vim.opt_local.relativenumber = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    local function get_netrw_full_path()
      local dir = vim.b.netrw_curdir
      local file = vim.fn.expand("<cfile>")
      return dir .. (dir:match("/$") and "" or "/") .. file
    end

    vim.keymap.set("n", "Y", function()
      local path = get_netrw_full_path()
      vim.fn.setreg("+", path)
      vim.fn.setreg('"', path)
      print("Copied [ABS]: " .. path)
    end, { buffer = true, desc = "Copy absolute path from netrw" })

    vim.keymap.set("n", "y", function()
      local path = get_netrw_full_path()
      local rel_path = vim.fn.fnamemodify(path, ":.")
      vim.fn.setreg("+", rel_path)
      vim.fn.setreg('"', rel_path)
      print("Copied [REL]: " .. rel_path)
    end, { buffer = true, desc = "Copy relative path from netrw" })
  end
})
