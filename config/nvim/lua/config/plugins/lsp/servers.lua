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
							location = vim.fn.stdpath("data") .. "/mason/bin/vue-language-server",
							languages = { "vue" },
							configNamespace = "typescript",
						},
					},
				},
			},
		},
		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	},
	["vue_ls"] = {
		on_init = function(client)
			client.handlers["tsserver/request"] = function(_, result, context)
				local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
				if #clients == 0 then
					vim.notify(
						"Could not found `vtsls` lsp client, vue_lsp would not work without it.",
						vim.log.levels.ERROR
					)
					return
				end
				local ts_client = clients[1]

				local param = unpack(result)
				local id, command, payload = unpack(param)
				ts_client:exec_cmd({
					title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
					command = "typescript.tsserverRequest",
					arguments = {
						command,
						payload,
					},
				}, { bufnr = context.bufnr }, function(_, r)
					local response_data = { { id, r.body } }
					---@diagnostic disable-next-line: param-type-mismatch
					client:notify("tsserver/response", response_data)
				end)
			end
		end,
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
