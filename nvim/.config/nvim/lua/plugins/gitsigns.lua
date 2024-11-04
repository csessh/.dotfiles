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
            vim.keymap.set("n", ",p", gs.preview_hunk, { buffer = bufnr, desc = "Preview current hunk" })
            vim.keymap.set("n", ",/", gs.toggle_deleted, { buffer = bufnr, desc = "Show deleted lines" })
            vim.keymap.set("n", ",]", gs.next_hunk, { noremap = true, buffer = bufnr, desc = "Jump to next hunk" })
            vim.keymap.set("n", ",[", gs.prev_hunk, { noremap = true, buffer = bufnr, desc = "Jump to previous hunk" })
            vim.keymap.set("n", ",r", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
            vim.keymap.set("n", ",?", gs.blame_line, { buffer = bufnr, desc = "Blame current line" })
        end,
    },
}
