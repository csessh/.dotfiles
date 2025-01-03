---@diagnostic disable: missing-fields
return {
    {
        -- "juansalvatore/git-dashboard-nvim",
        dir = "~/Documents/nvim-plugins/git-dashboard-nvim/",
        dev = true,
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        opts = function()
            local header = require("git-dashboard-nvim").setup {
                title = "owner_with_repo_name",
                days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" },
            }

            return {
                theme = "doom",
                config = {
                    header = header,
                    center = {
                        {
                            action = "",
                            desc = "",
                            icon = "",
                            key = "n",
                        },
                    },
                    footer = {},
                },
            }
        end,
    },
}
