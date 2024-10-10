return {
    {
        "williamboman/mason.nvim",
        opts = {},
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "ast_grep",
                "gopls",
                "pyright",
                "lua_ls",
                "bashls",
                "jsonls",
                "markdown_oxide",
                "taplo",
                "yamlls",
                "clangd",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require "lspconfig"
            local servers = {
                lspconfig.ast_grep,
                lspconfig.gopls,
                lspconfig.lua_ls,
                lspconfig.clangd,
                lspconfig.bashls,
                lspconfig.jsonls,
                lspconfig.pyright,
                lspconfig.taplo,
                lspconfig.yamlls,
                lspconfig.markdown_oxide,
            }

            for _, server in ipairs(servers) do
                server.setup { capabilities = capabilities }
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

                    local opts = { buffer = ev.buf, noremap = true }
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "g?", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                    vim.keymap.set("n", "<leader>fm", function()
                        vim.lsp.buf.format { async = false }
                        vim.cmd "write"
                    end, opts)
                end,
            })
        end,
    },
}
