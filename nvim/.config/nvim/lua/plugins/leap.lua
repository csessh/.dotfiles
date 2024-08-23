return {
    "ggandor/leap.nvim",
    config = function()
        vim.keymap.set({ "n", "x", "o" }, "<leader>s", "<Plug>(leap-forward-to)")
        vim.keymap.set({ "n", "x", "o" }, "<leader>S", "<Plug>(leap-backward-to)")
        vim.keymap.set({ "n", "x", "o" }, "<leader>gs", "<Plug>(leap-from-window)")

        require("leap").opts.safe_labels = {} -- Do not jump to the first occurence automatically
    end,
}
