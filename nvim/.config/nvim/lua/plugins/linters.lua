return {
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                bash = { "shellcheck" },
                cpp = { "cpplint" },
                go = { "golangcilint" },
                json = { "jsonlint" },
                lua = { "selene" },
                python = { "ruff" },
                yaml = { "yamllint" },
            }
        end,
    },
}
