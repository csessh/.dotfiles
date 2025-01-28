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
            vim.keymap.set("n", ",p", gs.preview_hunk, { buffer = bufnr, desc = "Preview current hunk" })
            vim.keymap.set("n", ",/", gs.preview_hunk_inline, { buffer = bufnr, desc = "Show deleted lines" })
            vim.keymap.set("n", ",r", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
            vim.keymap.set("n", ",?", gs.blame_line, { buffer = bufnr, desc = "Blame current line" })

            vim.keymap.set("n", ",]", function()
                gs.nav_hunk "next"
            end, { buffer = bufnr, desc = "Jump to next hunk" })

            vim.keymap.set("n", ",[", function()
                gs.nav_hunk "prev"
            end, { buffer = bufnr, desc = "Jump to previous hunk" })
        end,
    },
}
