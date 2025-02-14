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
        { "<M-k>", ":Grapple toggle_tags<cr>", silent = true, desc = "Toggle tags menu" },
        { "<M-j>", ":Grapple toggle<cr>", silent = true, desc = "Toggle tag" },
        { "<M-l>", ":Grapple cycle_tags next<cr>", silent = true, desc = "Go to next tag" },
        { "<M-h>", ":Grapple cycle_tags prev<cr>", silent = true, desc = "Go to previous tag" },
    },
}
