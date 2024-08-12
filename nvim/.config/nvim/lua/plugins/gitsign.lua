return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup {
            numhl = true,
            linehl = false,
            signcolumn = true,
            current_line_blame = true,
            current_line_blame_formatter = "<author>: <summary> (<author_time:%R>)",

            on_attach = function(bufnr)
                local gitsigns = require "gitsigns"

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal { "]c", bang = true }
                    else
                        gitsigns.nav_hunk "next"
                    end
                end)

                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal { "[c", bang = true }
                    else
                        gitsigns.nav_hunk "prev"
                    end
                end)

                -- Actions
                map("n", "<leader>sh", gitsigns.stage_hunk)
                map("n", "<leader>rh", gitsigns.reset_hunk)
                map("v", "<leader>sh", function()
                    gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
                end)
                map("v", "<leader>rh", function()
                    gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
                end)
                map("n", "<leader>hS", gitsigns.stage_buffer)
                map("n", "<leader>uh", gitsigns.undo_stage_hunk)
                map("n", "<leader>hR", gitsigns.reset_buffer)
                map("n", "<leader>ph", gitsigns.preview_hunk)
                map("n", "<leader>bl", function()
                    gitsigns.blame_line { full = true }
                end)
                map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
                map("n", "<leader>d", gitsigns.diffthis)
                map("n", "<leader>D", function()
                    gitsigns.diffthis "~"
                end)
                map("n", "<leader>td", gitsigns.toggle_deleted)

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end,
        }
    end,
}
