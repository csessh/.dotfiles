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
vim.diagnostic.config { virtual_text = false }

vim.cmd "filetype plugin indent on"
vim.cmd "set clipboard=unnamedplus"
vim.cmd "set signcolumn=auto"

-- Global key mappings
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>j", "o<Esc>", { noremap = true })
vim.keymap.set("n", "<leader>k", "O<Esc>", { noremap = true })
vim.keymap.set("n", "<leader><Esc>", ":noh<CR>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader><leader>x", ":source %<CR>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader><leader>l", ":Lazy<CR>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader><leader>m", ":Mason<CR>", { noremap = true })
