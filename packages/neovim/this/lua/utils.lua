local M = {}

function M.each(f, ary)
  for i = 1, #ary, 1 do
    f(ary[i])
  end
end

function M.compoase(a, b)
  return function(args)
    return a(b(args))
  end
end

function M.get_dir(current_filepath)
  return current_filepath:match("^@?(.+)/[^/]+.lua$")
end

function M.list_siblings(dir)
  local self_name = dir:match(".+/([^/]+)/?$"):gsub("-", "%%-")

  local exclude = function(path)
    local p1 = (path:match("/" .. self_name .. "/[^/]+.lua$") ~= nil) and
        (path:match("/" .. self_name .. "/init.lua$") == nil)
    local p2 = (path:match("/" .. self_name .. "/[^/]+/[^/]+.lua$") ~= nil) and
        (path:match("/" .. self_name .. "/[^/]+/init.lua$") ~= nil)
    return not (p1 or p2)
  end

  local names = {}
  for line in io.popen("fd -d 2 .lua$ " .. dir):lines() do
    if exclude(line) then
      goto continue
    end
    names[#names + 1] = line
    ::continue::
  end
  return names
end

function M.get_module_name(path)
  local fromdir = path:match("/([^/]+)/init.lua$")
  if fromdir ~= nil then
    return fromdir
  end

  return path:match(".+/([^/]+).lua$")
end

function M.iterate_child_modules(info, callback)
  local path = info.source
  local current_dir = (function()
    if path:match("lua$")
    then
      return M.get_dir(path)
    else
      return path
    end
  end)()
  local siblings = M.list_siblings(current_dir)
  M.each(M.compoase(callback, M.get_module_name), siblings)
end

function M.copy_to_clipboard(content)
  vim.fn.setreg("+", content)
  vim.fn.setreg('"', content)
end

return M
