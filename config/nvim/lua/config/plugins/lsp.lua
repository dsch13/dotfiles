---@diagnostic disable: missing-fields
return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        'j-hui/fidget.nvim',
        'saghen/blink.cmp'
    },
    config = function()
        vim.diagnostic.config({
            virtual_text = { spacing = 4, prefix = '●' },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('config-lsp-attach', { clear = true }),
            callback = function(event)
                local client = vim.lsp.get_client_by_id(event.data.client_id)

                local keys = require("config.plugins.lsp.keys")
                local save = require("config.plugins.lsp.save")
                local highlight = require("config.plugins.lsp.highlight")

                -- region
                keys.SetKeys(event, client)
                save.Save(event, client)
                highlight.highlight(event, client)
                -- endregion
            end,
        })

        local capabilities = require('blink.cmp').get_lsp_capabilities()
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true
        }

        local servers = require('config.plugins.lsp.servers').servers
        local lspconfig = require('lspconfig')
        require('mason-lspconfig').setup {
            handlers = {
                function(server_name)
                    local server_config = servers[server_name] or {}
                    server_config.capabilities = vim.tbl_deep_extend('force', capabilities,
                        server_config.capabilities or {})
                    lspconfig[server_name].setup(server_config)
                end,
            },
        }
    end,
}
