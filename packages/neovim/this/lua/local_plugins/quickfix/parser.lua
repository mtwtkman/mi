local M = {}

function M.grep_style(line, _)
  local path, lnum, text = line:match("([^:]+):(%d+):(.*)")
  if path and lnum then
    return { filename = path, lnum = tonumber(lnum), text = text }
  end
  return { filename = line, lnum = 1, text = "Selected file" }
end

function M.buffer_local(line, origin_path)
  local lnum, text = line:match("^(%d+):(.*)")
  if lnum then
    return { filename = origin_path, lnum = tonumber(lnum), text = text }
  end
end

function M.file_or_term(line, _)
  local bnum, tname = line:match("^%[(%d+)%]%s*(term://.*)")
  if bnum then
    return { bufnr = tonumber(bnum), text = tname }
  end
  if line ~= "" then
    return { filename = line, text = "Buffer" }
  end
end

function M.directory_path(line, _)
  if line ~= "" then
    return { filename = line, text = "Directory" }
  end
end

return M
