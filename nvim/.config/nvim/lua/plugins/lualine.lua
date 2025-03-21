return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        options = {
            theme = "powerline_dark",
            globalstatus = true,
            always_divide_middle = true,
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff" },
            lualine_c = { "diagnostics" },
            lualine_x = { "grapple" },
            lualine_y = { "filetype", 'vim.fn.getfperm(vim.fn.expand("%:p"))', "location" },
            lualine_z = { "filename" },
        },
    },
}
