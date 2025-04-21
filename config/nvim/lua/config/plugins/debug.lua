return {
    "williamboman/mason.nvim",
    dependencies = {
        "mfussenegger/nvim-dap",
        "jay-babu/mason-nvim-dap.nvim",
        "nvim-neotest/nvim-nio",
        "rcarriga/nvim-dap-ui",
    },
    init = function()
        require("mason").setup()
        require("mason-nvim-dap").setup()

        local dap = require('dap')

        dap.adapters.coreclr = {
            type = 'executable',
            command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
            args = { '--interpreter=vscode' },
        }

        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "Launch .NET Core",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/net6.0/', 'file')
                end,
            },
            {
                type = "coreclr",
                name = "Attach to Process",
                request = "attach",
                processId = function()
                    local pid_picker = require("config.plugins.pickers.pid").get("dotnet")
                    return coroutine.wrap(function() -- Coroutine wraps picker for async return
                        local pid = coroutine.yield(pid_picker)
                        return pid
                    end)()
                end
            }
        }

        local dapui = require("dapui")
        require("dapui").setup()

        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        vim.keymap.set('n', '<F5>', function() require 'dap'.continue() end, { desc = "Continue" })
        vim.keymap.set('n', '<F10>', function() require 'dap'.step_over() end, { desc = "Step Over" })
        vim.keymap.set('n', '<F11>', function() require 'dap'.step_into() end, { desc = "Step Into" })
        vim.keymap.set('n', '<F12>', function() require 'dap'.step_out() end, { desc = "Step Out" })
        vim.keymap.set('n', '<Leader>b', function() require 'dap'.toggle_breakpoint() end, { desc = "[B]reakpoint" })
        vim.keymap.set('n', '<Leader>B',
            function() require 'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
            { desc = "[B]reakpoint (Condition)" })
    end
}
