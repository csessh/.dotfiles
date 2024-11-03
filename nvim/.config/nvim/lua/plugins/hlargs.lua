return {
    "m-demare/hlargs.nvim",
    lazy = true,
    event = "BufEnter",
    opts = {
        color = "#f2e422",
        excluded_argnames = {
            declarations = { "self", "cls" },
            usages = {
                python = { "self", "cls" },
                lua = { "self" },
            },
        },
    },
}
