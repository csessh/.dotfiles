return {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
        code = {
            sign = true,
            style = 'normal',
            position = 'right',
            width = 'block',
            min_width = 40,
            left_pad = 4,
            right_pad = 4,
            highlight = 'RenderMarkdownCode',
            highlight_inline = 'RenderMarkdownCodeInline',
        },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
}
