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
        { ";", ":Grapple toggle_tags<cr>", desc = "Toggle tags menu" },
        { "<C-;>", ":Grapple toggle<cr>", desc = "Toggle tag" },
        { "L", ":Grapple cycle_tags next<cr>", desc = "Go to next tag" },
        { "H", ":Grapple cycle_tags prev<cr>", desc = "Go to previous tag" },
    },
}
