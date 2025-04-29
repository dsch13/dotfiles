return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		format_on_save = function(bufnr)
			if not require("config.plugins.lsp.format").is_enabled(bufnr) then
				return
			end

			return { lsp_fallback = true, timeout_ms = 1000 }
		end,
		hooks = {
			after_format = function(bufnr)
				if vim.bo[bufnr].filetype == "cs" then
					vim.cmd("checktime")
				end
			end,
		},
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format" },
			cs = { "csharpier" },
			json = { "prettier" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			vue = { "prettier" },
			markdown = { "prettier" },
			sh = { "shfmt" },
			["_"] = {},
		},
		formatters = {
			csharpier = {
				command = "csharpier",
				args = { "format", "--write-stdout" },
				stdin = true,
			},
		},
	},
	init = function()
		require("config.plugins.lsp.format")
	end,
}
