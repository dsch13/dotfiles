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
		name = "vue_ls",
		cmd = { "vue-language-server", "--stdio" },
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
	vtsls = {
		settings = {
			vtsls = {
				tsserver = {
					globalPlugins = {
						{
							name = "@vue/typescript-plugin",
							location = vim.fn.stdpath("data")
								.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
							languages = { "vue" },
							configNamespace = "typescript",
						},
					},
				},
			},
		},
		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
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
