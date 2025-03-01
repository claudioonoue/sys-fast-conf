local M = {}

function M.setup()
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	vim.keymap.set("n", "<leader>o", "m`o<Esc>``")
	vim.keymap.set("n", "<leader>O", "m`O<Esc>``")

	vim.keymap.set({ "n", "v" }, "<Del>", '"_d')

	-- vim.keymap.set("n", "<leader>qq", "<cmd>let @/=''<CR>")
	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

	vim.keymap.set("n", "<C-S-Up>", "<cmd>wincmd k<CR>")
	vim.keymap.set("n", "<C-S-Down>", "<cmd>wincmd j<CR>")
	vim.keymap.set("n", "<C-S-Left>", "<cmd>wincmd h<CR>")
	vim.keymap.set("n", "<C-S-Right>", "<cmd>wincmd l<CR>")
end

return M
