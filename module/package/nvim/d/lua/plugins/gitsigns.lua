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
})
