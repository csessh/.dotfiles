return {
    "chentoast/marks.nvim",
    opts = {
        default_mappings = true,
        builtin_marks = { ".", "<", ">", "^" },
        cyclic = true,
        signcolumn = "auto",
        force_write_shada = false,
        refresh_interval = 250,
        sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
        excluded_filetypes = { "neo-tree", "dashboard" },
        excluded_buftypes = { "terminal" },
        mappings = {},
    },
}
