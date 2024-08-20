return {
    "ggandor/leap.nvim",
    config = function()
        vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward-to)")
        vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward-to)")
        vim.keymap.set({ "x", "o" }, "x", "<Plug>(leap-forward-till)")
        vim.keymap.set({ "x", "o" }, "X", "<Plug>(leap-backward-till)")
        vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")

        require("leap").opts.safe_labels = {} -- Do not jump to the first occurence automatically
    end,
}
