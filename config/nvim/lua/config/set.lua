-- setup line numbering
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- setup tabsize
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

--Swap and undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- better colors
vim.opt.termguicolors = true

-- enable mouse
vim.opt.mouse = "a"

-- use system clipboard
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- wrap text and end of window
vim.opt.breakindent = true

-- decrease update time
vim.opt.updatetime = 50

-- decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- show whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- live preview substitutions
vim.opt.inccommand = "split"

-- show which line your cursor is on
vim.opt.cursorline = true

-- keep 10 lines between cursor and edge of screen
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

-- make searching case insensitive
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- color column for wrapping
vim.opt.colorcolumn = "160"

-- Statusline on last window
vim.opt.laststatus = 3

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
