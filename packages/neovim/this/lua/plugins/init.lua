local lazy = require("lazy")
local c = require("color")

local plugins = {
  {
    "mtwtkman/nvim-web-devicons",
    branch = "mono",
    config = function()
      require("nvim-web-devicons").setup({
        variant = "mono",
        mono_color = { color = c.white, cterm_color = "15" },
      })
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "mtwtkman/nvim-web-devicons",
    },
    config = function()
      require("plugins.lualine")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("plugins.nvim-treesitter")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      {
        "mtwtkman/nvim-web-devicons",
      },
    },
    config = function()
      require("plugins.nvim-tree")
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "hrsh7th/cmp-path",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("plugins.nvim-cmp")
    end,
  },
  {
    "saadparwaiz1/cmp_luasnip",
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("plugins.LuaSnip")
    end,
  },
  {
    "hrsh7th/cmp-cmdline",
  },
  {
    "hrsh7th/cmp-buffer",
  },
  {
    "rcarriga/cmp-dap",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins.indent-blankline")
    end,
    main = "ibl",
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("plugins.nvim-dap")
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("plugins.nvim-dap-ui")
    end,
  },
  {
    "stevearc/aerial.nvim",
    config = function()
      require("plugins.aerial")
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "mtwtkman/nvim-web-devicons",
    },
  },
  {
    "s1n7ax/nvim-window-picker",
    config = function()
      require("plugins.nvim-window-picker")
    end,
    version = "2.*",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("plugins.gitsigns")
    end,
  },
  {
    "SmiteshP/nvim-navic",
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("plugins.Comment")
    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("plugins.diffview")
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("plugins.neogit")
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
  },
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("plugins.toggleterm")
    end,
  },
  {
    "mrcjkb/haskell-tools.nvim",
    config = function()
      require("plugins.haskell-tools")
    end,
    version = "^3",
    ft = {
      "haskell",
      "lhaskell",
      "cabal",
      "cabalproject",
    },
  },
  {
    "linrongbin16/gitlinker.nvim",
    config = function()
      require("plugins.gitlinker")
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      require("plugins.none-ls")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "cbochs/grapple.nvim",
    config = function()
      require("plugins.grapple")
    end,
    dependencies = {
      {
        "mtwtkman/nvim-web-devicons",
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("plugins.telescope")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    }
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "aznhe21/actions-preview.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      require("plugins.dropbar")
    end,
  },
  {
    "folke/zen-mode.nvim",
    config = function()
      require("plugins.zen-mode");
    end,
  },
  {
    "Julian/lean.nvim",
    event = {
      "BufReadPre *.lean",
      "BufNewFile *.lean",
    },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("plugins.lean")
    end,
  },
}

local opts = {
  ui = {
    border = "rounded",
  },
}

lazy.setup(plugins, opts)

vim.api.nvim_create_user_command("LazySync", lazy.sync, {})
