return {
    "ggandor/leap.nvim",
    config = function()
        vim.keymap.set("n", "s", "<Plug>(leap)")
        vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
        vim.keymap.set({ "x", "o" }, "x", "<Plug>(leap-forward-till)")
        vim.keymap.set({ "x", "o" }, "X", "<Plug>(leap-backward-till)")
        vim.keymap.set({ "x", "o" }, "s", "<Plug>(leap-forward)")
        vim.keymap.set({ "x", "o" }, "S", "<Plug>(leap-backward)")

        -- Disable auto-jumping to the first match
        require("leap").opts.safe_labels = {}
    end,
}
