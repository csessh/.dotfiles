-- Tab settings
vim.cmd('set tabstop=4')
vim.cmd('set softtabstop=4')
vim.cmd('set shiftwidth=4')
vim.cmd('set expandtab')

-- Global editor settings
vim.wo.number = true
vim.wo.relativenumber = true
vim.cmd('filetype plugin indent on')

-- Global key mappings
vim.g.mapleader = ' '
vim.keymap.set('n', '<Tab>', '<C-w>w', {noremap = true, silent = true})

