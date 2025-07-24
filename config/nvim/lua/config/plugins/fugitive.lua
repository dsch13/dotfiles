return {
	"tpope/vim-fugitive",
	keys = {
		{ "<leader>gc", vim.cmd.Git, desc = "[G]it [C]ommand" },
		{ "<leader>gl", ":0Gclog<CR>", desc = "[G]it [L]og" },
		{ "<leader>gsl", ":Gclog --grep= --<left><left><left>", desc = "[G]it [S]earch [H]istory" },
		{ "<leader>gsc", ":Gclog -S --<left><left><left>", desc = "[G]it [S]earch [C]hanges" },
		{ "<leader>gg", ":Ggrep ''<left>", desc = "[G]it [G]og" },
	},
	cmd = { "Git", "G" },
	config = function()
		local fugitive = vim.api.nvim_create_augroup("config-fugitive", { clear = true })

		vim.api.nvim_create_autocmd("BufWinEnter", {
			desc = "add keymaps to fugitive window",
			group = fugitive,
			pattern = "*",
			callback = function(evt)
				if vim.bo[evt.buf].filetype ~= "fugitive" then
					return
				end

				local bufnr = vim.api.nvim_get_current_buf()
				local opts = { buffer = bufnr, remap = false }

				vim.keymap.set("n", "<leader>P", function()
					vim.cmd.Git("push")
				end, { desc = "git [P]ush", unpack(opts) })

				-- rebase always
				vim.keymap.set("n", "<leader>p", function()
					vim.cmd.Git({ "pull" })
				end, { desc = "git [P]ull", unpack(opts) })

				vim.keymap.set("n", "<leader>o", ":Git push -u origin ", opts)
			end,
		})

		vim.keymap.set("n", "go", "<cmd>diffget //2<CR>")
		vim.keymap.set("n", "gt", "<cmd>diffget //3<CR>")
	end,
	init = function() end,
}
