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
            lualine_c = { "grapple" },
            lualine_x = { 'vim.fn.getfperm(vim.fn.expand("%:p"))', "filesize", "encoding" },
            lualine_y = { "filetype" },
            lualine_z = { "filename" },
        },
    },
}
