return {
    'nvim-treesitter/nvim-treesitter', 
    build = ':TSUpdate',
    config = function()
        local treesitter = require('nvim-treesitter.configs')
        treesitter.setup({
            ensure_installed = {
                'cpp', 
                'vimdoc', 
                'luadoc', 
                'vim', 
                'lua', 
                'markdown', 
                'c_sharp', 
                'bash', 
                'python', 
                'json', 
                'yaml', 
                'go', 
                'lua', 
                'sql'
            },
            highlight = { enable = true },
            indent = { enable = true } 
        })
    end
}
