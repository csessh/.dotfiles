return {
  "chentoast/marks.nvim",
  opts = {
    builtin_marks = { ".", "<", ">", "^" },
    cyclic = true,
    default_mappings = true,
    excluded_buftypes = { "terminal" },
    excluded_filetypes = { "neo-tree", "dashboard" },
    force_write_shada = false,
    mappings = {},
    refresh_interval = 250,
    sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
    signcolumn = "auto",
  },
}
