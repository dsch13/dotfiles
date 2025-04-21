local M = {}

M.setup = function()
    vim.o.fillchars = [[eob:~,fold: ,foldopen:,foldsep: ,foldclose:]]
    local fill_chars = vim.opt.fillchars:get()

    local function get_fold(line_num)
        if vim.fn.foldlevel(line_num) <= vim.fn.foldlevel(line_num - 1) then return ' ' end
        return vim.fn.foldclosed(line_num) == -1 and fill_chars.foldopen or fill_chars.foldclose
    end

    _G.get_statuscol = function() return "%s%l " .. get_fold(vim.v.lnum) .. " " end
    vim.o.statuscolumn = "%!v:lua.get_statuscol()"
end

return M
