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

		local servers = require("config.plugins.servers.lsp")

		for name, server in pairs(servers) do
			if not server.disabled then
				local server_config = server.config or {}
				vim.lsp.config(name, server_config)
				---@diagnostic disable-next-line: param-type-mismatch
				vim.lsp.enable(name, server.disabled or true)
			end
		end
	end,
}
