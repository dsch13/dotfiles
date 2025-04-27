local M = {}

M.setup = function(dap, dapui)
    -- BASIC DEBUG CONTROL
    vim.keymap.set('n', '<F5>', dap.continue, { desc = "Start/Continue Debugging" })
    vim.keymap.set('n', '<F10>', dap.step_over, { desc = "Step Over" })
    vim.keymap.set('n', '<F11>', dap.step_into, { desc = "Step Into" })
    vim.keymap.set('n', '<F12>', dap.step_out, { desc = "Step Out" })
    vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, { desc = "[B]reakpoint" })
    vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
        { desc = "[B]reakpoint (conditional)" })
    vim.keymap.set('n', '<Leader>lp', function()
        dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end, { desc = "[L]og[P]oint" })

    vim.keymap.set('n', '<leader>du', function() dapui.toggle { layout = 1 } end, { desc = "[D]ebug [U]i" })
    vim.keymap.set('n', '<leader>dr', function() dapui.toggle { layout = 2 } end, { desc = "[D]ebug [R]epl" })
    vim.keymap.set('n', '<leader>dt', function() dapui.toggle { layout = 3 } end, { desc = "[D]ebug [T]hreads" })
    vim.keymap.set('n', '<leader>dc', function() dapui.toggle { layout = 4 } end, { desc = "[D]ebug [C]onsole" })
    vim.keymap.set('n', '<leader>de', function() dapui.eval(nil, { enter = true }) end, { desc = "[D]ebug [E]valuate" })
    vim.keymap.set('n', '<leader>dd', function() dap.terminate() end, { desc = "[D]ebug [D]etach" })

    vim.keymap.set('n', '<leader>dn', function() require("osv").launch({ port = 8086 }) end,
        { desc = "[D]ebug [N]eovim" })

    vim.keymap.set('n', '<Leader>dk', function()
        vim.notify([[
🛠 Debugging Keymaps

F5    - Continue / Start
F10   - Step Over
F11   - Step Into
F12   - Step Out

<Leader>b  - Toggle Breakpoint
<Leader>B  - Set Conditional Breakpoint
  ]], vim.log.levels.INFO, { title = "Debug Keymaps" })
    end, { desc = "[D]ebug [K]eymaps" })
end

return M
