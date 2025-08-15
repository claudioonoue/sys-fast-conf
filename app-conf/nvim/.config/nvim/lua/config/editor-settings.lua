local M = {}

function M.setup()
	vim.opt.nu = true
	vim.opt.expandtab = true
	vim.opt.tabstop = 4
	vim.opt.softtabstop = 4
	vim.opt.shiftwidth = 4
	vim.opt.breakindent = true
	vim.opt.scrolloff = 15
	vim.opt.signcolumn = "yes"
	vim.opt.isfname:append("@-@")
	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.updatetime = 250
	vim.opt.timeoutlen = 300
	vim.opt.list = true
	vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
	vim.opt.inccommand = "split"
	vim.opt.cursorline = true
	vim.opt.colorcolumn = "100"
	--vim.opt.whichwrap = "b,s,<,>,[,],h,l"

	vim.g.have_nerd_font = true
end

return M
