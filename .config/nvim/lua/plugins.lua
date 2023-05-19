local pkg = require("util.pkg")

local plugins = function(use)
  -- My plugins here
  use({ "wbthomason/packer.nvim" })           -- Have packer manage itself
  use({ "nvim-lua/popup.nvim" })              -- An implementation of the Popup API from vim in Neovim
  use({ "nvim-lua/plenary.nvim" })            -- Useful lua functions used ny lots of plugins
  use({ "antoinemadec/FixCursorHold.nvim" })  -- This is needed to fix lsp doc highlight
  use({"lewis6991/impatient.nvim",            -- speed up lua module loading
    config = function ()
      require("config.impatient")
    end
  })

  use({"folke/which-key.nvim", -- Plugin for handling and showing keybindings
    config = function ()
      require("config.whichkey")
    end
  })

  use({ "windwp/nvim-autopairs", -- Automatically add in the pairing for (, [, {, etc
    event = 'InsertEnter',
    config = function()
      require("config.autopairs")
    end,
  })

  use({"numToStr/Comment.nvim", -- Easily comment stuff
    config = function()
      require("config.comment")
    end,
  })

  use "kyazdani42/nvim-web-devicons"
  use({"kyazdani42/nvim-tree.lua", -- Neovim file explorer
    config = function ()
      require("config.nvim-tree")
    end
  })
  use({"akinsho/bufferline.nvim", -- Customize the bufferline
    config = function()
      require("config.bufferline")
    end
  })

  -- use "moll/vim-bbye"

  use({"nvim-lualine/lualine.nvim", -- Customize the Neovim statusline
    config = function()
      require("config.lualine")
    end
  })

  use({ "norcalli/nvim-terminal.lua", -- Terminal, in neovim
    ft = {
      "terminal",
      "toggleterm"
    },
    config = function()
      require("terminal").setup()
    end,
  })

  use({ "akinsho/toggleterm.nvim", -- Open the terminals in neovim
    -- keys = "<M-n>",
    -- cmd = { "ToggleTerm" },
    config = function()
      require("config.toggleterm")
    end,
  })


  use({"lukas-reineke/indent-blankline.nvim", -- Indents newlines
    config = function ()
      require("config.indentline")
    end
  })

  use({"anuvyklack/pretty-fold.nvim", -- Allows for folds that look a lot better than the default folds
    requires = {
      'anuvyklack/nvim-keymap-amend',
      'anuvyklack/fold-preview.nvim'
    },
    config = function ()
      require("config.prettyfold")
      require('fold-preview').setup()
    end
  })



  -- Colorschemes
  use({
    "folke/tokyonight.nvim",
    config = function()
      require("config.theme").scheme("tokyonight")
    end,
  })
  -- cmp plugins
  use({ "hrsh7th/nvim-cmp", -- The completion plugin
    requires = {
      "hrsh7th/cmp-buffer", -- buffer completions
      "hrsh7th/cmp-path", -- path completions
      "hrsh7th/cmp-cmdline", -- cmdline completions
      "saadparwaiz1/cmp_luasnip", -- snippet completions
      "hrsh7th/cmp-nvim-lsp",
      -- -- snippets
      "L3MON4D3/LuaSnip", --snippet engine
      "rafamadriz/friendly-snippets", -- a bunch of snippets to use
    },
    config = function()
      require("config.cmp")
    end
  })

  -- LSP
  use({ "neovim/nvim-lspconfig", -- enable LSP
    requires = {
      "williamboman/mason.nvim", -- simple to use language server installer, replacement for nvim-lsp-installer
      "williamboman/mason-lspconfig.nvim", -- binding between mason and nvim-lspconfig
      "tamago324/nlsp-settings.nvim", -- language server settings defined in json for
      "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
    },
    config = function()
      require("config.lsp")
    end
  })
  -- -- Telescope
  use({"nvim-telescope/telescope.nvim",
    config = function ()
      require("config.telescope")
    end
  })

  -- -- Treesitter
  use ({
    "nvim-treesitter/nvim-treesitter", -- Syntax highlighting
    run = ":TSUpdate",
    config = function ()
      require("config.treesitter")
    end,
  })
  use "JoosepAlviste/nvim-ts-context-commentstring"

  -- -- Git
  use({"lewis6991/gitsigns.nvim",
    config = function ()
      require("config.gitsigns")
    end
  })

  use({ "andweeb/presence.nvim",
    config =function()
      require("config.presence")
    end
  })

  use({ "folke/trouble.nvim",
    config = function ()
      require("trouble").setup({})
    end,
    requires = {
      "kyazdani42/nvim-web-devicons"
    }
  })

  use({
    "kwkarlwang/bufjump.nvim",
    config = function ()
      require("bufjump").setup({
        forward = "<C-l>",
        backward = "<C-h>",
      })
    end
  })

  use({ "norcalli/nvim-colorizer.lua",
    config = function ()
      require("colorizer").setup({})
    end
  })

  use({ "elkowar/yuck.vim",
    ft = {"yuck", "lisp"},
  })
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if pkg.Bootstrap then
    pkg.update()
  end
end

return pkg.setup(plugins)
