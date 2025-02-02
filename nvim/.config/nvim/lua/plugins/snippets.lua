return {
    "L3MON4D3/LuaSnip",
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        "hrsh7th/cmp-path",
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
}
