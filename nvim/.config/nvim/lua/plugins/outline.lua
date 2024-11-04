vim.keymap.set("n", ",s", "<cmd>Outline<CR>", { desc = "Toggle Outline", silent = true })

return {
    "hedyhli/outline.nvim",
    opts = {
        providers = {
            priority = { "lsp", "coc", "markdown", "norg" },
            lsp = {
                blacklist_clients = { "ruff" },
            },
            markdown = {
                filetypes = { "markdown" },
            },
        },
    },
}
