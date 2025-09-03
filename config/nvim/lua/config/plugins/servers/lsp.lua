--- @class ServerDefinition
--- @field cmd string
--- @field config table
--- @field disabled boolean

--- @type ServerDefinition[]
return {
	basedpyright = {
		cmd = { "basedpyright-langserver", "--stdio" },
		config = {
			init_options = { provideFormatter = false },
		},
	},
	["bashls"] = {
		cmd = { "bash-language-server", "start" },
		config = {
			filetypes = { "bash", "sh" },
		},
	},
	cssls = {
		cmd = { "vscode-css-language-server", "--stdio" },
	},
	html = {
		cmd = { "vscode-html-language-server", "--stdio" },
	},
	tailwindcss = {
		cmd = { "tailwindcss-language-server", "--stdio" },
	},
	vue_ls = {
		cmd = { "vue-language-server", "--stdio" },
	},
	lua_ls = {
		cmd = { "lua-language-server" },
		config = {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					completion = { callSnippet = "Replace" },
				},
			},
		},
	},
	vtsls = {
		cmd = { "vtsls", "--stdio" },
		config = {
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
	},
	gopls = {
		cmd = { "gopls" },
	},
	roslyn = {
		disabled = true,
	},
	rzls = {
		disabled = true,
	},
}
