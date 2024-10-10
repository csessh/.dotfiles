return {
    "lewis6991/gitsigns.nvim",
    opts = {
        numhl = true,
        linehl = false,
        signcolumn = true,
        current_line_blame = false,
        current_line_blame_formatter = "<author> (<author_time:%R>): <summary>",
        on_attach = function(bufnr)
            local function map(mode, lhs, rhs)
                local opts = { noremap = true }
                opts.buffer = bufnr
                vim.keymap.set(mode, lhs, rhs, opts)
            end

            local gs = require "gitsigns"
            map("n", "<leader>?", gs.preview_hunk)
            map("n", "<leader>/", gs.toggle_deleted)
        end,
    },
}
