---@diagnostic disable: missing-fields
return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"j-hui/fidget.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		vim.diagnostic.config({
			virtual_text = { spacing = 4, prefix = "●" },
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("config-lsp-attach", { clear = true }),
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)

				local keys = require("config.plugins.lsp.keys")
				local highlight = require("config.plugins.lsp.highlight")

				-- region
				keys.SetKeys(event, client)
				highlight.highlight(event, client)
				-- endregion
			end,
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		local servers = require("config.plugins.lsp.servers")
		local server_names = servers.server_names
		local servers_complex = servers.server_configs
		local servers_disable = servers.disable

		require("mason-lspconfig").setup({
			automatic_enable = false,
		})

		for _, server_name in pairs(server_names) do
			local server_config = servers_complex[server_name] or {}
			server_config.capabilities = vim.tbl_deep_extend("force", capabilities, server_config.capabilities or {})
			vim.lsp.config(server_name, server_config)
			vim.lsp.enable(server_name, not vim.list_contains(servers_disable, server_name))
		end
	end,
}
