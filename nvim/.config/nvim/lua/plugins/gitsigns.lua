return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup {
            numhl = true,
            linehl = false,
            signcolumn = true,
            current_line_blame = true,
            current_line_blame_formatter = "<author> (<author_time:%R>): <summary>",
        }
    end,
}
