-- yank and paste keymaps
vim.keymap.set("n", "Y", "yy", { desc = "Yank entire line" })
--
-- diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, { desc = "Open [F]loat text" })

-- exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- open directory of current file in file explorer
vim.keymap.set("n", "<leader>e", function() vim.cmd.edit({ vim.fn.expand("%:p:h") }) end, { desc = "[E]dit Directory" })

-- Move highlighted lines and apply indenting
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor in same position when appending line below
vim.keymap.set("n", "J", "mzJ`z")

-- Keep cursor in center of screen when jumping by half page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep cursor in center of screen when moving through search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Utility for updating config live
vim.keymap.set("n", "<space>x", "<cmd>source %<CR>")

-- clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

local function copy_relative_path()
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.")
    if path == "" then
        vim.notify("No file path to copy", vim.log.levels.WARN)
        return
    end
    vim.fn.setreg("+", path)
    vim.notify("Copied: " .. path)
end

vim.keymap.set("n", "<leader>yp", copy_relative_path, { desc = "Copy relative path to clipboard" })
