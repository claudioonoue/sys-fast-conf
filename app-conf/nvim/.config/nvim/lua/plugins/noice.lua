return {
	{
		"folke/noice.nvim",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
					message = {
						enabled = true,
						view = "mini",
					},
				},
				presets = {
					long_message_to_split = true, -- long messages will be sent to a split
					lsp_doc_border = true, -- add a border to hover docs and signature help
				},
				messages = {
					view = "cmdline",
					vier_error = "notify",
				},
				--routes = {
				--{
				--	view = "notify",
				--	filter = {
				--		warning = true,
				--	},
				--	opts = { skip = true },
				--},
				--},
			})

			vim.keymap.set("n", "<leader>dn", "<cmd>NoiceDismiss<CR>")
		end,
	},
}
