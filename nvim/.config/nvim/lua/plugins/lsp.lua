return {
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
                lspconfig.bashls,
                lspconfig.clangd,
                lspconfig.docker_compose_language_service,
                lspconfig.dockerls,
                lspconfig.markdown_oxide,
                lspconfig.pyright,
                lspconfig.ruff,
                lspconfig.taplo,
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
                    vim.keymap.set(
                        "n",
                        "<leader>rn",
                        vim.lsp.buf.rename,
                        { buffer = ev.buf, noremap = true, desc = "LSP rename variable" }
                    )

                    vim.keymap.set("n", "<leader>fm", function()
                        vim.lsp.buf.format { async = false }
                    end, { buffer = ev.buf, noremap = true, desc = "LSP format current buffer" })
                end,
            })
        end,
    },
}
