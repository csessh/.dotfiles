vim.keymap.set("n", "s", "<Plug>(leap)")
vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
vim.keymap.set({ "x", "o" }, "x", "<Plug>(leap-forward-till)")
vim.keymap.set({ "x", "o" }, "X", "<Plug>(leap-backward-till)")
vim.keymap.set({ "x", "o" }, "s", "<Plug>(leap-forward)")
vim.keymap.set({ "x", "o" }, "S", "<Plug>(leap-backward)")

return {
    "ggandor/leap.nvim",
    opts = {
        safe_labels = {},
    },
}
