-- Tab settings
vim.cmd('set tabstop=4')
vim.cmd('set softtabstop=4')
vim.cmd('set shiftwidth=4')
vim.cmd('set expandtab')
vim.cmd('filetype plugin indent on')

vim.wo.number = true
vim.wo.relativenumber = true

-- Global key mappings
vim.g.mapleader = ' '
vim.keymap.set('n', '<Tab>', '<C-w>w', {noremap = true, silent = true})

-- Package manager: Lazy 
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', 
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugins')

