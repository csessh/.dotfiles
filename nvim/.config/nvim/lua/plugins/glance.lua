return {
  "dnlhc/glance.nvim",
  event = "LspAttach",
  keys = {
    { "gd", "<CMD>Glance definitions<CR>", desc = "Glance at definition", silent = true },
    { "gr", "<CMD>Glance references<CR>", desc = "Glance at references", silent = true },
    { "gi", "<CMD>Glance implementations<CR>", desc = "Glance at implementations", silent = true },
  },
  config = function()
    require("glance").setup {
      list = { position = "left" },
    }
  end,
}
