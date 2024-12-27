return {
    "ggandor/leap.nvim",
    keys = {
        { "x", mode = { "x", "o" }, "<Plug>(leap-forward-till)",  { desc = "Leap forward till" } },
        { "X", mode = { "x", "o" }, "<Plug>(leap-backward-till)", { desc = "Leap backward till" } },
        { "s", mode = { "x", "o" }, "<Plug>(leap-forward)",       { desc = "Leap forward" } },
        { "S", mode = { "x", "o" }, "<Plug>(leap-backward)",      { desc = "Leap backward" } },
        { "s", mode = { "n" },      "<Plug>(leap)",               { desc = "Bi-directional lead" } },
        { "S", mode = { "n" },      "<Plug>(leap-from-window)",   { desc = "Leap from one window to another" } },
    },
    opts = {
        safe_labels = {},
        case_sensitive = false,
        equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" },
    },
}
