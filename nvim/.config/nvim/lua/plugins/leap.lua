return {
    "ggandor/leap.nvim",
    config = function()
        vim.keymap.set("n", "s", "<Plug>(leap)")
        vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
        vim.keymap.set({ "x", "o" }, "s", "<Plug>(leap-forward)")
        vim.keymap.set({ "x", "o" }, "S", "<Plug>(leap-backward)")

        vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" }) -- or some grey
        vim.api.nvim_set_hl(0, "LeapMatch", {
            -- For light themes, set to 'black' or similar.
            fg = "white",
            bold = true,
            nocombine = true,
        })

        -- Disable auto-jumping to the first match
        -- require("leap").opts.safe_labels = {}
    end,
}
