local utils = require("utils")
local nmap = utils.nmap
local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
  defaults = {
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
      horizontal = {
        preview_width = 0.5
      }
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

nmap("<leader>o", function() builtin.find_files({hidden=true}) end, { silent = true })
nmap("<leader>fg", builtin.live_grep, { silent = true })
nmap("<leader>fw", builtin.grep_string, { silent = true })
nmap("<leader>b", function()
  builtin.buffers({
    attach_mappings = function(prompt_bufnr, map)
      local delete_buf = function()
        local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
        current_picker:delete_selection(function(selection)
          vim.api.nvim_buf_delete(selection.bufnr, { force = true })
        end)
      end
      map("n", "<C-d>", delete_buf)
      return true
    end,
  })
end, { silent = true })
nmap("<leader>hh", builtin.oldfiles, { silent = true })
nmap("<leader>h:", builtin.command_history, { silent = true })
nmap("<leader>h/", builtin.search_history, { silent = true })
nmap("<C-p>", builtin.commands, { silent = true })
nmap("<leader>/", builtin.current_buffer_fuzzy_find, { silent = true })
nmap("<space>q", builtin.diagnostics, { silent = true })
nmap("gr", builtin.lsp_references, { silent = true })
nmap("<leader>M", telescope.extensions.grapple.tags, { silent = true })
nmap("<leader>re", builtin.resume, { silent = true })

vim.api.nvim_create_user_command("Maps", builtin.keymaps, {})
vim.api.nvim_create_user_command("GitCommits", builtin.git_commits, {})
vim.api.nvim_create_user_command("GitBranches", builtin.git_branches, {})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("grapple")

local fuzzyFindFiles = function()
  builtin.grep_string({
    path_display = { "smart" },
    only_sort_Text = true,
    word_match = "-w",
    search = "",
  })
end

nmap("<leader>ff", fuzzyFindFiles, { silent = true })
