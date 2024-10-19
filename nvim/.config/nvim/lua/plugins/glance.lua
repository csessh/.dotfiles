vim.keymap.set("n", "gd", ":Glance definitions<CR>", { desc = "Glance at definition" })
vim.keymap.set("n", "gr", ":Glance references<CR>", { desc = "Glance at references" })
vim.keymap.set("n", "gi", ":Glance implementations<CR>", { desc = "Glance at implementations" })

return {
    "dnlhc/glance.nvim",
    opts = {
        list = { position = "left" },
    },
}
