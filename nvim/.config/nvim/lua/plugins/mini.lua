return {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
        require("mini.splitjoin").setup {
            mappings = {
                toggle = "gS",
                split = "gs",
                join = "gj",
            },
        }
    end,
}
