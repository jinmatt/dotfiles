local js_debug_version = "v1.105.0"

--- Install vscode-js-debug if not already present
local function ensure_js_debug_installed()
  local install_path = vim.fn.stdpath "data" .. "/js-debug"
  local dap_server = install_path .. "/src/dapDebugServer.js"

  if vim.fn.filereadable(dap_server) == 1 then
    return dap_server
  end

  vim.notify("Installing vscode-js-debug " .. js_debug_version .. "...", vim.log.levels.INFO)

  vim.fn.delete(install_path, "rf")
  vim.fn.mkdir(install_path, "p")

  local url = "https://github.com/microsoft/vscode-js-debug/releases/download/"
    .. js_debug_version
    .. "/js-debug-dap-"
    .. js_debug_version
    .. ".tar.gz"

  local tmpfile = vim.fn.tempname() .. ".tar.gz"
  local cmds = {
    string.format("curl -sL %s -o %s", url, tmpfile),
    -- --strip-components=1 removes the top-level js-debug/ directory
    string.format("tar -xzf %s -C %s --strip-components=1", tmpfile, install_path),
    string.format("rm -f %s", tmpfile),
  }

  for _, cmd in ipairs(cmds) do
    local result = vim.fn.system(cmd)
    if vim.v.shell_error ~= 0 then
      vim.notify("js-debug install failed: " .. result, vim.log.levels.ERROR)
      return nil
    end
  end

  vim.notify("vscode-js-debug " .. js_debug_version .. " installed", vim.log.levels.INFO)
  return dap_server
end

return {
  -- DAP core
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI for DAP
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {},
      },
      -- Inline virtual text for variables during debug
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      -- Ensure the debug adapter is installed
      local dap_server = ensure_js_debug_installed()
      if not dap_server then
        vim.notify("nvim-dap: vscode-js-debug not available, debug adapter won't work", vim.log.levels.WARN)
        return
      end

      -- pwa-node adapter (vscode-js-debug)
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { dap_server, "${port}" },
        },
      }

      -- Debug configurations for JavaScript and TypeScript
      for _, lang in ipairs { "javascript", "typescript" } do
        dap.configurations[lang] = {
          -- Attach to a running Node.js process (e.g., NestJS with --debug flag)
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach (port 9229)",
            port = 9229,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            outFiles = { "${workspaceFolder}/dist/**/*.js" },
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            skipFiles = { "<node_internals>/**" },
          },
          -- Attach with process picker
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach (pick process)",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            outFiles = { "${workspaceFolder}/dist/**/*.js" },
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            skipFiles = { "<node_internals>/**" },
          },
          -- Launch current file
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch current file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            outFiles = { "${workspaceFolder}/dist/**/*.js" },
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            skipFiles = { "<node_internals>/**" },
          },
        }
      end

      -- Auto open/close dap-ui when debug sessions start/end
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- Highlight groups for DAP signs
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f9a825" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e4d3d" })

      -- Breakpoint signs
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = "◎", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })

      -- User command to reinstall/update the debug adapter
      vim.api.nvim_create_user_command("DapJsDebugInstall", function()
        local install_path = vim.fn.stdpath "data" .. "/js-debug"
        vim.fn.delete(install_path, "rf")
        ensure_js_debug_installed()
      end, { desc = "Install/update vscode-js-debug adapter" })
    end,
  },
}
