return {
    "stevearc/conform.nvim",
    config = function()
        require("mason-conform").setup {
            formatter_by_ft = {
                sh = { "beautysh" },
                cpp = { "clang-format" },
                go = { "goimports", "gofmt" },
                lua = { "stylua" },
                python = { "isort", "ruff" },
            },

            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            }
        }
    end,
}
