local M = {}

local dir_stack = {}

function M.push_directory(path)
  if not path or path == "" then return end

  local current_dir = vim.fn.getcwd()
  table.insert(dir_stack, current_dir)

  vim.cmd("lcd " .. vim.fn.fnameescape(path))
  print("Pushd: " .. path)
end

function M.pop_directory()
  if #dir_stack == 0 then
    vim.notify("Directory stack is empty", vim.log.levels.WARN)
    return
  end

  local target_dir = table.remove(dir_stack)

  vim.cmd("lcd " .. vim.fn.fnameescape(target_dir))
  print("Popd: " .. target_dir .. " (Stack: " .. #dir_stack .. " left)")
end

return M
