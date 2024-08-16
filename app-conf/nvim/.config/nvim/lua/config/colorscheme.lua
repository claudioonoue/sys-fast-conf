local M = {}

function M.setup(color)
    color = color or "carbonfox"
    vim.cmd.colorscheme(color)
end

return M

