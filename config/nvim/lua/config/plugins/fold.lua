return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	opts = {
		fold_virt_text_handler = require("config.plugins.fold.virtualText").handler,
		close_fold_kinds_for_ft = {
			default = {},
			typescript = { "region", "imports" },
		},
	},
	init = function()
		require("config.plugins.fold.foldColumn").setup()

		-- region Test Region folding
		vim.opt.foldcolumn = "auto:1"
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
		vim.opt.foldenable = true
		-- endregion

		vim.keymap.set("n", "zp", require("config.plugins.fold.peek").peek, { desc = "[P]eek fold" })
	end,
}
