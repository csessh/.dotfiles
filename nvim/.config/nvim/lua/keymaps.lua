-- This file contains custom keymaps for general purposes.
-- Plugin specific keymaps are defined in the respective plugin file.
-- For example:
--   Telescope keymaps can be found in lua/plugins/telescope.lua.
--
-- Use :Telescope keymaps to search for keymaps across NeoVim setup.

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>j", "o<Esc>", { noremap = true })
vim.keymap.set("n", "<leader>k", "O<Esc>", { noremap = true })
vim.keymap.set("n", "<leader><Esc>", ":noh<CR>", { noremap = true })
vim.keymap.set("n", "<Tab>", "<C-w>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader><leader>x", ":source %<CR>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader><leader>l", ":Lazy<CR>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader><leader>m", ":Mason<CR>", { noremap = true })
