return {
    {
        "nvim-telescope/telescope-ui-select.nvim",
    },
    {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("frecency.config").setup {
                auto_validate = true,
                db_safe_mode = false,
                show_scores = true,
            }

            vim.keymap.set({ "n", "v" }, "<Leader>ff", function()
                require("telescope").extensions.frecency.frecency {}
            end)
        end,
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

            local telescope = require "telescope"
            telescope.setup {
                defaults = {
                    path_display = { "smart" },
                    file_ignore_patterns = { ".git", "node_modules" },
                    layout_strategy = "vertical",
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                    live_grep = {
                        additional_args = function()
                            return { "--hidden" }
                        end,
                    },
                    grep_string = {
                        additional_args = function()
                            return { "--hidden" }
                        end,
                    },
                },
            }

            telescope.load_extension "ui-select"
            telescope.load_extension "frecency"
        end,
    },
}
