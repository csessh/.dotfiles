return {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
        require("mini.splitjoin").setup {
            mappings = {
                toggle = ",J",
                split = ",s",
                join = ",j",
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
