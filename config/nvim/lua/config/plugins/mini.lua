return {
	{
		"echasnovski/mini.nvim",
		dependencies = {
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				lazy = true,
				opts = {
					enable_autocmd = false,
				},
			},
		},
		config = function()
			local statusline = require("mini.statusline")
			vim.api.nvim_set_hl(0, "StatuslineError", { fg = "#eb6f92", bg = "NONE" })
			vim.api.nvim_set_hl(0, "StatuslineWarn", { fg = "#f6c177", bg = "NONE" })
			vim.api.nvim_set_hl(0, "StatuslineInfo", { fg = "#9ccfd8", bg = "NONE" })
			vim.api.nvim_set_hl(0, "StatuslineHint", { fg = "#c4a7e7", bg = "NONE" })

			local function custom_location()
				local line = vim.fn.line(".")
				local col = vim.fn.virtcol(".")
				return string.format(" 󰗧 %d:%d", line, col)
			end

			statusline.setup({
				use_icons = true,
				content = {
					active = function()
						local mode, mode_hl = MiniStatusline.section_mode({})
						local git = MiniStatusline.section_git({})
						local diagnostics = require("config.plugins.lsp.diagnostics").lsp_diagnostics_summary()
						local filename = MiniStatusline.section_filename({})
						local fileinfo = MiniStatusline.section_fileinfo({})
						local location = custom_location()

						return statusline.combine_groups({
							{ hl = mode_hl, strings = { mode } },
							{ hl = "Statusline", strings = { git } },
							{ hl = "Statusline", strings = { diagnostics } },
							{ hl = "Statusline", strings = { filename, "%=" } },
							{ hl = "Statusline", strings = { fileinfo } },
							{ hl = "Statusline", strings = { location } },
						})
					end,
				},
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					require("mini.comment").setup({
						options = {
							custom_commentstring = function()
								return require("ts_context_commentstring").calculate_commentstring()
									or vim.bo.commentstring
							end,
						},
					})
				end,
			})

			require("mini.surround").setup({})
			vim.keymap.set("n", "s", "<NOP>", { noremap = true, silent = true })
		end,
	},
}
