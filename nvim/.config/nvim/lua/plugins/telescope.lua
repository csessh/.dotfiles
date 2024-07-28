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
            vim.keymap.set({ "n", "v" }, "<leader>gss", tsbuiltin.git_status, {})
            vim.keymap.set({ "n", "v" }, "<leader>adog", tsbuiltin.git_commits, {})
            vim.keymap.set({ "n", "v" }, "<leader>lg", tsbuiltin.live_grep, {})
            vim.keymap.set({ "n", "v" }, "<leader>gs", tsbuiltin.grep_string, {})
            vim.keymap.set({ "n", "v" }, "<leader>bf", tsbuiltin.buffers, {})

            local telescope = require "telescope"
            telescope.setup {
                extensions = {
                    frecency = {
                        default_workspace = "CWD",
                        path_displays = { "shorten" },
                        show_scores = true,
                    },
                },
            }
            telescope.load_extension "ui-select"
        end,
    },
}
