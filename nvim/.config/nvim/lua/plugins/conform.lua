return {
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("conform").setup {
                formatters_by_ft = {
                    sh = { "beautysh" },
                    cpp = { "clang-format" },
                    go = { "goimports", "gofumpt" },
                    lua = { "stylua" },
                    python = { "isort", "ruff_format" },
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
                "beautysh",
                "clang-format",
                "gofumpt",
                "goimports",
                "isort",
                "ruff_format",
                "stylua",
            },
        },
    },
}
