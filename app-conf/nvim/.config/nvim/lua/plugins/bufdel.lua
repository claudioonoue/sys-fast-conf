return {
	"ojroques/nvim-bufdel",
	config = function()
		require("bufdel").setup({
			quit = false,
		})
		vim.keymap.set("n", "<leader>rr", function()
			vim.api.nvim_command("Neotree focus")
			vim.api.nvim_command("BufDelAll")
			vim.api.nvim_command("Neotree show")
		end)
	end,
}
