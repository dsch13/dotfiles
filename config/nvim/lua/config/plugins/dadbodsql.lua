return {
    "tpope/vim-dadbod",
    dependencies = {
        { 'kristijanhusak/vim-dadbod-ui',         lazy = true },
        { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
        'DBUI',
        'DBUIToggle',
        'DBUIAddConnection',
        'DBUIFindBuffer',
    },
    init = function()
        if (require("config.utils").isModuleAvailable("config.plugins.sql.connections")) then
            require("config.plugins.sql.connections").setup()
        end
        vim.g.db_ui_use_nerd_fonts = 1
    end,
}
