return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    opts = {
        presets = {
            bottom_search = true,
        },
        routes = {
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                    find = "change; before #",
                },
                opts = { skip = true },
            },
        },
    },
}
