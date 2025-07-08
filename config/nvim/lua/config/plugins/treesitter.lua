return {
	"nvim-treesitter/nvim-treesitter",

	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
	},
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		---@diagnostic disable-next-line: missing-fields
		configs.setup({
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"javascript",
				"typescript",
				"html",
				"typescript",
				"c_sharp",
				"vue",
				"razor",
				"python",
			},
			sync_install = false,
			highlight = {
				enable = true,
				disable = { "vue" },
			},
			indent = { enable = true },
		})

		require("treesitter-context").setup({
			max_lines = 5,
			on_attach = function(bufnr)
				local context = require("treesitter-context")

				-- Override the default context display function
				context._update_context = function()
					local nodes = context.get_parent_matches()
					local filtered = {}

					for _, node in ipairs(nodes) do
						local text = vim.treesitter.get_node_text(node, bufnr)

						-- If the node"s line starts with [, skip it
						if not text:match("^%s*%[") then
							table.insert(filtered, node)
						end
					end

					context.display_context(filtered)
				end
				return true
			end,
		})
	end,
}
