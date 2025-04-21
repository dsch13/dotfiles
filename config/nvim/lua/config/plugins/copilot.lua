return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    ---@module 'copilot'
    ---@type copilot_config
    opts = {
        suggestion = {
            auto_trigger = true
        },
        copilot_model = "gpt-4o-copilot"
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "BlinkCmpMenuOpen",
            callback = function()
                vim.b.copilot_suggestion_hidden = true
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "BlinkCmpMenuClose",
            callback = function()
                vim.b.copilot_suggestion_hidden = false
            end,
        })

        vim.keymap.set("n", "<leader>ct", function()
            require("copilot.suggestion").toggle_auto_trigger()
            vim.notify("Copilot Completion: " .. (vim.b.copilot_suggestion_auto_trigger and "Enabled" or "Disabled"))
        end, { desc = "[C]opilot [T]oggle" })

        vim.keymap.set("i", "<C-n>", require("copilot.suggestion").prev,
            { desc = "Previous Suggestion" })
        vim.keymap.set("i", "<C-p>", require("copilot.suggestion").prev,
            { desc = "Next Suggestion" })

        vim.keymap.set("i", "<C-a>", require("copilot.suggestion").accept, { desc = "Accept Suggestion" })

        vim.keymap.set("i", "<C-e>", require("copilot.suggestion").accept_word,
            { desc = "Accept Word" })
    end
}
