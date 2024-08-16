return {
	"christoomey/vim-tmux-navigator",
	config = function()
		vim.keymap.set("n", "<C-Up>", "<cmd>TmuxNavigateUp<CR>")
		vim.keymap.set("n", "<C-Down>", "<cmd>TmuxNavigateDown<CR>")
		vim.keymap.set("n", "<C-Left>", "<cmd>TmuxNavigateLeft<CR>")
		vim.keymap.set("n", "<C-Right>", "<cmd>TmuxNavigateRight<CR>")
	end,
}
