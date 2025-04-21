local M = {}

M.setup = function(dap)
    dap.adapters.python = {
        type = "executable",
        command = function()
            -- Ask the user whether to run with Poetry or system Python
            local choice = vim.fn.input("Use Poetry? (y/n): ")
            if choice == "y" then
                return "poetry"
            else
                return vim.fn.exepath("python3") -- Use system Python
            end
        end,
        args = function()
            local choice = vim.fn.input("Use Poetry? (y/n): ")
            if choice == "y" then
                return { "run", "python", "-m", "debugpy.adapter" }
            else
                return { "-m", "debugpy.adapter" }
            end
        end,
    }

    dap.configurations.python = {
        {
            type = "python",
            request = "launch",
            name = "Launch File",
            program = "${file}", -- Runs the current file
            pythonPath = function()
                local choice = vim.fn.input("Use Poetry? (y/n): ")
                if choice == "y" then
                    return "poetry run python"
                else
                    return vim.fn.exepath("python3") -- System Python
                end
            end,
        },
    }
end

return M
