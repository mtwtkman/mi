local qf_finder = require("local_plugins.quickfix.app.finder")

vim.api.nvim_create_user_command("CopyCurrentFileRelativePath", function(params)
  local value = "%:."
  if params.bang == true then
    value = "%:.:h"
  end
  local content = vim.fn.expand(value)
  vim.fn.setreg("+", content)
  vim.fn.setreg('"', content)
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

local function resize_window_by_ratio(direction, percentage)
  local win = vim.api.nvim_get_current_win()
  local ratio = tonumber(percentage) / 100
  if ratio == nil or ratio > 100 then
    return
  end
  if direction == "v" then
    vim.cmd("vertical resize " .. math.floor(vim.o.columns * ratio))
  else
    vim.cmd("resize " .. math.floor(vim.o.lines * ratio))
  end
  vim.opt.wfh = true
  vim.opt.wfw = true
end

vim.api.nvim_create_user_command("ResizeWindowHorizontal", function(params) resize_window_by_ratio("h", params.args) end, { nargs = 1 })
vim.api.nvim_create_user_command("ResizeWindowVertical", function(params) resize_window_by_ratio("v", params.args) end, { nargs = 1 })

vim.api.nvim_create_user_command("RelativeNumberToggle", function() vim.opt.relativenumber = not vim.o.relativenumber end, {})

vim.api.nvim_create_user_command("Grep", function(opts)
  qf_finder.live_grep(opts.args)
end, { nargs = "*" })

vim.api.nvim_create_user_command("LspInfo", function() vim.cmd("checkhealth vim.lsp") end, {})
vim.api.nvim_create_user_command("LspLog", function() vim.cmd("tabe " .. vim.lsp.get_log_path()) end, {})
vim.api.nvim_create_user_command("LspRestart", function() vim.lsp.stop_client(vim.lsp.get_clients()) end, {})
