---@diagnostic disable: missing-fields
return {
    {
        dir = "~/Documents/nvim-plugins/git-dashboard-nvim",
        dev = true,
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        opts = function()
            local header = require("git-dashboard-nvim").setup {
                title = "owner_with_repo_name",
            }

            return {
                theme = "doom",
                config = {
                    header = header,
                    center = {
                        { action = "", desc = "", icon = "", key = "n" },
                    },
                    footer = function()
                        return {}
                    end,
                },
            }
        end,
    },
}
