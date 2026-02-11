return {
  {
    "stevearc/conform.nvim",
    keys = {
      { "<leader>fm", mode = { "n", "v" }, desc = "Format file" },
    },
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Telescope with filename_first for better visibility
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, conf)
      conf.defaults = vim.tbl_deep_extend("force", conf.defaults or {}, {
        path_display = { "filename_first" },
        cache_picker = {
          num_pickers = 10,
        },
      })
      return conf
    end,
  },

  -- Auto-save and restore sessions
  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      suppressed_dirs = { "~/", "~/Downloads", "/", "/tmp" },
    },
  },

  -- Nvim-tree with fixed width (prevent auto-resizing)
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      view = {
        width = 30,
        adaptive_size = false,
      },
      actions = {
        open_file = {
          resize_window = false,
        },
      },
    },
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
