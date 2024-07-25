return {
    'lukas-reineke/indent-blankline.nvim', 
    main = 'ibl', 
    config = function()
        require('ibl').setup({
            indent = {char = '▏'},
            scope = {
                show_start = true,
                show_end = false,
                enabled = true,
                highlight = {'Function', 'Label'},
                char = '\\'
            },
            exclude = {
                filetypes = {'help', 'git', 'markdown', 'snippets', 'gitconfig', 'alpha'},
                buftypes = {'terminal'}
            }
        })
    end
} 
