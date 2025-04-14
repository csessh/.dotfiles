return {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = {
        { "juansalvatore/git-dashboard-nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    opts = function()
        local git_dashboard = require("git-dashboard-nvim").setup {
            title = "owner_with_repo_name",
        }

        local opts = {
            theme = "doom",
            config = {
                header = git_dashboard,
                center = {
                    { action = "", desc = "", icon = "", key = "n" },
                },
                footer = function()
                    return {}
                end,
            },
        }
        return opts
    end,
}
