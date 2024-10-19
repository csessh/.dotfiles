return {
    { "nvim-telescope/telescope-ui-select.nvim" },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local tsbuiltin = require "telescope.builtin"

            vim.keymap.set({ "n", "v" }, "<leader>ff", tsbuiltin.find_files, { desc = "Telescope find files" })
            vim.keymap.set({ "n", "v" }, "<leader>lg", tsbuiltin.live_grep, { desc = "Telescope live grep" })
            vim.keymap.set(
                { "n", "v" },
                "<leader>gw",
                tsbuiltin.grep_string,
                { desc = "Telescope grep string under cursor" }
            )
            vim.keymap.set({ "n", "v" }, "<leader>bf", tsbuiltin.buffers, { desc = "Telescope show available buffers" })

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
                        additional_args = { "--hidden" },
                    },
                    grep_string = {
                        additional_args = { "--hidden" },
                    },
                },
            }

            telescope.load_extension "ui-select"
        end,
    },
}
