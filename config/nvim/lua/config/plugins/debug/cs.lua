local M = {}

M.setup = function(dap)
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
                return coroutine.wrap(function()
                    local pid = coroutine.yield(pid_picker)
                    return pid
                end)()
            end
        }
    }
end

return M
