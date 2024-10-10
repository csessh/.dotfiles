return {
    "lewis6991/gitsigns.nvim",
    opts = {
        numhl = true,
        linehl = false,
        signcolumn = true,
        current_line_blame = false,
        current_line_blame_formatter = "<author> (<author_time:%R>): <summary>",
        on_attach = function(bufnr)
            local gs = require "gitsigns"
            vim.keymap.set("n", "<leader>?", gs.preview_hunk, { buffer = bufnr, noremap = true })
            vim.keymap.set("n", "<leader>/", gs.toggle_deleted, { buffer = bufnr, noremap = true })
        end,
    },
}
