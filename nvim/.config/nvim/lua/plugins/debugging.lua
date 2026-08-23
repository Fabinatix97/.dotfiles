return {
  'mfussenegger/nvim-dap',

  dependencies = {
    -- Mason
    {
      'mason-org/mason.nvim',
      config = function()
        require('mason').setup()
      end,
    },

    -- Mason DAP integration
    {
      'jay-babu/mason-nvim-dap.nvim',
      config = function()
          require('mason-nvim-dap').setup {
              automatic_installation = true,
              ensure_installed = {
                  'php',
              },
              handlers = {},
          }
      end,
    },

    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',
  },

  keys = {
    { '<F5>', function() require('dap').continue() end, desc = 'debug: start/continue' },
    { '<F7>', function() require('dapui').toggle() end, desc = 'debug: toggle DAP UI' },
    { '<F1>', function() require('dap').step_into() end, desc = 'debug: step into' },
    { '<F2>', function() require('dap').step_over() end, desc = 'debug: step over' },
    { '<F3>', function() require('dap').step_out() end, desc = 'debug: step out' },

    { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'debug: toggle breakpoint' },
    { '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'debug: set breakpoint', },
  },

  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- DAP UI setup
    ---@diagnostic disable-next-line: missing-fields
    dapui.setup {
        layouts = { {
            elements = { {
                id = "breakpoints",
                size = 0.2
            }, {
                id = "stacks",
                size = 0.2
            }, {
                id = "watches",
                size = 0.2
            }, {
                id = "scopes",
                size = 0.4
            } },
            position = "left",
            size = 40
        }, {
            elements = { {
                id = "repl",
                size = 0.25
            }, {
                id = "console",
                size = 0.75
            } },
            position = "bottom",
            size = 10
        } },
    }

    -- Automatically open/close DAP UI
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end

    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end

    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end
  end,
}
