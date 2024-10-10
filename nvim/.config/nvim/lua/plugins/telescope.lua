return {
    { "nvim-telescope/telescope-ui-select.nvim" },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local tsbuiltin = require "telescope.builtin"

            vim.keymap.set({ "n", "v" }, "<leader>ff", tsbuiltin.find_files, { noremap = true })
            vim.keymap.set({ "n", "v" }, "<leader>lg", tsbuiltin.live_grep, { noremap = true })
            vim.keymap.set({ "n", "v" }, "<leader>gw", tsbuiltin.grep_string, { noremap = true })
            vim.keymap.set({ "n", "v" }, "<leader>bf", tsbuiltin.buffers, { noremap = true })

            vim.keymap.set({ "n", "v" }, "<leader>fp", function()
                tsbuiltin.find_files { cwd = require("lazy.core.config").options.root }
            end, { noremap = true })

            local telescope = require "telescope"
            telescope.setup {
                defaults = {
                    path_display = { "smart" },
                    layout_strategy = "vertical",
                    file_ignore_patterns = { "^.git/*" },
                },
                pickers = {
                    find_files = { hidden = true },
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
        end,
    },
}
