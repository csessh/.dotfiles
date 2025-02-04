return {
    "hedyhli/outline.nvim",
    keys = {
        {
            ",o",
            "<cmd>Outline<CR>",
            desc = "Toggle Outline",
            silent = true,
        },
    },
    opts = {
        providers = {
            priority = {
                "lsp",
                "coc",
                "markdown",
                "norg",
            },
            lsp = {
                blacklist_clients = { "ruff" },
            },
            markdown = {
                filetypes = { "markdown" },
            },
        },
    },
}
