local inspect = require "inspect"
---@diagnostic disable: missing-fields
return {
    {
        -- "juansalvatore/git-dashboard-nvim",
        dev = true,
        dir = "~/Documents/nvim-plugins/git-dashboard-nvim/",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        opts = function()
            local function whitespace_only(str)
                return str:match "^%s*$" ~= nil
            end

            local git_dashboard_raw = require("git-dashboard-nvim").setup {
                title = "owner_with_repo_name",
            }
            local git_dashboard = {}

            for _, line in ipairs(git_dashboard_raw) do
                if not whitespace_only(line) then
                    table.insert(git_dashboard, line)
                end
            end

            local git_repo = git_dashboard[1]
            local git_branch = git_dashboard[#git_dashboard]

            print("git_repo: " .. inspect(git_repo))
            print("git_branch: " .. inspect(git_branch))

            return {
                theme = "doom",
                config = {
                    header = git_dashboard_raw,
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
