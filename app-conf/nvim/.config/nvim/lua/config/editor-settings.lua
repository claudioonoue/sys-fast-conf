local M = {}

function M.setup()
	vim.opt.nu = true

	vim.opt.expandtab = true
	vim.opt.tabstop = 4
	vim.opt.softtabstop = 4
	vim.opt.shiftwidth = 4

	vim.opt.scrolloff = 15
	vim.opt.signcolumn = "yes"
	vim.opt.isfname:append("@-@")
end

return M
