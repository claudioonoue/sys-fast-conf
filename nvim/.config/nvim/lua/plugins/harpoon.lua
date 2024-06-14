return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")

			-- REQUIRED
			harpoon:setup()
			-- REQUIRED

			vim.keymap.set("n", "<A-a>", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<A-l>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<A-Right>", function()
				harpoon:list():prev()
			end)
			vim.keymap.set("n", "<A-Left>", function()
				harpoon:list():next()
			end)
		end,
	},
}
