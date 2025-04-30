vim.keymap.set("n", "<leader>qo", "<cmd>copen<CR>", { desc = "[Q]uickfix [O]pen" })
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "[Q]uickfix [C]lose" })
vim.keymap.set("n", "<leader>qf", vim.diagnostic.setqflist, { desc = "[Q]uickfix [F]ill" })

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>zz", { desc = "Go to next item in quickfix list" })
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>zz", { desc = "Go to previous item in quickfix list" })
