return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "-", ":Oil<CR>", silent = true, desc = "Open Oil at current buffer's directory" },
    },
    opts = {
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
        keymaps = {
            ["g?"] = { "actions.show_help", mode = "n" },
            ["<CR>"] = "actions.select",
            ["<Tab>s"] = { "actions.select", opts = { vertical = true } },
            ["<Tab>v"] = { "actions.select", opts = { horizontal = true } },
            ["<Tab>t"] = { "actions.select", opts = { tab = true } },
            ["<Tab>p"] = "actions.preview",
            ["<Tab>q"] = { "actions.close", mode = "n" },
            ["<leader>r"] = "actions.refresh",
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
}
