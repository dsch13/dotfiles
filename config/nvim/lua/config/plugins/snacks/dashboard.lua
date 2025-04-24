local M = {}

---@class snacks.dashboard.Config
---@field enabled? boolean
---@field sections snacks.dashboard.Section
---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
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
            cmd = "/usr/bin/chafa ~/.config/bound.png --format symbols --symbols vhalf --size 35x35; sleep .1",
            height = 17,
            padding = 1,
        },
        {
            pane = 2,
            { section = "header" },
            { section = "keys",   gap = 1, padding = 1 },
            { section = "startup" },
        },
    },
}
return M
