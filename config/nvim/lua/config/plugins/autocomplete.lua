return {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
        "Kaiser-Yang/blink-cmp-avante",
        "rafamadriz/friendly-snippets",
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
                local luasnip = require("luasnip")

                local function remove_snippet(ft, keys)
                    local existing_snippets = luasnip.get_snippets(ft) -- Correct API

                    if existing_snippets then
                        for _, key in ipairs(keys) do
                            existing_snippets[key] = nil
                        end
                    end
                end

                remove_snippet("vue", {
                    "voptions", "vdata", "vmethod", "vwatch", "vsetup",
                    "vmodel", "vfilter", "vcreated", "vmounted", "vbeforeMount"
                })
            end
        },
    },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
        keymap = { preset = "default" },
        snippets = { preset = "luasnip" },
        appearance = {
            nerd_font_variant = "mono"
        },
        sources = {
            default = { "avante", "lsp", "path", "snippets", "buffer" },
            providers = {
                avante = {
                    module = "blink-cmp-avante",
                    name = "Avante"
                }
            }
        },
        fuzzy = { implementation = "prefer_rust" },
        completion = {
            menu = { border = "rounded" },
            ghost_text = { enabled = false },
        },
    },
    opts_extend = { "sources.default" },
}
