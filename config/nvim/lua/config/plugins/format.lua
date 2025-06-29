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
			stylua = {
				command = "stylua",
				args = { "-" },
				stdin = true,
			},
			ruff_format = {
				command = "ruff",
				args = { "--stdin-filename", "$FILENAME", "-" },
				stdin = true,
			},
			prettier = {
				command = "prettier",
				args = { "--stdin-filepath", "$FILENAME" },
				stdin = true,
			},
			shfmt = {
				command = "shfmt",
				args = { "-i", "2" },
				stdin = true,
			},
		},
	},
	init = function()
		local format = require("config.plugins.lsp.format")

		vim.keymap.set("n", "<leader>ft", function()
			format.toggle("buffer")
		end, { desc = "[F]ormat [T]oggle" })
		vim.keymap.set("n", "<leader>fe", function()
			format.enable("buffer")
		end, { desc = "[F]ormat [E]nable" })
		vim.keymap.set("n", "<leader>fd", function()
			format.disable("buffer")
		end, { desc = "[F]ormat [D]isable" })

		vim.keymap.set("n", "<leader>fT", function()
			format.toggle("global")
		end, { desc = "[F]ormat [T]oggle (global)" })
		vim.keymap.set("n", "<leader>fE", function()
			format.enable("global")
		end, { desc = "[F]ormat [E]nable (global)" })
		vim.keymap.set("n", "<leader>fD", function()
			format.disable("global")
		end, { desc = "[F]ormat [D]isable (global)" })
	end,
}
