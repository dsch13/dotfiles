local M = {}

M.setup = function(dap)
    dap.adapters.python = {
        type = "executable",
        command = vim.fn.exepath("python"),
        args = { "-m", "debugpy.adapter" },
    }

    dap.configurations.python = {
        {
            type = "python",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            pythonPath = function()
                local venv = os.getenv("VIRTUAL_ENV")
                if venv then
                    return venv .. "/bin/python"
                else
                    return vim.fn.exepath("python")
                end
            end,
        },
        {
            type = "python",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            pythonPath = function()
                local venv = os.getenv("VIRTUAL_ENV")
                if venv then
                    return venv .. "/bin/python"
                else
                    return vim.fn.exepath("python")
                end
            end,
        }
    }
end

return M
