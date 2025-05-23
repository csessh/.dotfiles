return {
    "cbochs/grapple.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        icons = true,
        quick_select = "123456789",
        scope = "git_branch",
        style = "relative",
    },
    keys = {
        { "<Up>", ":Grapple toggle_tags<cr>", silent = true, desc = "Toggle tags menu" },
        { "<Down>", ":Grapple toggle<cr>", silent = true, desc = "Toggle tag" },
        { "<Right>", ":Grapple cycle_tags next<cr>", silent = true, desc = "Go to next tag" },
        { "<Left>", ":Grapple cycle_tags prev<cr>", silent = true, desc = "Go to previous tag" },
    },
}
