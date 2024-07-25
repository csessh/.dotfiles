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
            close_if_last_window = true,
            popup_border_style = "rounded",
            enable_git_status = true,
            enable_diagnostics = true,
            sort_case_insensitive = true,
            filesystem = {
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_by_name = {
                        '.git',
                        '.DS_Store',
                        '.venv',
                        '.ruff_cache',
                        '__pycache__'
                    },
                    hide_by_patter = {
                        '*.egg-info'
                    }
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
                        added     = "", -- or "✚"
                        modified  = "", -- or ""
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
