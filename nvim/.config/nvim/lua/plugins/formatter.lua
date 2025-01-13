return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "isort", "ruff_format" },
            go = { "gofmt", "goimports" },
            bash = { "shellcheck" },
            cpp = { "clang_format" },
        },
        format_on_save = {
            timeout_ms = 500,
            lsp_format = "fallback",
        },
    },
}
