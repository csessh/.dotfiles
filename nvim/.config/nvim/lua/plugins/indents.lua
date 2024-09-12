return {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("hlchunk").setup {
            chunk = {
                enable = true,
                style = "#0fe9ee",
                use_treesitter = true,
            },
            indent = {
                enable = true,
                chars = {
                    "¦",
                },
                style = {
                    vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID "Whitespace"), "fg", "gui"),
                },
            },
            line_num = {
                enable = true,
                style = "#0fe9ee",
                use_treesitter = true,
            },
        }
    end,
}
