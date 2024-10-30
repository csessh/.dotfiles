return {
    "lewis6991/gitsigns.nvim",
    opts = {
        numhl = true,
        linehl = false,
        signcolumn = true,
        current_line_blame = true,
        current_line_blame_formatter = "<author> (<author_time:%R>): <summary>",
        on_attach = function(bufnr)
            local gs = require "gitsigns"
            vim.keymap.set("n", "<leader>?", gs.preview_hunk, { buffer = bufnr, desc = "Preview current hunk" })
            vim.keymap.set("n", "<leader>/", gs.toggle_deleted, { buffer = bufnr, desc = "Show deleted lines" })
            vim.keymap.set("n", "]h", gs.next_hunk, { noremap = true, buffer = bufnr, desc = "Jump to next hunk" })
            vim.keymap.set("n", "[h", gs.prev_hunk, { noremap = true, buffer = bufnr, desc = "Jump to previous hunk" })
            vim.keymap.set("n", "]r", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
        end,
    },
}
