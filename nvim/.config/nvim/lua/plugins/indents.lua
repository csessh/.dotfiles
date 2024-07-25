return {
    'lukas-reineke/indent-blankline.nvim', 
    main = 'ibl', 
    config = function()
        require('ibl').setup({
            indent = {char = '▏'},
            scope = {char = ':'},
            exclude = {
                filetypes = {'help', 'git', 'checkhealth', 'markdown', 'snippets', 'gitconfig'},
                buftypes = {'terminal', 'nofile', 'prompt', 'quickfix'}
            }
        })
    end
} 
