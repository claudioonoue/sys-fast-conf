return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = {
				"lua",
				"c",
				"go",
				"gomod",
				"gosum",
				"gowork",
				"gotmpl",
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
				"php",
				"python",
				"rust",
				"sql",
				"gitignore",
				"dockerfile",
				"bash",
				"csv",
				"make",
				"json",
				"yaml",
				"xml",
				"markdown",
				"markdown_inline",
				"vim",
				"regex",
			},
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
