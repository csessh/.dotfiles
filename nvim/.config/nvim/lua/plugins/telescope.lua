return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8', 
    dependencies = {
        'nvim-lua/plenary.nvim'
    },
    config = function()
        local telescope = require('telescope.builtin')
        vim.keymap.set('n', '<leader>lg', telescope.live_grep, {})
        vim.keymap.set('n', '<leader>gs', telescope.grep_string, {})

        require('telescope').setup({
            pickers = {
                live_grep =  {
                    theme = 'dropdown'
                },
                grep_string = {
                    theme = 'dropdown'
                }
            },
            extensions = {
                frecency = {
                    default_workspace = 'CWD',
                    path_displays = {'shorten'},
                    show_scores = true
                }
            }
        })
    end
}
