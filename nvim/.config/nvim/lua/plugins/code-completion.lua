return {
    { "hrsh7th/cmp-nvim-lsp" },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = { "lazy.nvim" },
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

            local files = vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true)
            for _, ft_path in ipairs(files) do
                loadfile(ft_path)()
            end

            vim.keymap.set({ "i", "s" }, "<C-h>", function()
                if ls.jumpable(-1) then
                    ls.jump(-1)
                end
            end, {
                silent = true,
                desc = "Jump to previous placeholder in snippet template",
            })

            vim.keymap.set({ "i", "s" }, "<C-l>", function()
                if ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                end
            end, {
                silent = true,
                desc = "Jump to next placeholder in snippet template",
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()

            local cmp = require "cmp"
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
                    ["<Tab>"] = cmp.mapping.confirm { select = true },
                },
                sources = cmp.config.sources {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "lazydev", group_index = 0 },
                    { name = "buffer" },
                    { name = "path" },
                },
            }
        end,
    },
}
