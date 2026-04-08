local function github(repo)
  return "https://github.com/" .. repo
end

vim.pack.add({
  github("nvim-lua/plenary.nvim"),
  github("hrsh7th/cmp-nvim-lsp"),
  github("hrsh7th/cmp-path"),
  github("hrsh7th/nvim-cmp"),
  github("hrsh7th/cmp-cmdline"),
  github("hrsh7th/cmp-buffer"),
  github("lewis6991/gitsigns.nvim"),
  github("sindrets/diffview.nvim"),
  github("NeogitOrg/neogit"),
  github("linrongbin16/gitlinker.nvim"),
})

function setup_nvim_cmp()
  local cmp = require("cmp")
  local all_snippets = require("core.snippets")
  local snippets_source = {}
  snippets_source.new = function()
    return setmetatable({}, { __index = snippets_source })
  end
  function snippets_source:complete(params, callback)
    local ft = vim.bo.filetype
    local snips = all_snippets[ft] or {}
    local items = {}
    for trigger, body in pairs(snips) do
      table.insert(items, {
        label = trigger,
        kind = cmp.lsp.CompletionItemKind.Snippet,
        insertText = body,
        insertTextFormat = cmp.lsp.InsertTextFormat.Snippet,
      })
    end
    callback(items)
  end
  cmp.register_source("snippets", snippets_source.new())
  local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end
  cmp.setup({
    enabled = function()
      return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt"
    end,
    snippet = {
      expand = function(args)
        vim.snippet.expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered({ border = "rounded" }),
      documentation = cmp.config.window.bordered({ border = "rounded" }),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-o>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.snippet.active({ direction = 1 }) then
          vim.snippet.jump(1)
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.snippet.active({ direction = -1 }) then
          vim.snippet.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" },
      { name = "snippets" },
    }),
  })
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
end
setup_nvim_cmp()

require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map("n", "]c", function()
      if vim.wo.diff then return "]c" end
      vim.schedule(gs.next_hunk)
      return "<Ignore>"
    end, { expr=true })

    map("n", "[c", function()
      if vim.wo.diff then return "[c" end
      vim.schedule(gs.prev_hunk)
      return "<Ignore>"
    end, { expr=true })

    map({"n", "v"}, "<leader>hs", ":Gitsigns stage_hunk<CR>")
    map({"n", "v"}, "<leader>hr", ":Gitsigns reset_hunk<CR>")
    map("n", "<leader>hS", gs.stage_buffer)
    map("n", "<leader>hu", gs.undo_stage_hunk)
    map("n", "<leader>hR", gs.reset_buffer)
    map("n", "<leader>hp", gs.preview_hunk)
    map("n", "<leader>hP", gs.preview_hunk_inline)
    map("n", "<leader>hb", function() gs.blame_line({ full=true }) end)
    map("n", "<leader>tb", gs.toggle_current_line_blame)
    map("n", "<leader>hd", gs.diffthis)
    map("n", "<leader>hD", function() gs.diffthis("~") end)
    map("n", "<leader>td", gs.toggle_deleted)
    map({"o", "x"}, "ih", ":<C-u>Gitsigns select_hunk<CR>")
  end,
  preview_config = {
    border = { "╭", "─" ,"╮", "│", "╯", "─", "╰", "│" },
  },
})

require("diffview").setup({
  use_icons = false,
  keymaps = {
    view = {
      { "n", "q", require("diffview.actions").close, { silent = true } },
    },
  },
})

require("neogit").setup({
  integrations = {
    diffview = true,
    telescope = false,
  },
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "haskell", "lhaskell", "cabal", "cabalproject" },
  callback = function()
    if (vim.g.haskell_tools ~= nil) then
      return
    end
    vim.pack.add({
      { src = github("mrcjkb/haskell-tools.nvim"), version = vim.version.range("^8") },
    })
    local lsp_config = require("lsp.config").make_default()
    vim.g.haskell_tools = {
      hls = {
        on_attach = function(client, bufnr, ht)
          vim.keymap.set("n", "<space>hs", ht.hoogle.hoogle_signature, { silent = true })
          vim.keymap.set("n", "<space>E", ht.lsp.buf_eval_all, { silent = true })
          return lsp_config.on_attach(client, bufnr)
        end,
      },
    }
    vim.cmd("edit") -- hacky
  end,
})
