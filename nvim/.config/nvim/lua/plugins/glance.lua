return {
    "dnlhc/glance.nvim",
    config = function()
        require("glance").setup {}

        vim.keymap.set("n", "gd", ":Glance definitions<CR>")
        vim.keymap.set("n", "gr", ":Glance references<CR>")
        vim.keymap.set("n", "gt", ":Glance type_definitions<CR>")
        vim.keymap.set("n", "gi", ":Glance implementations<CR>")
    end,
}
