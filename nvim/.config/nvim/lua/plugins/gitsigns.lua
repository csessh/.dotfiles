return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup {
            numhl = true,
            linehl = false,
            signcolumn = true,
            current_line_blame = true,
            current_line_blame_formatter = "<author> (<author_time:%R>): <summary>",

            on_attach = function(bufnr)
                local gitsigns = require "gitsigns"
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                map("n", ",h", function()
                    if vim.wo.diff then
                        vim.cmd.normal { "]c", bang = true }
                    else
                        gitsigns.nav_hunk "next"
                    end
                end)

                map("n", ",H", function()
                    if vim.wo.diff then
                        vim.cmd.normal { "[c", bang = true }
                    else
                        gitsigns.nav_hunk "prev"
                    end
                end)

                -- Actions
                map("n", ",s", gitsigns.stage_hunk)
                map("v", ",s", function()
                    gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
                end)
                map("n", ",S", gitsigns.undo_stage_hunk)

                map("n", ",r", gitsigns.reset_hunk)
                map("v", ",r", function()
                    gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
                end)

                map("n", ",p", gitsigns.preview_hunk)
            end,
        }
    end,
}
