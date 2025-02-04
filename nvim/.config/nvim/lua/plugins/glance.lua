return {
    "dnlhc/glance.nvim",
    keys = {
        { "gd", ":Glance definitions<CR>", desc = "Glance at definition", silent = true },
        { "gre", ":Glance references<CR>", desc = "Glance at references", silent = true },
        { "gi", ":Glance implementations<CR>", desc = "Glance at implementations", silent = true },
    },
    opts = {
        list = { position = "left" },
    },
}
