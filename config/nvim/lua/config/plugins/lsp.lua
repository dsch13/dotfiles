---@diagnostic disable: missing-fields
return {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'williamboman/mason.nvim', config = true },
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

        -- add registry for Razor and Rzls
        require('mason').setup {
            registries = {
                'github:mason-org/mason-registry',
                'github:crashdummyy/mason-registry',
            },
        }

        --  This function gets run when an LSP attaches to a particular buffer.
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



        -- Enable the following language servers
        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' },
                        },
                        completion = {
                            callSnippet = 'Replace',
                        },
                    },
                },
            },
            volar = {
                filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
                init_options = {
                    vue = {
                        hybridMode = false,
                    },
                    typescript = {
                        tsdk = vim.fn.stdpath("data") .. "/mason/packages/typescript/lib"
                    },
                    languageFeatures = {
                        diagnostics = {
                            className = true
                        },
                        semanticTokens = true
                    },
                    documentFeatures = {
                        classNameCompletion = true
                    }
                }
            },
            basedpyright = {
                init_options = {
                    provideFormatter = false,
                },
            },
        }


        local ensure_installed = vim.tbl_keys(servers)
        vim.list_extend(ensure_installed, {
            'mypy',
            'stylua',
            'html',
            'tailwindcss',
            'rzls',
            'roslyn',
            'ruff'
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }


        local capabilities = require('blink.cmp').get_lsp_capabilities()
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true
        }
        local lspconfig = require('lspconfig')
        require('mason-lspconfig').setup {
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend('force', capabilities, server.capabilities or {})
                    lspconfig[server_name].setup(server)
                end,
            },
        }
    end,
}

-- omnisharp = {
--     filetypes = { "cs", "csproj", "sln", "razor", "cshtml" },
--     cmd = {
--         vim.fn.stdpath("data") .. "/mason/packages/omnisharp/omnisharp",
--         "--languageserver",
--         "--hostPID", tostring(vim.fn.getpid()),
--         "--encoding", "utf-8",
--         "--useLatestMsBuild",
--         "--enable-import-completion",
--         "--disable-lsp-caching" -- Reduces memory overhead
--     },
--     root_dir = require('lspconfig.util').root_pattern("*.sln", "*.csproj", ".git"),
--     settings = {
--         FormattingOptions = {
--             EnableEditorConfigSupport = true
--         },
--         MsBuild = {
--             LoadProjectsOnDemand = false,
--             UseLegacySdkResolver = false
--         },
--         RoslynExtensionsOptions = {
--             EnableImportCompletion = true
--         },
--         CSharp = {
--             EnableAnalyzersSupport = false,    -- Disables slow Roslyn analyzers
--             EnableEditorConfigSupport = true,
--             EnableDecompilationSupport = false -- Reduces CPU load
--         }
--     }
-- },
