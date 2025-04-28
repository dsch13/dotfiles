local M = {}

function M.Save(event, client)
    if not event then return end
    if not client then return end

    -- Format on save
    if client:supports_method("textDocument/formatting") and vim.bo.filetype ~= "cshtml" then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = event.buf,
            callback = function()
                vim.lsp.buf.format({ bufnr = event.buf, id = client.id })
                vim.defer_fn(function()
                    vim.diagnostic.show(nil, event.buf)
                end, 100)
            end
        })
    end
end

return M
