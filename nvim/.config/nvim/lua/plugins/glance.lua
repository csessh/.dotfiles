vim.keymap.set("n", "gd", ":Glance definitions<CR>", { noremap = true })
vim.keymap.set("n", "gr", ":Glance references<CR>", { noremap = true })
vim.keymap.set("n", "gi", ":Glance implementations<CR>", { noremap = true })

return {
    "dnlhc/glance.nvim",
    opts = {
        list = {
            position = "left",
        },
    },
}
