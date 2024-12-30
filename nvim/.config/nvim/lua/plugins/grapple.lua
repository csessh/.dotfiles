return {
    "cbochs/grapple.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        scope = "git_branch",
        icons = true,
        quick_select = "123456789",
        style = "relative",
    },
    keys = {
        { "<leader>`", ":Grapple toggle_tags<cr>",     silent = true, desc = "Toggle tags menu" },
        { "<C-t>",     ":Grapple toggle<cr>",          silent = true, desc = "Toggle tag" },
        { "<C-l>",     ":Grapple cycle_tags next<cr>", silent = true, desc = "Go to next tag" },
        { "<C-h>",     ":Grapple cycle_tags prev<cr>", silent = true, desc = "Go to previous tag" },
    },
}
