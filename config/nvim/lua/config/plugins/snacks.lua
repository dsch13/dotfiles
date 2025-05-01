return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		dashboard = require("config.plugins.snacks.dashboard").dashboard,
		indent = { enabled = true },
		input = { enabled = true },
		notifier = {
			enabled = true,
		},
		quickfile = { enabled = true },
		words = { enabled = true },
		---@class snacks.scroll.Config
		scroll = {
			enabled = true,
			animate = {
				duration = { step = 45, total = 100 },
			},
		},
	},
	keys = {
		{
			"<leader>n",
			function()
				require("snacks").notifier.show_history()
			end,
			desc = "[N]otification history",
		},
		{
			"<leader>db",
			function()
				require("snacks").bufdelete()
			end,
			desc = "[D]elete [B]uffer",
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				print = function(...)
					local print_safe_args = {}
					local _ = { ... }
					for i = 1, #_ do
						table.insert(print_safe_args, tostring(_[i]))
					end
					Snacks.notifier.notify(table.concat(print_safe_args, " "), "info")
				end
			end,
		})
	end,
}
