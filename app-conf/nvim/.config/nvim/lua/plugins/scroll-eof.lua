return {
	"Aasim-A/scrollEOF.nvim",
	event = { "CursorMoved", "WinScrolled" },
	opts = {},
	config = function()
		-- Default settings
		require("scrollEOF").setup({
			-- The pattern used for the internal autocmd to determine
			-- where to run scrollEOF. See https://neovim.io/doc/user/autocmd.html#autocmd-pattern
			pattern = "*",
			-- Whether or not scrollEOF should be enabled in insert mode
			insert_mode = false,
			-- Whether or not scrollEOF should be enabled in floating windows
			floating = true,
			-- List of filetypes to disable scrollEOF for.
			disabled_filetypes = {},
			-- List of modes to disable scrollEOF for. see https://neovim.io/doc/user/builtin.html#mode()
			disabled_modes = {},
		})
	end,
}
