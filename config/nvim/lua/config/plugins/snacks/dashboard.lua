local M = {}

---@class snacks.dashboard.Config
M.dashboard = {
	preset = {
		header = [[
██████╗  ██████╗  ███████╗ ██╗    ██╗
██╔══██╗ ██╔══██╗ ██╔════╝ ██║    ██║
██║  ██║ ██████╔╝ █████╗   ██║ █╗ ██║
██║  ██║ ██╔══██╗ ██╔══╝   ██║███╗██║
██████╔╝ ██║  ██║ ███████╗ ╚███╔███╔╝
╚═════╝  ╚═╝  ╚═╝ ╚══════╝  ╚══╝╚══╝ ]],
	},
	sections = {
		{
			section = "terminal",
			cmd = "chafa ~/.config/bound.png --format symbols --symbols vhalf --size 35x35; sleep .1",
			height = 25,
			padding = 1,
		},
		{
			pane = 2,
			-- { section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
			{ section = "startup" },
		},
	},
}
return M
