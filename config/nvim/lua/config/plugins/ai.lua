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
		{
			"ravitemer/mcphub.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			build = "npm install -g mcp-hub@latest",
			config = function()
				require("mcphub").setup()
			end,
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
		-- system_prompt = function()
		-- 	local hub = require("mcphub").get_hub_instance()
		-- 	return hub and hub:get_active_servers_prompt() or ""
		-- end,
		-- custom_tools = function()
		-- 	return {
		-- 		require("mcphub.extensions.avante").mcp_tool(),
		-- 	}
		-- end,
	},
}
