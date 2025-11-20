return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    chunk = {
      enable = true,
      style = "#0fe9ee",
      use_treesitter = true,
    },
    line_num = {
      enable = false,
      style = "#0fe9ee",
      use_treesitter = true,
    },
  },
}
