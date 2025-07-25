local M = {}

function DiagnosticGo(forward)
	local error_count = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local total = vim.diagnostic.get(0)
	if #error_count > 0 then
		vim.diagnostic.jump({ forward = forward, count = 1, severity = vim.diagnostic.severity.ERROR })
	elseif #total > 0 then
		vim.diagnostic.jump({ forward = forward, count = 1 })
	end
end

function M.set_keys(event, client)
	local map = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end

	map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
	map("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [D]efinition")
	map("gu", require("telescope.builtin").lsp_references, "[G]oto [U]sages")
	map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
	map("ge", function()
		DiagnosticGo(true)
	end, "[G]oto [E]rror")
	map("gE", function()
		DiagnosticGo(false)
	end, "[G]oto [E]rror (Previous)")
	map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
	map("<leader>r", vim.lsp.buf.rename, "[R]ename")
	map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

	if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
		map("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
		end, "[T]oggle Inlay [H]ints")
	end
end

return M
