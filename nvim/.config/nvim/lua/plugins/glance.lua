return {
    "dnlhc/glance.nvim",
    keys = {
        { "<leader>gd", ":Glance definitions<CR>", desc = "Glance at definition", silent = true },
        { "<leader>gr", ":Glance references<CR>", desc = "Glance at references", silent = true },
        { "<leader>gi", ":Glance implementations<CR>", desc = "Glance at implementations", silent = true },
    },
    opts = {
        list = { position = "left" },
    },
}
