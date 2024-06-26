return {
    {
        "EdenEast/nightfox.nvim",
        config = function()
            require("nightfox").setup({})
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        config = function()
            require("cyberdream").setup({
                transparent = true,
                borderless_telescope = false,
            })
        end,
    },
}
