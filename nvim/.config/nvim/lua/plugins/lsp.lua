return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "lua_ls",
                "bashls",
                "jsonls",
                "markdown_oxide",
                "pyright",
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

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = ev.buf }
                    vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "<leader>rf", vim.lsp.buf.references, opts)
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "<leader>?", vim.lsp.buf.hover, opts)

                    vim.keymap.set("n", "<leader>fm", function()
                        vim.lsp.buf.format { async = true }
                    end, opts)
                end,
            })
        end,
    },
}
