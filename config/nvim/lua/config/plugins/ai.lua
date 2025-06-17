return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false,
	opts = {
		provider = "copilot",
		auto_suggestions_provider = nil,
		behavior = {
			use_cwd_as_project_root = true,
		},
		file_selector = {
			provider = "telescope",
		},
	},
	build = "make",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
		"zbirenbaum/copilot.lua",
		"stevearc/dressing.nvim",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
