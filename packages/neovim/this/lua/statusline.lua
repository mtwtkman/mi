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
  local branch = vim.fn.system("git branch --show-current 2> /dev/null"):gsub("\n", "")
  if branch ~= "" then
    return string.format("  %s ", branch)
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
  if #clients > 0 then
    return " [LSP] "
  end
  return ""
end

_G.custom_statusline = function()
  return table.concat({
    "%#StatusLineMode#", get_mode(),
    "%#StatusLineGit#", get_git_branch(),
    "%#StatusLinePath#", get_relative_path(),
    "%m%r%h%w",
    "%=",
    get_lsp_status(),
    get_file_info(),
    " %l:%c ",
  })
end

vim.o.statusline = "%!v:lua.custom_statusline()"
