return {
    "mfussenegger/nvim-lint",
    config = function()
        require("lint").linters_by_ft = {
            python = { "ruff" },
            cpp = { "cpplint" },
            go = { "golangcilint" },
            lua = { "luacheck" },
            bash = { "shellcheck" },
        }
    end,
}
