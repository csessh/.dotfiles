return {
    "bennypowers/splitjoin.nvim",
    lazy = true,
    keys = {
        {
            "gJ",
            function()
                require("splitjoin").join()
            end,
            { noremap = true, desc = "Join the object under cursor" },
        },
        {
            "gj",
            function()
                require("splitjoin").split()
            end,
            { noremap = true, desc = "Split the object under cursor" },
        },
    },
}
