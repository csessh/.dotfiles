return {
    "m-demare/hlargs.nvim",
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
