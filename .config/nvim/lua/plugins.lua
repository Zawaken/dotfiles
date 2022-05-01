-- Install packer {{{
local fn = vim.fn

local config = {
  profile = {
    enable = true,
    treshold = 0,
  },
  display = {
    open_fn = function()
      return require("packer.util").float({border = "single"})
    end,
  },
}

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end
-- }}}
-- Autocommand that reloads neovim whenever you save the plugins.lua file {{{
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]
-- }}}
-- Use a protected call so we don't error out on first use {{{
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end
-- }}}
-- Have packer use a popup window {{{
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}
-- }}}
-- Install your plugins here {{{
return packer.startup(function(use)
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
  -- use({"akinsho/toggleterm.nvim",
  --   config = function()
  --     require("config.toggleterm")
  --   end
  -- })

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
    requires = 'anuvyklack/nvim-keymap-amend',
    config = function ()
      require("config.prettyfold")
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
      require("config.theme")
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

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
-- }}}
