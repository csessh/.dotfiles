return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        options = {
            theme = "powerline_dark",
            globalstatus = false,
            always_divide_middle = true,
            disabled_filetypes = {
                statusline = { "neo-tree" },
                winbar = { "neo-tree" },
            },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { "filename" },
            lualine_x = { "filesize", 'vim.fn.getfperm(vim.fn.expand("%:p"))', "encoding" },
            lualine_y = { "grapple" },
            lualine_z = { "filetype" },
        },
    },
}
