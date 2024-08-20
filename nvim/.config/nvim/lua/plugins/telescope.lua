return {
    {
        "nvim-telescope/telescope-ui-select.nvim",
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local tsbuiltin = require "telescope.builtin"
            vim.keymap.set({ "n", "v" }, "<leader>lg", tsbuiltin.live_grep, {})
            vim.keymap.set({ "n", "v" }, "<leader>gs", tsbuiltin.grep_string, {})
            vim.keymap.set({ "n", "v" }, "<leader>bf", tsbuiltin.buffers, {})

            local args = {
                additional_args = function()
                    return { "--hidden" }
                end,
            }

            local telescope = require "telescope"
            telescope.setup {
                extensions = {
                    frecency = {
                        default_workspace = "CWD",
                        path_displays = { "shorten" },
                        show_scores = true,
                    },
                },
                pickers = {
                    live_grep = args,
                    grep_string = args,
                },
                defaults = {
                    file_ignore_patterns = { ".git", "node_modules" },
                },
            }
            telescope.load_extension "ui-select"
        end,
    },
}
