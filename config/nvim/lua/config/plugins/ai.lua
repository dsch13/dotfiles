return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false,
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
	opts = {
		provider = "copilot",
		providers = {
			copilot = {
				model = "claude-3.7-sonnet",
			},
		},
		prompt_logger = {
			enabled = false,
		},
		auto_suggestions_provider = nil,
		behavior = {
			use_cwd_as_project_root = true,
			enable_cursor_planning_mode = true,
		},
		file_selector = {
			provider = "telescope",
		},
		web_search_engine = {
			provider = "google",
		},
	},
}
