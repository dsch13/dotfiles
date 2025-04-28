local M = {}

M.servers = {
    lua_ls = {
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
    volar = {
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
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

return M
