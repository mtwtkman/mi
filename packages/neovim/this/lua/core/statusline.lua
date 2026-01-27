local modes = {
  ['n']  = 'NORMAL', ['niI'] = 'NORMAL', ['niR'] = 'NORMAL', ['niV'] = 'NORMAL',
  ['no'] = 'N-PEND', ['i']   = 'INSERT',  ['ic']  = 'INSERT', ['ix']  = 'INSERT',
  ['t']  = 'TERMINAL', ['v'] = 'VISUAL',  ['V']   = 'V-LINE', ['']  = 'V-BLOCK',
  ['R']  = 'REPLACE', ['Rv'] = 'V-REPL',  ['s']   = 'SELECT', ['S']   = 'S-LINE',
  [''] = 'S-BLOCK', ['c']  = 'COMMAND', ['cv']  = 'V-EX',   ['ce']  = 'EX',
  ['r']  = 'PROMPT',  ['rm'] = 'MORE',    ['r?'] = 'CONFIRM', ['!']   = 'SHELL',
}

local function get_mode()
  local m = vim.api.nvim_get_mode().mode
  return string.format(" [%s] ", modes[m] or m)
end

local function get_git_branch()
  local dict = vim.b.gitsigns_status_dict
  if dict and dict.head and dict.head ~= "" then
    return string.format("  %s ", dict.head)
  end
  return ""
end

local function get_relative_path()
  return " %f "
end

local function get_file_info()
  local fenc = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
  local ft = vim.bo.filetype ~= "" and vim.bo.filetype or "no ft"
  return string.format(" %s | %s ", fenc, ft)
end

local function get_lsp_status()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ""
  end

  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end

  return string.format(" [%s] ", table.concat(names, ", "))
end

local M = {}

M.render = function()
  return table.concat({
    "%#StatusLineMode#", get_mode(),
    "%#StatusLineGit#", get_git_branch(),
    "%#StatusLinePath#", get_relative_path(),
    "%m%r%h%w",
    "%=",
    "%#StatusLineLSP#", get_lsp_status(),
    get_file_info(),
    " %l:%c ",
  })
end

return M
