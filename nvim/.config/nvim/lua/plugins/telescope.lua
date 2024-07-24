return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8', 
    dependencies = {
        'nvim-lua/plenary.nvim'
    },
    config = function()
        local telescope = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
        vim.keymap.set('n', '<leader>lg', telescope.live_grep, {})
        vim.keymap.set('n', '<leader>gs', telescope.grep_string, {})

        require('telescope').setup({
            defaults = {
            },
            pickers = {
                find_files = {
                    theme = "dropdown"
                },
                live_grep =  {
                    theme = "dropdown"
                },
                grep_string = {
                    theme = "dropdown"
                },
            },
            extensions = {
            }
        })
    end
}
