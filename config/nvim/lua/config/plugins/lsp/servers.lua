local server_configs = {
	lua_ls = {
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
	volar = {
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
		init_options = {
			provideFormatter = false,
		},
	},
}

local servers_plain = {
	"cssls",
	"html",
	"roslyn",
	"ruff",
	"rzls",
	"tailwindcss",
	"ts_ls",
}

local server_disable = {
	"ts_ls",
}

local M = {}

M.server_configs = server_configs
M.servers_plain = servers_plain
M.server_names = vim.list_extend(vim.tbl_keys(server_configs), servers_plain)
M.disable = server_disable

return M
