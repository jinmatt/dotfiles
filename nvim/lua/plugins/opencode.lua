return {
  "nickjvandyke/opencode.nvim",
  version = "*", -- Latest stable release
  dependencies = {
    {
      -- snacks.nvim integration is optional but enhances functionality
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {}, -- Enhances ask() with better input handling
        picker = { -- Enhances select() with better picker
          actions = {
            opencode_send = function(...)
              return require("opencode").snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
    vim.g.opencode_opts = {
      -- Disable auto-starting since OpenCode is already running externally on port 4069
      server = {
        start = function()
          vim.notify("OpenCode should already be running on port 4069", vim.log.levels.WARN)
        end,
        stop = function()
          -- No-op: we're not managing the server
        end,
        toggle = function()
          vim.notify("OpenCode should already be running on port 4069", vim.log.levels.WARN)
        end,
      },
    }

    -- Required for OpenCode to reload files when it makes changes
    vim.o.autoread = true
  end,
  keys = {
    -- Ask OpenCode about current selection/context
    {
      "<leader>oa",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode ask about this",
    },

    -- Execute OpenCode action (shows menu)
    {
      "<leader>ox",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "OpenCode execute action",
    },

    -- Operator mode to add range to OpenCode
    {
      "<leader>oo",
      function()
        return require("opencode").operator("@this ")
      end,
      mode = "n",
      expr = true,
      desc = "OpenCode add to context",
    },

    -- Prompt OpenCode with custom message
    {
      "<leader>op",
      function()
        require("opencode").ask()
      end,
      mode = { "n", "x" },
      desc = "OpenCode prompt",
    },
  },
}
