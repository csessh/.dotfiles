return {
    "ggandor/leap.nvim",
    keys = {
        { "<leader>s", mode = { "n" }, "<Plug>(leap)", { desc = "Bi-directional lead" } },
        { "<leader>S", mode = { "n" }, "<Plug>(leap-from-window)", { desc = "Leap from one window to another" } },
    },
    opts = {
        safe_labels = {},
        case_sensitive = false,
        equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" },
    },
}
