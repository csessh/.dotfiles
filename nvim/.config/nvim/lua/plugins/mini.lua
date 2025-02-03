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

        require("mini.operators").setup {
            evaluate = { prefix = ",=" },
            replace = {
                replace = ",r",
                reindent_linewise = true,
            },
            sort = { prefix = ",s" },
        }
    end,
}
