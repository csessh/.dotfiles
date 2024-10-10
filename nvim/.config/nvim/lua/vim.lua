-- This file contains various global vim options

vim.g.have_nerd_font = true
vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.signcolumn = "auto"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sync buffers automatically
-- Disable neovim generating a swapfile and showing the error
vim.opt.autoread = true
vim.opt.swapfile = false

-- Display tabline if there are multiple tabs
vim.opt.showtabline = 1
vim.opt.clipboard = "unnamedplus"

vim.cmd "filetype plugin indent on"
