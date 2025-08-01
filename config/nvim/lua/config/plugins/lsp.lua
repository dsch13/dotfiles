---@diagnostic disable: missing-fields
return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	lazy = true,
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"j-hui/fidget.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("config-lsp-attach", { clear = true }),
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)

				local keys = require("config.plugins.lsp.keys")
				local highlight = require("config.plugins.lsp.highlight")
				local diagnostics = require("config.plugins.lsp.diagnostics")
				local autocmd = require("config.plugins.lsp.autocmd")

				keys.set_keys(event, client)
				highlight.highlight(event, client)
				diagnostics.setup_diagnostics()
				autocmd.setup()
			end,
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		local servers = require("config.plugins.lsp.servers")
		local server_names = servers.server_names
		local servers_complex = servers.server_configs
		local servers_disable = servers.disable

		for _, server_name in pairs(server_names) do
			local server_config = servers_complex[server_name] or {}
			vim.lsp.config(server_name, server_config)
			vim.lsp.enable(server_name, not vim.list_contains(servers_disable, server_name))
		end
	end,
}
