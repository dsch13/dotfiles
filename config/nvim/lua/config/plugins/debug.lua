return {
	"jay-babu/mason-nvim-dap.nvim",
	cmd = { "DapContinue", "DapToggleBreakpoint", "DapTerminate", "DapStepOver", "DapStepInto", "DapStepOut" },
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"jbyuki/one-small-step-for-vimkind",
	},
	init = function()
		require("mason-nvim-dap").setup({
			handlers = {
				python = function(_) end,
			},
		})
		require("config.plugins.debug.visuals").setup()

		local dap = require("dap")

		require("dap.ext.vscode").getconfigs(nil, {})

		require("config.plugins.debug.cs").setup(dap)
		require("config.plugins.debug.python").setup(dap)
		require("config.plugins.debug.lua").setup(dap)

		local dapui = require("dapui")

		---@diagnostic disable-next-line: missing-fields
		dapui.setup({
			layouts = {
				{
					elements = {
						{ id = "watches", size = 0.30 },
						{ id = "breakpoints", size = 0.30 },
						{ id = "scopes", size = 0.40 },
					},
					size = 40,
					position = "left",
				},
				{
					elements = { { id = "repl", size = 1.0 } },
					size = 10,
					position = "bottom",
				},
				{
					elements = { { id = "threads", size = 1.0 } },
					size = 10,
					position = "bottom",
				},
				{
					elements = { { id = "console", size = 1.0 } },
					size = 10,
					position = "bottom",
				},
			},
			---@diagnostic disable-next-line: missing-fields
			controls = {
				enabled = true,
				element = "scopes",
			},
		})

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open({ layout = 1 })
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.after.event_stopped["auto_jump_to_exception"] = function(_, body)
			if body.reason == "exception" then
				vim.schedule(function()
					dap.goto_(1)
				end)
			end
		end

		require("config.plugins.debug.keys").setup(dap, dapui)
		require("nvim-dap-virtual-text").setup({})
	end,
}
