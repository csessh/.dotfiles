-- Tab settings
vim.cmd "set tabstop=4"
vim.cmd "set softtabstop=4"
vim.cmd "set shiftwidth=4"
vim.cmd "set expandtab"

-- Global editor settings
vim.wo.number = true
vim.wo.relativenumber = true
vim.g.have_nerd_font = true

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.autoread = true -- sync buffers automatically
vim.opt.swapfile = false -- disable neovim generating a swapfile and showing the error

vim.cmd "filetype plugin indent on"
vim.cmd "set clipboard=unnamedplus"
vim.cmd "set signcolumn=auto"

-- Global key mappings
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>o", "o<Esc>", { noremap = true })
vim.keymap.set("n", "<leader>O", "O<Esc>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set({ "n", "v" }, "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set({ "n", "v" }, "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set({ "n", "v" }, "<C-l>", "<C-w>l", { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader><leader>x", ":source %<CR>", { noremap = true })
