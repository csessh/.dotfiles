return {
  {
    "richardbizik/nvim-toc",
    ft = "markdown",
    opts = {
      toc_header = "Table of Contents",
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = "markdown",
    opts = {
      code = {
        sign = true,
        style = "full",
        position = "left",
        left_pad = 4,
        right_pad = 4,
        highlight = "RenderMarkdownCode",
        highlight_inline = "RenderMarkdownCodeInline",
      },
    },
  },
}
