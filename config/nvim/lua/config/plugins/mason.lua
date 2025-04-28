return {
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
        lazy = true,
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("mason").setup({
                registries = {
                    "github:mason-org/mason-registry",
                    "github:crashdummyy/mason-registry",
                },
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            local ensure_installed = vim.tbl_keys(require("config.plugins.lsp.servers").servers)
            vim.list_extend(ensure_installed, {
                --lsp (no custom config)
                "cssls",
                "html",
                "roslyn",
                "ruff",
                "rzls",
                "tailwindcss",

                -- dap
                "debugpy",
                "netcoredbg",

                -- linters
                "mypy",

                -- formatters
                "stylua",
            })
            require("mason-tool-installer").setup({
                ensure_installed = ensure_installed,
                auto_update = false,
                run_on_start = true,
            })
        end,
    }
}
