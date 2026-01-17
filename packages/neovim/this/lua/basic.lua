local set = vim.opt
local utils = require("utils")
local nmap = utils.nmap

vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 0
set.hidden = true
set.undofile = true
set.encoding = "UTF-8"
set.shiftwidth = 2
set.smartindent = true
set.smarttab = true
set.showmatch = true
set.whichwrap = {
  b = true,
  s = true,
  h = true,
  l = true,
  ["<"] = true,
  [">"] = true,
  ["["] = true,
  ["]"] = true,
}
set.backup = false
set.writebackup = false
set.swapfile = false
set.history = 1000
set.incsearch = true
set.ignorecase = true
set.smartcase = true
set.foldmethod = "marker"
set.mouse = ""
set.clipboard = "unnamedplus"
if utils.is_wsl() then
  local yank_to_clip = vim.api.nvim_create_augroup("YankToClip", { clear = true })
  vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    pattern = { "*" },
    group = yank_to_clip,
    command = ':call system("clip.exe", @")'
  })
end
set.splitbelow = true
set.splitright = true
set.updatetime = 300
set.shortmess:append("c")
set.backspace = { "indent", "eol", "start" }
vim.g.mapleader = ","
nmap("<ESC><ESC>", ":<C-u>nohlsearch<CR>")

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  group = vim.api.nvim_create_augroup("AutoRemoveTrailBlanks", { clear = true }),
  command = ":%s/\\s\\+$//ge",
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("MkdirBeforeSave", { clear = true }),
  callback = function(event)
    local dir = vim.fn.fnamemodify(event.match, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})
vim.api.nvim_create_user_command("CopyCurrentFileRelativePath", function(data)
  local value = "%:."
  if data.bang == true then
    value = "%:.:h"
  end
  utils.copy_to_clipboard(vim.fn.expand(value))
end, { bang = true })
nmap("<leader>cf", ":CopyCurrentFileRelativePath<CR>", { silent = true })
nmap("<leader>cd", ":CopyCurrentFileRelativePath!<CR>", { silent = true })
nmap("<space>]", ":cd %:h<CR>", { silent = true })

vim.api.nvim_create_user_command("ReloadInitLua", function()
  vim.cmd[[luafile $MYVIMRC]]
end, {})

vim.api.nvim_create_user_command("ReloadCurrentLuaFile", function()
  vim.cmd[[luafile %]]
end, {})

nmap("<leader><c-r>", ":ReloadCurrentLuaFile<CR>", { silent = true })

local function gx_command()
  return ":silent execute '!xdg-open' shellescape(expand('<cfile>'), 1)<cr>"
end

nmap("gx", gx_command(), { silent = true })

vim.api.nvim_create_user_command("EditConfig", function()
  vim.fn.execute("e $MYVIMRC")
end, {})

nmap("<leader><c-t>", ":tabe %<cr>", { silent = true })

local function open_path_under_cursor(params)
  vim.cmd(":" .. params.args .. " " .. vim.fn.expand("<cWORD>"))
end

vim.api.nvim_create_user_command("OpenPathUnderCursor", open_path_under_cursor, { nargs = 1 })
nmap("Ov", ":OpenPathUnderCursor vsp<CR>", { silent = true })
nmap("Os", ":OpenPathUnderCursor sp<CR>", { silent = true })
nmap("Ot", ":OpenPathUnderCursor tabe<CR>", { silent = true })

vim.api.nvim_create_user_command('RenameFile', function()
    local old_name = vim.api.nvim_buf_get_name(0)
    if old_name == "" then
        print("Error: Buffer has no file name")
        return
    end
    local new_name = vim.fn.input('Rename to: ', old_name, 'file')
    if new_name == "" or new_name == old_name then
        print("Rename cancelled")
        return
    end
    vim.cmd('write ' .. vim.fn.fnameescape(new_name))
    local success, err = os.remove(old_name)
    if not success then
        print("Error deleting old file: " .. err)
        return
    end
    vim.cmd('bwipeout ' .. vim.fn.fnameescape(old_name))
    vim.cmd('edit ' .. vim.fn.fnameescape(new_name))
    print("Renamed to: " .. new_name)
end, {})
nmap("<space>rn", ":RenameFile<CR>")
