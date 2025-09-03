local function set_clipboard_provider()
	if vim.env.NVIM_CLIPBOARD == "osc52" then
		vim.opt.clipboard = "osc52"
	else
		vim.opt.clipboard = "unnamedplus"
	end
end

set_clipboard_provider()

vim.api.nvim_create_augroup("ClipboardProvider", { clear = true })
vim.api.nvim_create_autocmd(
	{ "FocusGained", "VimResume" },
	{ callback = set_clipboard_provider, group = "ClipboardProvider" }
)
