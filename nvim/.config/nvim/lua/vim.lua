-- Tab settings
vim.cmd "set tabstop=4"
vim.cmd "set softtabstop=4"
vim.cmd "set shiftwidth=4"
vim.cmd "set expandtab"

-- Global editor settings
vim.wo.number = true
vim.wo.relativenumber = true
vim.g.have_nerd_font = true
vim.cmd "filetype plugin indent on"
vim.cmd "set clipboard=unnamedplus"
vim.cmd "set signcolumn=auto"

-- Global key mappings
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>o", "o<Esc>", { noremap = true })
vim.keymap.set("n", "<leader>O", "O<Esc>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<Tab>", "<C-w>", { noremap = true })

-- This command enables kitty reload on buffer write event, specific to kitty.conf file.
-- https://www.reddit.com/r/KittyTerminal/comments/rzpjed/easier_ways_to_reload_kitty/
-- autocmd bufwritepost ~/.config/kitty/kitty.conf :silent !kill -SIGUSR1 $(pgrep kitty)
