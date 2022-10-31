local pkg = require("util.pkg")

local plugins = function(use)
  -- My plugins here
  use({ "wbthomason/packer.nvim" }) -- Have packer manage itself
  use({ "nvim-lua/popup.nvim" }) -- An implementation of the Popup API from vim in Neovim
  use({ "nvim-lua/plenary.nvim" }) -- Useful lua functions used ny lots of plugins
  use({ "antoinemadec/FixCursorHold.nvim" }) -- This is needed to fix lsp doc highlight
  use({"lewis6991/impatient.nvim",
    config = function ()
      require("config.impatient")
    end
  })

  use({ "windwp/nvim-autopairs",
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
  use({"kyazdani42/nvim-tree.lua",
    config = function ()
      require("config.nvim-tree")
    end
  })
  use({"akinsho/bufferline.nvim",
    config = function()
      require("config.bufferline")
    end
  })

  -- use "moll/vim-bbye"

  use({"nvim-lualine/lualine.nvim",
    config = function()
      require("config.lualine")
    end
  })

  use({ "norcalli/nvim-terminal.lua",
    ft = {
      "terminal",
      "toggleterm"
    },
    config = function()
      require("terminal").setup()
    end,
  })

  use({ "akinsho/toggleterm.nvim",
    -- keys = "<M-n>",
    -- cmd = { "ToggleTerm" },
    config = function()
      require("config.toggleterm")
    end,
  })
  -- use({"akinsho/toggleterm.nvim", config = function() require("config.toggleterm") end})

  -- use({"ahmedkhalf/project.nvim"
  --   config = function ()
  --     require("config.project")
  --   end
  -- })


  use({"lukas-reineke/indent-blankline.nvim",
    config = function ()
      require("config.indentline")
    end
  })

  -- use({"goolord/alpha-nvim",
  --   config = function ()
  --     require("config.alpha")
  --   end
  -- })

  use({"anuvyklack/pretty-fold.nvim",
    requires = {
      'anuvyklack/nvim-keymap-amend',
      'anuvyklack/fold-preview.nvim'
    },
    config = function ()
      require("config.prettyfold")
      require('fold-preview').setup()
    end
  })

  use({"folke/which-key.nvim",
    config = function ()
      require("config.whichkey")
    end
  })

  -- Colorschemes
  use({
    -- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
    -- use "lunarvim/darkplus.nvim"
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
      "williamboman/nvim-lsp-installer", -- simple to use language server installer
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
    "nvim-treesitter/nvim-treesitter",
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

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if pkg.Bootstrap then
    pkg.update()
  end
end

return pkg.setup(plugins)
