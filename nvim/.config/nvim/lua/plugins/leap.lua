vim.keymap.set("n", "s", "<Plug>(leap)", { noremap = true })
vim.keymap.set("n", "S", "<Plug>(leap-from-window)", { noremap = true })
vim.keymap.set({ "x", "o" }, "x", "<Plug>(leap-forward-till)", { noremap = true })
vim.keymap.set({ "x", "o" }, "X", "<Plug>(leap-backward-till)", { noremap = true })
vim.keymap.set({ "x", "o" }, "s", "<Plug>(leap-forward)", { noremap = true })
vim.keymap.set({ "x", "o" }, "S", "<Plug>(leap-backward)", { noremap = true })

return {
    "ggandor/leap.nvim",
    opts = {
        safe_labels = {},
    },
}
