return {
    "m-demare/hlargs.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        color = "#f2e422",
        excluded_argnames = {
            declarations = {
                python = { "self", "cls" },
            },
            usages = {
                python = { "self", "cls" },
                lua = { "self" },
            },
        },
    },
}
