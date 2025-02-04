return {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
        require("mini.splitjoin").setup {
            mappings = {
                join = ",J",
                split = ",j",
            },
        }

        require("mini.operators").setup {
            evaluate = { prefix = ",=" },
            replace = {
                prefix = ",r",
                reindent_linewise = true,
            },
            sort = { prefix = ",s" },
        }
    end,
}
