local M = {}

vim.g.format_enabled = true

function M.notify_status(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local b = vim.b[bufnr]

	local gs = vim.g.format_enabled and "true" or "false"
	local bs = b.format_enabled and "true" or "false"
	vim.notify("Format State: G{" .. gs .. "} B{" .. bs .. "}")
end

function M.is_enabled(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local b = vim.b[bufnr]
	if b.format_enabled == nil then
		b.format_enabled = true
	end

	return b.format_enabled and vim.g.format_enabled
end

function M.enable(scope)
	local bufnr = vim.api.nvim_get_current_buf()
	local b = vim.b[bufnr]
	if scope == "global" then
		vim.g.format_enabled = true
	else
		b.format_enabled = true
	end

	M.notify_status(bufnr)
end

function M.disable(scope)
	local bufnr = vim.api.nvim_get_current_buf()
	local b = vim.b[bufnr]
	if scope == "global" then
		vim.g.format_enabled = false
	else
		b.format_enabled = false
	end

	M.notify_status(bufnr)
end

function M.toggle(scope)
	local bufnr = vim.api.nvim_get_current_buf()
	local b = vim.b[bufnr]
	if scope == "global" then
		vim.g.format_enabled = not vim.g.format_enabled
	elseif b.format_enabled == nil then
		b.format_enabled = false
	else
		b.format_enabled = not b.format_enabled
	end

	M.notify_status(bufnr)
end

local scopes = { "global", "buffer" }

vim.api.nvim_create_user_command("FormatEnable", function(opts)
	M.enable(opts.args ~= "" and opts.args or "buffer")
end, {
	nargs = "?",
	complete = function()
		return scopes
	end,
})

vim.api.nvim_create_user_command("FormatDisable", function(opts)
	M.disable(opts.args ~= "" and opts.args or "buffer")
end, {
	nargs = "?",
	complete = function()
		return scopes
	end,
})

vim.api.nvim_create_user_command("FormatToggle", function(opts)
	M.toggle(opts.args ~= "" and opts.args or "buffer")
end, {
	nargs = "?",
	complete = function()
		return scopes
	end,
})

return M
