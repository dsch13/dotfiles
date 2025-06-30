return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
		lazy = true,
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("mason").setup({
				registries = {
					"github:mason-org/mason-registry",
					"github:crashdummyy/mason-registry",
				},
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local ensure_installed = require("config.plugins.lsp.servers").server_names
			vim.list_extend(ensure_installed, {
				-- lsp (complicated setup, ensure installed, but not configured in normal flow).
				"roslyn",
				"rzls",

				-- dap
				"debugpy",
				"netcoredbg",

				-- linters
				"mypy",

				-- formatters
				"csharpier",
				"ruff",
				"stylua",
				"prettier",
				"shfmt",
			})
			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
				auto_update = false,
				run_on_start = true,
			})
		end,
	},
}
