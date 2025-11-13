vim.keymap.set("n", "<leader>-", ":Neotree toggle<CR>", { desc = "Toggle Neotree" })

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        sort_case_insensitive = true,
        filesystem = {
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_by_name = {
                    ".DS_Store",
                    ".venv",
                    ".ruff_cache",
                    "__pycache__",
                },
                hide_by_pattern = {
                    "*.egg-info",
                    ".git*",
                    ".*_cache",
                },
            },
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
        },
        default_component_configs = {
            name = {
                trailing_slash = false,
                use_git_status_colors = true,
                highlight = "NeoTreeFileName",
            },
            git_status = {
                symbols = {
                    added = "✚",
                    modified = "",
                    deleted = "✖",
                    renamed = "󰁕",
                    untracked = "",
                    ignored = "",
                    unstaged = "󰄱",
                    staged = "",
                    conflict = "",
                },
            },
        },
        window = {
            position = "left",
            width = 40,
        },
        buffers = {
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
        },
    },
}
