return {
    { "nvim-telescope/telescope-ui-select.nvim" },
    {
        "nvim-telescope/telescope-frecency.nvim",
        version = "*", -- install the latest stable version
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            {
                "<leader>ff",
                mode = { "n", "v" },
                ':Telescope frecency workspace=CWD path_display={"smart"} <CR>',
                {
                    desc = "Telescope find files using frecency",
                    silent = true,
                },
            },
            {
                "<leader>lg",
                mode = { "n", "v" },
                require("telescope.builtin").live_grep,
                { desc = "Telescope live grep" },
            },
            {
                "<leader>gw",
                mode = { "n", "v" },
                require("telescope.builtin").grep_string,
                { desc = "Telescope grep string under cursor" },
            },
            {
                "<leader>bf",
                mode = { "n", "v" },
                require("telescope.builtin").buffers,
                { desc = "Telescope show available buffers" },
            },
        },
        config = function()
            local telescope = require "telescope"
            telescope.setup {
                defaults = {
                    path_display = { "smart" },
                    layout_strategy = "bottom_pane",
                    file_ignore_patterns = {
                        "^.git/*",
                        ".DS_Store",
                        ".venv",
                        ".ruff_cache",
                        "__pycache__",
                    },
                },
                pickers = {
                    find_files = { hidden = true },
                    frecency = { hidden = true },
                    live_grep = {
                        additional_args = { "--hidden" },
                    },
                    grep_string = {
                        additional_args = { "--hidden" },
                    },
                },
            }

            telescope.load_extension "ui-select"
            telescope.load_extension "frecency"
        end,
    },
}
