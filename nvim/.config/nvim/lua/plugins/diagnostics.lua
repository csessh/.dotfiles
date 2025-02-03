return {
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                python = { "ruff" },
                cpp = { "cpplint" },
                go = { "golangcilint" },
                lua = { "luacheck" },
                bash = { "shellcheck" },
                yaml = { "yamllint" },
                json = { "jsonlint" },
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
