return {
    { "hrsh7th/cmp-nvim-lsp" },
    { "Bilal2453/luvit-meta", lazy = true },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                {
                    path = "luvit-meta/library",
                    words = { "vim%.uv" },
                },
                "lazy.nvim",
            },
        },
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        build = "make install_jsregexp",
        config = function()
            local ls = require "luasnip"

            ls.setup {
                update_events = { "TextChanged", "TextChangedI" },
            }

            vim.keymap.set({ "i", "s" }, "<C-l>", function()
                ls.jump(1)
            end, { silent = true, noremap = true })

            vim.keymap.set({ "i", "s" }, "<C-h>", function()
                ls.jump(-1)
            end, { silent = true, noremap = true })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local cmp = require "cmp"
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup {
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert {
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm { select = true },
                },
                sources = cmp.config.sources {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                },
            }
        end,
    },
}
