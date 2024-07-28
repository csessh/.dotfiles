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

-- Global key mappings
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>o", "o<Esc>", {})
vim.keymap.set("n", "<leader>O", "O<Esc>", {})
vim.keymap.set("n", "<leader><Tab>", "<C-w>", {})
