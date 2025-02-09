return {
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                bash = { "shellcheck" },
                cpp = { "cpplint" },
                go = { "golangcilint" },
                json = { "jsonlint" },
                lua = { "luacheck" },
                python = { "ruff" },
                yaml = { "yamllint" },
            }
        end,
    },
    {
        "maan2003/lsp_lines.nvim",
        lazy = false,
        config = function()
            require("lsp_lines").setup()
            vim.diagnostic.config { virtual_text = false }
            vim.diagnostic.config { virtual_lines = { only_current_line = true } }
        end,
    },
}
