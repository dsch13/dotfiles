local servers_plain = {
	{
		name = "cssls",
		cmd = { "vscode-css-language-server", "--stdio" },
	},
	{
		name = "html",
		cmd = { "vscode-html-language-server", "--stdio" },
	},
	{
		name = "ruff",
		cmd = { "ruff-lsp" },
	},
	{
		name = "tailwindcss",
		cmd = { "tailwindcss-language-server", "--stdio" },
	},
	{
		name = "ts_ls",
		cmd = { "typescript-language-server", "--stdio" },
	},
}

local M = {}

M.server_configs = {
	lua_ls = {
		cmd = { "lua-language-server" },
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	},
	["vue-language-server"] = {
		cmd = {
			vim.fn.stdpath("data") .. "/mason/bin/vue-language-server",
			"--stdio",
		},
		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		init_options = {
			vue = {
				hybridMode = false,
			},
			typescript = {
				tsdk = vim.fn.stdpath("data")
					.. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
			},
			languageFeatures = {
				diagnostics = {
					className = true,
				},
				semanticTokens = true,
			},
			documentFeatures = {
				classNameCompletion = true,
			},
		},
	},
	basedpyright = {
		cmd = { "basedpyright-langserver", "--stdio" },
		init_options = {
			provideFormatter = false,
		},
	},
}
M.servers_plain = servers_plain

M.server_names = vim.list_extend(
	vim.tbl_keys(M.server_configs),
	vim.tbl_map(function(server)
		return server.name
	end, servers_plain)
)

M.disable = {
	-- lsp
	"ts_ls",

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
}

return M
