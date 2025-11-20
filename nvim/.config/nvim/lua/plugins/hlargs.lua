return {
  "m-demare/hlargs.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    hl_priority = 1000, -- https://github.com/m-demare/hlargs.nvim/issues/81
    color = "#f1ff5e",
    excluded_argnames = {
      declarations = {
        python = { "self", "cls" },
      },
      usages = {
        python = { "self", "cls" },
        lua = { "self" },
      },
    },
  },
}
