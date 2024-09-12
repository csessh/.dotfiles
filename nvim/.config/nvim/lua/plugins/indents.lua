return {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
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
        exclude_filetypes = {
            dashboard = true,
            themery = true,
            quickfix = true,
        },
    },
}
