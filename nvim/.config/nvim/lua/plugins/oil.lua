return {
    {
        "refractalize/oil-git-status.nvim",
        dependencies = { "stevearc/oil.nvim" },
        opts = { show_ignored = false },
    },
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "-", ":Oil<CR>", silent = true, desc = "Open Oil at current buffer's directory" },
        },
        opts = {
            win_options = { signcolumn = "yes:2" },
            columns = { "icon" },
            skip_confirm_for_simple_edits = true,
            watch_for_changes = true,
            view_options = {
                show_hidden = true,
                is_hidden_file = function(name, bufnr)
                    local m = name:match "^%."
                    return m ~= nil
                end,
                case_insensitive = true,
                sort = {
                    { "type", "asc" },
                    { "name", "asc" },
                },
            },
            use_default_keymaps = false,
            keymaps = {
                ["g?"] = { "actions.show_help", mode = "n" },
                ["<CR>"] = "actions.select",
                ["<C-s>"] = { "actions.select", opts = { vertical = true } },
                ["<C-v>"] = { "actions.select", opts = { horizontal = true } },
                ["<C-t>"] = { "actions.select", opts = { tab = true } },
                ["<C-p>"] = "actions.preview",
                ["<C-q>"] = { "actions.close", mode = "n" },
                ["<C-r>"] = "actions.refresh",
                ["-"] = { "actions.parent", mode = "n" },
                ["_"] = { "actions.open_cwd", mode = "n" },
                ["`"] = { "actions.cd", mode = "n" },
                ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                ["gs"] = { "actions.change_sort", mode = "n" },
                ["gx"] = "actions.open_external",
                ["g."] = { "actions.toggle_hidden", mode = "n" },
                ["g\\"] = { "actions.toggle_trash", mode = "n" },
            },
        },
    },
}
