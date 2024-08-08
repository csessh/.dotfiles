return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
        "gbprod/none-ls-shellcheck.nvim",
    },
    config = function()
        local null_ls = require "null-ls"
        null_ls.setup {
            sources = {
                -- Lua
                null_ls.builtins.formatting.stylua,

                -- Python
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort,
                null_ls.builtins.diagnostics.mypy,

                -- Bash
                require "none-ls-shellcheck.diagnostics",
                require "none-ls-shellcheck.code_actions",

                -- CPP
                null_ls.builtins.formatting.clang_format,
                null_ls.builtins.diagnostics.cpplint,
            },
        }
    end,
}
