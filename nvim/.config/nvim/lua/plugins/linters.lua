return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        bash = { "shellcheck" },
        cpp = { "cpplint" },
        json = { "jsonlint" },
        python = { "ruff" },
        yaml = { "yamllint" },
      }
    end,
  },
}
