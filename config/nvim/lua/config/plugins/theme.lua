-- return { "folke/tokyonight.nvim", config = function() vim.cmd.colorscheme "tokyonight" end }
--

return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 2000,
    config = function()
        vim.cmd.colorscheme("rose-pine-moon")

        vim.cmd([[
          hi Normal      guibg=#232136
          hi SignColumn  guibg=#232136
          hi LineNr      guibg=#232136
          hi VertSplit   guibg=#232136
          hi EndOfBuffer guibg=#232136
        ]])
    end
}

-- return { "shaunsingh/nord.nvim", config = function()
--   vim.cmd.colorscheme = "nord"
--   vim.g.nord_contrast = true
--   vim.g.nord_borders = false
--   vim.g.nord_disable_background = false
--   vim.g.nord_italic = false
--   vim.g.nord_uniform_diff_background = true
--   vim.g.nord_bold = false
-- end}
