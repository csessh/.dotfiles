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
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
            lspconfig.bashls.setup({})
            lspconfig.jsonls.setup({})
            lspconfig.markdown_oxide.setup({})
            lspconfig.pyright.setup({})
            lspconfig.taplo.setup({})
            lspconfig.yamlls.setup({})

            -- Global mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            vim.keymap.set("n", "[", vim.diagnostic.goto_prev)
            vim.keymap.set("n", "]", vim.diagnostic.goto_next)

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
                    vim.keymap.set("n", "?", vim.lsp.buf.hover, opts)

                    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
                    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
                    vim.keymap.set("n", "<leader>wl", function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts)

                    vim.keymap.set("n", "<leader>fm", function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)
                end,
            })
        end,
    },
}
