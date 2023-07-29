return {
  { import = "lazyvim.plugins.extras.formatting.prettier" },

  { "LazyVim/Lazyvim", opts = {
    colorscheme = "tokyonight",
  } },

  { "nvim-lua/popup.nvim" }, -- An implementation of the Popup API from vim in Neovim
  { "nvim-lua/plenary.nvim" }, -- Useful lua functions used ny lots of plugins
  { "antoinemadec/FixCursorHold.nvim" }, -- This is needed to fix lsp doc highlight
  { "lewis6991/impatient.nvim" }, -- speed up lua module loading

  {
    "norcalli/nvim-terminal.lua", -- Terminal, in neovim
    ft = {
      "terminal",
      "toggleterm",
    },
    config = function()
      require("terminal").setup()
    end,
  },

  {
    "akinsho/toggleterm.nvim", -- Open the terminals in neovim
    -- keys = "<M-n>",
    -- cmd = { "ToggleTerm" },
    config = function()
      -- require("config.toggleterm")
    end,
    dependencies = {
      {
        "norcalli/nvim-terminal.lua",
        ft = {
          "terminal",
          "toggleterm",
        },
        config = function()
          require("terminal").setup()
        end,
      },
    },
  },

  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-lua/plenary.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },

  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
      },
      autoformat = false,
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>"] = {
          c = {
            ["c"] = { "<CMD>noh<CR>", "No Highlight" },
          },
          ["n"] = {
            "<cmd>lua require'util'.CopyMode()<CR>",
            "CopyMode",
          },
          f = {
            g = { "<cmd>Telescope live_grep theme=ivy<CR>", "Live Grep Files" },
            f = {
              "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown())<cr>",
              "Find files",
            },
          },
        },
      },
    },
  },

  -- { "hrsh7th/nvim-cmp", -- The completion plugin
  --   requires = {
  --     "hrsh7th/cmp-buffer", -- buffer completions
  --     "hrsh7th/cmp-path", -- path completions
  --     "hrsh7th/cmp-cmdline", -- cmdline completions
  --     "saadparwaiz1/cmp_luasnip", -- snippet completions
  --     "hrsh7th/cmp-nvim-lsp",
  --     -- -- snippets
  --     "L3MON4D3/LuaSnip", --snippet engine
  --     "rafamadriz/friendly-snippets", -- a bunch of snippets to use
  --   },
  --   config = function()
  --     -- require("config.cmp")
  --   end
  -- })

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- TODO: switch out nvim-ts-rainbow for 'HiPhish/rainbow-delimiters.nvim'
      "mrjones2014/nvim-ts-rainbow",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "c",
        "dockerfile",
        "haskell",
        "json",
        "lua",
        "markdown",
        "ruby",
        "rust",
        "scss",
        "typescript",
        "vim",
        "yaml",
      })
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
      }
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "css-lsp",
        "haskell-language-server",
        "json-lsp",
        "lua-language-server",
        "pyright",
        "stylua",
        "typescript-language-server",
        "vim-language-server",
      },
    },
  },

  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },

  -- { "neovim/nvim-lspconfig", -- enable LSP
  --   requires = {
  --     "williamboman/mason.nvim", -- simple to use language server installer, replacement for nvim-lsp-installer
  --     "williamboman/mason-lspconfig.nvim", -- binding between mason and nvim-lspconfig
  --     "tamago324/nlsp-settings.nvim", -- language server settings defined in json for
  --     "jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
  --   },
  --   config = function()
  --     -- require("config.lsp")
  --   end,
  -- },

  -- {
  --   "akinsho/bufferline.nvim", -- Customize the bufferline
  --   config = function()
  --     -- require("config.bufferline")
  --   end,
  -- },

  { "elkowar/yuck.vim", ft = { "yuck", "lisp" } },

  {
    "anuvyklack/pretty-fold.nvim", -- Allows for folds that look a lot better than the default folds
    dependencies = {
      "anuvyklack/nvim-keymap-amend",
      "anuvyklack/fold-preview.nvim",
    },
    config = function()
      require("fold-preview").setup()
    end,
  },

  -- { "norcalli/nvim-colorizer.lua",
  --   config = function ()
  --     require("colorizer").setup({})
  --   end
  -- },
  -- { "andweeb/presence.nvim",
  --   config =function()
  --     require("config.presence")
  --   end
  -- },
}
