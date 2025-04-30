return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"rcarriga/nvim-notify",
	},
	opts = {
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
		},
		presets = {
			bottom_search = true,
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					kind = "",
					find = "change; before #",
				},
				opts = { skip = true },
			},
		},
	},
}
