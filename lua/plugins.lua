-- Packer stuff
return require('packer').startup(function(use)
  -- Plugin manager
  use { 'wbthomason/packer.nvim' }

  use {
    'nvim-treesitter/nvim-treesitter',
    config = require("plugs.treesitter"),
  }

  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
    tag = 'nightly',
    config = require("plugs.nvim-tree"),
  }

  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 600
      require("which-key").setup { }
    end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }

  use {
    "neovim/nvim-lspconfig",
  }

  use {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
  }

  use {
    'lewis6991/gitsigns.nvim',
    config = require("plugs.gitsigns"),
  }

  use {
    "catppuccin/nvim",
    as = "catppuccin"
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = require("plugs.lualine"),
  }

  use {
    'jiangmiao/auto-pairs'
  }

  use {
    'akinsho/bufferline.nvim',
    requires = 'nvim-tree/nvim-web-devicons',
    config = require("plugs.bufferline"),
  }

end)
