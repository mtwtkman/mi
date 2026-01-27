local utils = require("utils")
local qf_finder = require("local_plugins.quickfix.app.finder")

vim.api.nvim_create_user_command("CopyCurrentFileRelativePath", function(params)
  local value = "%:."
  if params.bang == true then
    value = "%:.:h"
  end
  utils.copy_to_clipboard(vim.fn.expand(value))
end, { bang = true })

vim.api.nvim_create_user_command("ReloadInitLua", function()
  vim.cmd[[luafile $MYVIMRC]]
end, {})

vim.api.nvim_create_user_command("ReloadCurrentLuaFile", function()
  vim.cmd[[luafile %]]
end, {})

vim.api.nvim_create_user_command("OpenPathUnderCursor", function(params)
  vim.cmd(":" .. params.args .. " " .. vim.fn.expand("<cWORD>"))
end, { nargs = 1 })

vim.api.nvim_create_user_command("RenameFile", function()
    local old_name = vim.api.nvim_buf_get_name(0)
    if old_name == "" then
      print("Error: Buffer has no file name")
      return
    end
    local new_name = vim.fn.input("Rename to: ", old_name, "file")
    if new_name == "" or new_name == old_name then
      print("Rename cancelled")
      return
    end
    vim.cmd("write " .. vim.fn.fnameescape(new_name))
    local success, err = os.remove(old_name)
    if not success then
      print("Error deleting old file: " .. err)
      return
    end
    vim.cmd("bwipeout " .. vim.fn.fnameescape(old_name))
    vim.cmd("edit " .. vim.fn.fnameescape(new_name))
    print("Renamed to: " .. new_name)
end, {})

vim.api.nvim_create_user_command("CreateNewFile", function()
  local here = vim.fn.expand("%:p:h")
  local fullpath = vim.fn.input("Create new file: ", here .. "/", "file")
  vim.cmd("redraw")
  if fullpath == "" then
    print("Create cancelled")
    return
  elseif vim.fn.filereadable(fullpath) == 1 then
    local confirm = vim.fn.input("Already created. Open " .. fullpath .. "? [y/N]: ")
    vim.cmd("redraw")
    if confirm ~= "y" then
      print("")
      return
    end
    vim.cmd("split " .. fullpath)
    return
  end
  vim.cmd("split " .. fullpath .. " | write | startinsert")
  print("Created " .. fullpath)
end, {})

vim.api.nvim_create_user_command("FW", function()
  vim.fn.execute("resize " .. params.args)
  set.wfh = true
  set.wfw = true
end, { nargs = 1 })

vim.api.nvim_create_user_command("RelativeNumberToggle", function() vim.opt.relativenumber = not vim.o.relativenumber end, {})

vim.api.nvim_create_user_command("Grep", function(opts)
  qf_finder.live_grep(opts.args)
end, { nargs = "*" })
