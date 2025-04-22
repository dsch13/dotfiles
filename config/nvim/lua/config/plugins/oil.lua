return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    config = function()
        function _G.get_oil_winbar()
            local dir = require("oil").get_current_dir()
            if dir then
                return vim.fn.fnamemodify(dir, ":~")
            else
                -- If there is no current directory (e.g. over ssh), just show the buffer name
                return vim.api.nvim_buf_get_name(0)
            end
        end

        require("oil").setup {
            default_file_explorer = true,
            keymaps = {
                ["<C-h>"] = false,
                ["<M-h>"] = "actions.select_split",
                ["<C-p>"] = {
                    callback = function()
                        require("oil").open_preview { vertical = true, split = "botright" }
                    end
                }
            },
            view_options = {
                show_hidden = true,
            },
            float = {
                padding = 4,
                max_height = 20,
                max_width = 100,
                preview_split = "right"
            },
            win_options = {
                winbar = "%!v:lua.get_oil_winbar()"
            },
        }

        vim.keymap.set("n", "<leader>E", require("oil").toggle_float, { desc = "Toggle Floating File Explorer" })
    end
}
