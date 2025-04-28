local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local selected_dll

local function telescope_pick(results, prompt_title, entry_maker_fn)
    return coroutine.create(function(coro)
        pickers.new({}, {
            prompt_title = prompt_title,
            finder = finders.new_table {
                results = results,
                entry_maker = entry_maker_fn,
            },
            sorter = conf.generic_sorter({}),
            attach_mappings = function()
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    coroutine.resume(coro, selection.value)
                end)
                return true
            end,
        }):find()
    end)
end

local function pick_dll()
    local cwd = vim.fn.getcwd()
    local pattern = cwd .. "/**/bin/Debug/**/*.dll"
    local dlls = vim.fn.glob(pattern, true, true)

    dlls = vim.tbl_filter(function(path)
        local parent = path:match(".*/(.-)/bin/Debug/")
        local filename = path:match(".*/(.*)%.dll$")
        return parent and filename and parent == filename
    end, dlls)

    if #dlls == 0 then
        selected_dll = vim.fn.input("Path to dll: ", cwd .. "/", "file")
        return selected_dll
    elseif #dlls == 1 then
        selected_dll = dlls[1]
        return selected_dll
    else
        return telescope_pick(dlls, "Select DLL to Debug", function(entry)
            return {
                value = entry,
                display = entry:match("([^/]+)%.dll$") or entry,
                ordinal = entry,
            }
        end)
    end
end

local function pick_process()
    local cwd = vim.fn.getcwd()

    local output = vim.fn.systemlist({ "/bin/ps", "-eo", "pid,args" })

    if not output or vim.tbl_isempty(output) then
        vim.notify("No processes found", vim.log.levels.WARN)
        return nil
    end

    local processes = {}

    for idx, line in ipairs(output) do
        if line and line:match("%S") then
            if idx ~= 1 then -- Skip the header line
                local pid, args = line:match("^%s*(%d+)%s+(.+)$")
                if pid and args then
                    table.insert(processes, { pid = tonumber(pid), args = args })
                end
            end
        end
    end

    local matching = vim.tbl_filter(function(proc)
        return proc.args and proc.args:find(cwd, 1, true)
    end, processes)

    if #matching == 0 then
        vim.notify("No matching processes found for cwd: " .. cwd, vim.log.levels.WARN)
        return nil
    elseif #matching == 1 then
        return matching[1].pid
    else
        local picked = telescope_pick(matching, "Attach to Process", function(entry)
            return {
                value = entry.pid,
                display = string.format("[%d] %s", entry.pid, entry.args),
                ordinal = entry.args,
            }
        end)
        return picked
    end
end

M.setup = function(dap)
    dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
        args = { "--interpreter=vscode" },
    }

    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "Launch .NET Core",
            env = {
                ASPNETCORE_ENVIRONMENT = "Development",
                DOTNET_ENVIRONMENT = "Development",
                RUNNING_IN_KUBERNETES = "false",
            },
            request = "launch",
            stopAtEntry = false,
            program = pick_dll,
            cwd = function()
                if selected_dll then
                    return selected_dll:match("(.+)/bin/Debug/")
                else
                    return vim.fn.getcwd()
                end
            end,
        },
        {
            type = "coreclr",
            name = "Attach to Process",
            request = "attach",
            processId = pick_process,
        }
    }
end

return M
