return {
    {
        "williamboman/mason.nvim",
        config = true,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {},
    },
    {
        "rachartier/tiny-code-action.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
        },
        event = "LspAttach",
        config = function()
            require("tiny-code-action").setup()
            vim.keymap.set({ "n", "v" }, "<leader>ca", function()
                require("tiny-code-action").code_action {}
            end, { noremap = true, silent = true })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require "lspconfig"
            local servers = {
                lspconfig.gopls,
                lspconfig.clangd,
                lspconfig.bashls,
                lspconfig.ruff,
                lspconfig.pyright,
                lspconfig.taplo,
                lspconfig.markdown_oxide,
                lspconfig.dockerls,
                lspconfig.docker_compose_language_service,
            }

            for _, server in ipairs(servers) do
                server.setup { capabilities = capabilities }
            end

            -- Specific configuration for lua_ls LSP
            lspconfig.lua_ls.setup {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        workspace = {
                            checkThirdParty = false,
                            library = { vim.env.VIMRUNTIME },
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        telemetry = { enable = false },
                    },
                },
                capabilities = capabilities,
            }

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf, noremap = true }
                    vim.keymap.set("n", "g?", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "<leader>fm", function()
                        vim.lsp.buf.format { async = false }
                    end, opts)
                end,
            })
        end,
    },
}
