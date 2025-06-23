local M = {}

function M.lsp_diagnostics_summary()
	local icons = {
		error = "%#StatuslineError#",
		warn = "%#StatuslineWarn#",
		info = "%#StatuslineInfo#",
		hint = "%#StatuslineHint#",
	}
	local count = function(sev)
		return #vim.diagnostic.get(0, { severity = sev })
	end

	local e = count(vim.diagnostic.severity.ERROR)
	local w = count(vim.diagnostic.severity.WARN)
	local i = count(vim.diagnostic.severity.INFO)
	local h = count(vim.diagnostic.severity.HINT)

	return string.format("%s %d %s %d %s %d", icons.error, e, icons.warn, w, icons.info, i)
end

function M.setup_diagnostics()
	vim.diagnostic.config({
		virtual_text = { spacing = 4, prefix = "●" },
		signs = true,
		underline = true,
		update_in_insert = false,
		severity_sort = true,
	})
end

return M
