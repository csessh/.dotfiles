vim.keymap.set("n", "s", "<Plug>(leap)", { desc = "Bi-directional leap" })
vim.keymap.set("n", "S", "<Plug>(leap-from-window)", { desc = "Leap from one window to another" })
vim.keymap.set({ "x", "o" }, "x", "<Plug>(leap-forward-till)", { desc = "Leap forward till" })
vim.keymap.set({ "x", "o" }, "X", "<Plug>(leap-backward-till)", { desc = "Leap backward till" })
vim.keymap.set({ "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward" })
vim.keymap.set({ "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward" })

return {
    "ggandor/leap.nvim",
    opts = {
        safe_labels = {},
        case_sensitive = false,
        equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" },
    },
}
