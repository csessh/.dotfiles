return {
    "ggandor/leap.nvim",
    config = function()
        vim.keymap.set({ "n", "x", "o" }, "<leader>s", "<Plug>(leap-forward-to)")
        vim.keymap.set({ "n", "x", "o" }, "<leader>S", "<Plug>(leap-backward-to)")
        vim.keymap.set({ "n", "x", "o" }, "<leader>x", "<Plug>(leap-forward-till)")
        vim.keymap.set({ "n", "x", "o" }, "<leader>X", "<Plug>(leap-backward-till)")
        vim.keymap.set({ "n", "x", "o" }, "<leader>gs", "<Plug>(leap-from-window)")
    end,
}
