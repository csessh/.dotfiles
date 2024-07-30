return {
    "dmtrKovalenko/caps-word.nvim",
    lazy = true,
    opts = {
        -- Automatically changes `-` to `_` when caps word is activated
        auto_underscore_inject = true,
        -- Does not turn the caps mode off on number input
        enable_numbers_in_caps = true,
    },
    keys = {
        {
            mode = { "i", "n" },
            "<C-s>",
            "<cmd>lua require('caps-word').toggle()<CR>",
        },
    },
}
