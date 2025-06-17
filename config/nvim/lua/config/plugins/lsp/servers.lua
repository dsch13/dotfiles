local servers_plain = {
	"cssls",
	"html",
	"roslyn",
	"ruff",
	"rzls",
	"tailwindcss",
	"ts_ls",
}

local M = {}

M.server_configs = {
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
	["vue-language-server"] = {
		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		cmd = { "vue-language-server", "--stdio" },
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
M.servers_plain = servers_plain
local server_names = vim.tbl_keys(M.server_configs)
M.server_names = vim.list_extend(server_names, servers_plain)
M.disable = {
	"ts_ls",
}

return M
