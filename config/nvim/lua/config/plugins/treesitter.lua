return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context"
    },
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        ---@diagnostic disable-next-line: missing-fields
        configs.setup({
            ensure_installed = { "lua", "vim", "vimdoc", "javascript", "html", "typescript", "c_sharp", "vue", "razor" },
            sync_install = false,
            highlight = {
                enable = true,
                disable = { "vue" },
                ["attr.value"] = "TSKeyword",
            },
            indent = { enable = true },
        })

        require("treesitter-context").setup()
    end
}
