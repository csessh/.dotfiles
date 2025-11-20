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
      lualine_y = { "filetype", 'vim.fn.getfperm(vim.fn.expand("%:p"))' },
      lualine_z = {
        function()
          local path = vim.fn.expand "%:p"
          local parts = vim.split(path, "/")
          local len = #parts
          if len <= 3 then
            return vim.fn.fnamemodify(path, ":~")
          else
            return parts[len - 2] .. "/" .. parts[len - 1] .. "/" .. parts[len]
          end
        end,
      },
    },
  },
}
