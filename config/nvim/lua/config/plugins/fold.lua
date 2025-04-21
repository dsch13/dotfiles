return {
    'kevinhwang91/nvim-ufo',
    dependencies = {
        'kevinhwang91/promise-async',
    },
    opts = {
        fold_virt_text_handler = require("config.plugins.fold.virtualText").handler
    },
    init = function()
        require("config.plugins.fold.foldColumn").setup()

        -- region Test Region folding
        vim.o.foldcolumn = 'auto:1'
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        -- endregion

        vim.keymap.set("n", "zp", require("config.plugins.fold.peek").peek, { desc = "[P]eek fold" })
    end
}
