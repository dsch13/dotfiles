return {
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = 'luvit-meta/library', words = { 'vim%.uv' } },
            },
        },
    },
    {
        'ThePrimeagen/vim-be-good',
        init = function()
            _G.vim_be_good_delete_me_offset = 35
        end
    }
}
