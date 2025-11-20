return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "ruff_format", "ruff_organize_imports" },
          ts = { "eslint_d" },
          ["_"] = { "trim_whitespace" },
        },
        format_on_save = {
          timeout_ms = 500,
          async = false,
          lsp_format = "fallback",
        },
        notify_on_error = true,
        notify_no_formatters = false,
      }
    end,
  },
  {
    -- Order of installation is important:
    -- Mason -> Conform -> Mason-Conform
    -- https://github.com/zapling/mason-conform.nvim?tab=readme-ov-file#setup
    "zapling/mason-conform.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "eslint_d",
        "ruff",
        "stylua",
      },
    },
  },
}
