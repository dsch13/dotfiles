local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

function M.get(name, opts)
    local handle = io.popen(string.format("\\ps -eo pid,cmd | grep %s | grep -v -e grep -e rg -e roslyn -e nologo", name))
    local result = {}

    if handle == nil then return nil end

    for line in handle:lines() do
        print(vim.inspect(line))
        table.insert(result, line)
    end
    handle:close()

    return coroutine.create(function(co)
        pickers.new(opts, {
            prompt_title = "Select Process",
            finder = finders.new_table { results = result },
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    if selection then
                        local pid = tonumber(selection[1]:match("%d+"))
                        coroutine.resume(co, pid)
                    else
                        coroutine.resume(co, nil)
                    end
                end)
                return true
            end
        }):find()
    end)
end

return M
