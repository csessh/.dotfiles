vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true })
vim.diagnostic.config { virtual_text = false }

return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    opts = {
        hi = { background = "None" },
        options = {
            show_source = true,
            multiple_diag_under_cursor = true,
        },
        severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
        },
    },
}
