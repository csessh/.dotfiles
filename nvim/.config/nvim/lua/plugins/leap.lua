return {
    "ggandor/leap.nvim",
    keys = {
        {
            "<leader>l",
            "<Plug>(leap)",
            desc = "Bi-directional lead",
        },
        {
            "<leader>L",
            "<Plug>(leap-from-window)",
            desc = "Leap from one window to another",
        },
    },
    opts = {
        safe_labels = {},
        case_sensitive = false,
        equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" },
    },
}
