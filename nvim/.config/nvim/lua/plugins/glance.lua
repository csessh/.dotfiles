return {
    "dnlhc/glance.nvim",
    keys = {
        { "gd", ":Glance definitions<CR>",     { desc = "Glance at definition" } },
        { "gr", ":Glance references<CR>",      { desc = "Glance at references" } },
        { "gi", ":Glance implementations<CR>", { desc = "Glance at implementations" } },
    },
    opts = {
        list = { position = "left" },
    },
}
