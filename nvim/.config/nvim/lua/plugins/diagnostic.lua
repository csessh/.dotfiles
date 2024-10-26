vim.diagnostic.config { virtual_text = false }

return {
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "LspAttach",
        opts = {
            hi = { background = "None" },
            options = {
                show_source = true,
                multiple_diag_under_cursor = true,
            },
            severity = {
                vim.diagnostic.severity.ERROR,
                vim.diagnostic.severity.HINT,
                vim.diagnostic.severity.WARN,
            },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvimtools/none-ls-extras.nvim",
            "gbprod/none-ls-shellcheck.nvim",
        },
        config = function()
            local null_ls = require "null-ls"
            null_ls.setup {
                sources = {
                    -- Docker
                    null_ls.builtins.formatting.hadolint,

                    -- Lua
                    null_ls.builtins.formatting.stylua,

                    -- Python
                    null_ls.builtins.formatting.isort,

                    -- CPP
                    null_ls.builtins.formatting.clang_format,
                    require "none-ls.diagnostics.cpplint",

                    -- Markdown
                    null_ls.builtins.formatting.markdownlint,
                    null_ls.builtins.diagnostics.markdownlint,

                    -- Bash
                    require "none-ls-shellcheck.diagnostics",
                    require "none-ls-shellcheck.code_actions",
                },
            }
        end,
    },
}
