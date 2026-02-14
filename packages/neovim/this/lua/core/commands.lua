local qf_finder = require("local_plugins.quickfix.app.finder")

local function copy_current_buffer_path(is_absolute, is_directory)
  local value = "%:."
  if is_directory == true then
    value = "%:.:h"
  end
  local content = vim.fn.expand(value)
  if is_absolute == true then
    content = vim.fs.abspath(content)
  end
  vim.fn.setreg("+", content)
  vim.fn.setreg('"', content)
end

vim.api.nvim_create_user_command("CopyCurrentFileRelativePath", function(params)
  copy_current_buffer_path(false, params.bang)
end, { bang = true })

vim.api.nvim_create_user_command("CopyCurrentFileAbsolutePath", function(params)
  copy_current_buffer_path(true, params.bang)
end, { bang = true })


vim.api.nvim_create_user_command("ReloadInitLua", function()
  vim.cmd[[luafile $MYVIMRC]]
end, {})

vim.api.nvim_create_user_command("ReloadCurrentLuaFile", function()
  vim.cmd[[luafile %]]
end, {})

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

vim.api.nvim_create_user_command("QuickfixView", function(opts)
  local output = vim.fn.execute(opts.args)
  vim.fn.setqflist({}, "r", {
    title = opts.args,
    lines = vim.split(output, "\n", { trimempty = true }),
  })
  vim.cmd("copen")
end, { nargs = 1, complete = 'command'})

vim.api.nvim_create_user_command("FocusFile", function() vim.cmd("tabe %") end, {})
