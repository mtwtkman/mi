local lazy = require("lazy")

local plugins = {
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    name = "catppuccin",
    config = function()
      require("plugins.catppuccin")
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "arkav/lualine-lsp-progress",
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
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("plugins.nvim-tree")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins.nvim-lspconfig")
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
    "folke/flash.nvim",
    config = function()
      require("plugins.flash")
    end,
  },
  {
    "stevearc/aerial.nvim",
    config = function()
      require("plugins.aerial")
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
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
    dependencies = {
      "neovim/nvim-lspconfig",
    },
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
    "davidmh/cspell.nvim",
    dependencies = {
      "nvimtools/none-ls.nvim",
    },
  },
  {
    "cbochs/grapple.nvim",
    config = function()
      require("plugins.grapple")
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
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
    "https://codeberg.org/esensar/nvim-dev-container",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
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
    commit = "d26bf92161cd70e049dc138b44ffa0246dbf7178",
  },
  {
    "folke/zen-mode.nvim",
    config = function()
      require("plugins.zen-mode");
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
