vim.keymap.set('n', '<leader>t', ':Neotree toggle<CR>', {})

return {
    'nvim-neo-tree/neo-tree.nvim', 
    branch = 'v3.x', 
    dependencies = {        
        "nvim-lua/plenary.nvim",
        'nvim-tree/nvim-web-devicons', 
        'MunifTanjim/nui.nvim'
    },
    config = function()
        require('neo-tree').setup({
            close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
            popup_border_style = "rounded",
            enable_git_status = true,
            enable_diagnostics = true,
            sort_case_insensitive = true, -- used when sorting files and directories in the tree
            filesystem = {
                filtered_items = {
                    visible = true, -- when true, they will just be displayed differently than normal items
                    hide_dotfiles = true,
                    hide_gitignored = false
                }
            },
            default_component_configs = {
                name = {
                    trailing_slash = false,
                    use_git_status_colors = true,
                    highlight = "NeoTreeFileName"
                },
                git_status = {
                    symbols = {
                        added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                        modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
                        deleted   = "✖",-- this can only be used in the git_status source
                        renamed   = "󰁕",-- this can only be used in the git_status source
                        untracked = "",
                        ignored   = "",
                        unstaged  = "󰄱",
                        staged    = "",
                        conflict  = ""
                    }
                }
            }
        })
    end
}
