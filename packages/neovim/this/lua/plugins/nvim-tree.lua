local set = vim.opt
local utils = require("utils")
local nmap = utils.nmap
local nvim_tree_api = require("nvim-tree.api")

nmap("<leader>n", ":NvimTreeFindFileToggle<CR>", { silent = true })
nmap("<C-w>n", ":NvimTreeFindFile<CR>", { silent = true })

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

set.termguicolors = true

local open_nvim_tree = function(data)
  local is_directory = vim.fn.isdirectory(data.file) == 1
  if not is_directory then
    return
  end
  vim.cmd.cd(data.file)
  nvim_tree_api.tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

local function on_attach(bufnr)
  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
  vim.keymap.set('n', '<C-]>', nvim_tree_api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', '<C-e>', nvim_tree_api.node.open.replace_tree_buffer, opts('Open: In Place'))
  vim.keymap.set('n', '<C-k>', nvim_tree_api.node.show_info_popup, opts('Info'))
  vim.keymap.set('n', '<C-r>', nvim_tree_api.fs.rename_sub, opts('Rename: Omit Filename'))
  vim.keymap.set('n', '<C-t>', nvim_tree_api.node.open.tab, opts('Open: New Tab'))
  vim.keymap.set('n', '<C-v>', nvim_tree_api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-x>', nvim_tree_api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<BS>', nvim_tree_api.node.navigate.parent_close, opts('Close Directory'))
  vim.keymap.set('n', '<CR>', nvim_tree_api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<Tab>', nvim_tree_api.node.open.preview, opts('Open Preview'))
  vim.keymap.set('n', '>', nvim_tree_api.node.navigate.sibling.next, opts('Next Sibling'))
  vim.keymap.set('n', '<', nvim_tree_api.node.navigate.sibling.prev, opts('Previous Sibling'))
  vim.keymap.set('n', '.', nvim_tree_api.node.run.cmd, opts('Run Command'))
  vim.keymap.set('n', '-', nvim_tree_api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', 'a', nvim_tree_api.fs.create, opts('Create'))
  vim.keymap.set('n', 'bmv', nvim_tree_api.marks.bulk.move, opts('Move Bookmarked'))
  vim.keymap.set('n', 'B', nvim_tree_api.tree.toggle_no_buffer_filter, opts('Toggle No Buffer'))
  vim.keymap.set('n', 'c', nvim_tree_api.fs.copy.node, opts('Copy'))
  vim.keymap.set('n', 'C', nvim_tree_api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
  vim.keymap.set('n', '[c', nvim_tree_api.node.navigate.git.prev, opts('Prev Git'))
  vim.keymap.set('n', ']c', nvim_tree_api.node.navigate.git.next, opts('Next Git'))
  vim.keymap.set('n', 'D', nvim_tree_api.fs.trash, opts('Trash'))
  vim.keymap.set('n', 'E', nvim_tree_api.tree.expand_all, opts('Expand All'))
  vim.keymap.set('n', 'e', nvim_tree_api.fs.rename_basename, opts('Rename: Basename'))
  vim.keymap.set('n', ']e', nvim_tree_api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
  vim.keymap.set('n', '[e', nvim_tree_api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
  vim.keymap.set('n', 'F', nvim_tree_api.live_filter.clear, opts('Clean Filter'))
  vim.keymap.set('n', 'f', nvim_tree_api.live_filter.start, opts('Filter'))
  vim.keymap.set('n', 'g?', nvim_tree_api.tree.toggle_help, opts('Help'))
  vim.keymap.set('n', 'gy', nvim_tree_api.fs.copy.absolute_path, opts('Copy Absolute Path'))
  vim.keymap.set('n', 'H', nvim_tree_api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
  vim.keymap.set('n', 'I', nvim_tree_api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
  vim.keymap.set('n', 'J', nvim_tree_api.node.navigate.sibling.last, opts('Last Sibling'))
  vim.keymap.set('n', 'K', nvim_tree_api.node.navigate.sibling.first, opts('First Sibling'))
  vim.keymap.set('n', 'm', nvim_tree_api.marks.toggle, opts('Toggle Bookmark'))
  vim.keymap.set('n', 'o', nvim_tree_api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'O', nvim_tree_api.node.open.no_window_picker, opts('Open: No Window Picker'))
  vim.keymap.set('n', 'p', nvim_tree_api.fs.paste, opts('Paste'))
  vim.keymap.set('n', 'P', nvim_tree_api.node.navigate.parent, opts('Parent Directory'))
  vim.keymap.set('n', 'q', nvim_tree_api.tree.close, opts('Close'))
  vim.keymap.set('n', 'r', nvim_tree_api.fs.rename, opts('Rename'))
  vim.keymap.set('n', 'R', nvim_tree_api.tree.reload, opts('Refresh'))
  vim.keymap.set('n', 's', nvim_tree_api.node.run.system, opts('Run System'))
  vim.keymap.set('n', 'S', nvim_tree_api.tree.search_node, opts('Search'))
  vim.keymap.set('n', 'U', nvim_tree_api.tree.toggle_custom_filter, opts('Toggle Hidden'))
  vim.keymap.set('n', 'W', nvim_tree_api.tree.collapse_all, opts('Collapse'))
  vim.keymap.set('n', 'x', nvim_tree_api.fs.cut, opts('Cut'))
  vim.keymap.set('n', 'y', nvim_tree_api.fs.copy.filename, opts('Copy Name'))
  vim.keymap.set('n', 'Y', nvim_tree_api.fs.copy.relative_path, opts('Copy Relative Path'))
  vim.keymap.set('n', '<2-LeftMouse>', nvim_tree_api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', nvim_tree_api.tree.change_root_to_node, opts('CD'))

  vim.keymap.set('n', '<C-v>', '', { buffer = bufnr })
  vim.keymap.del('n', '<C-v>', { buffer = bufnr })
  vim.keymap.set('n', '<C-t>', '', { buffer = bufnr })
  vim.keymap.del('n', '<C-t>', { buffer = bufnr })
  vim.keymap.set('n', '<2-RightMouse>', '', { buffer = bufnr })
  vim.keymap.del('n', '<2-RightMouse>', { buffer = bufnr })
  vim.keymap.set('n', '<C-x>', '', { buffer = bufnr })
  vim.keymap.del('n', '<C-x>', { buffer = bufnr })
  vim.keymap.set('n', 'bmv', '', { buffer = bufnr })
  vim.keymap.del('n', 'bmv', { buffer = bufnr })
  vim.keymap.set('n', 'd', '', { buffer = bufnr })
  vim.keymap.del('n', 'd', { buffer = bufnr })
  vim.keymap.set('n', '-', '', { buffer = bufnr })
  vim.keymap.del('n', '-', { buffer = bufnr })
  vim.keymap.set('n', '<BS>', '', { buffer = bufnr })
  vim.keymap.del('n', '<BS>', { buffer = bufnr })
  vim.keymap.set('n', 'o', '', { buffer = bufnr })
  vim.keymap.del('n', 'o', { buffer = bufnr })

  vim.keymap.set('n', 'v', nvim_tree_api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', 't', nvim_tree_api.node.open.tab, opts('Open: New Tab'))
  vim.keymap.set('n', 's', nvim_tree_api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', 'M', nvim_tree_api.marks.bulk.move, opts('Move Bookmarked'))
  vim.keymap.set('n', 'u', nvim_tree_api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', 'h', nvim_tree_api.node.navigate.parent_close, opts('Close Directory'))
  vim.keymap.set('n', 'l', nvim_tree_api.node.open.edit, opts('Open'))
end

local option = {
  on_attach = on_attach,
  diagnostics = {
    enable = true,
  },
}

if vim.env.NVIM_TREE_TRASH_COMMAND ~= nil then
  option.trash = {
    cmd = vim.env.NVIM_TREE_TRASH_COMMAND,
  }
end

require("nvim-tree").setup(option)
