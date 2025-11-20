return {
    {
        "stevearc/conform.nvim",
        enabled = false,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvim.config.nvim.lua.plugins.archived.conform").setup {
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "isort", "ruff_format" },
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
        enabled = false,
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                "isort",
                "ruff_format",
                "stylua",
                "eslint_d",
            },
        },
    },
}
