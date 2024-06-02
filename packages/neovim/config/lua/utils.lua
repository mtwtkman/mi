local M = {}

function M.each(f, ary)
  for i = 1, #ary, 1 do
    f(ary[i])
  end
end

function M.optional_value(x, default)
  if (x == nil) then
    return default
  end
  return x
end

function M.create_map(mode, lhs, rhs, value, options)
  vim.keymap.set(mode, lhs, rhs, value, M.optional_value(options, {}))
end

function M.nmap(lhs, rhs, value, options)
  M.create_map("n", lhs, rhs, value, options)
end

function M.vmap(lhs, rhs, value, options)
  M.create_map("v", lhs, rhs, value, options)
end

function M.tmap(lhs, rhs, value, options)
  M.create_map("t", lhs, rhs, value, options)
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

function M.copy_table(t)
  local t2 = {}
  for k, v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function M.merge_table(a, b)
  local copied_a = M.copy_table(a)
  for k, v in pairs(b) do
    copied_a[k] = v
  end
  return copied_a
end

return M
