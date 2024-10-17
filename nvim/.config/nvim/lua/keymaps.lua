-- This file contains custom keymaps for general purposes.
-- Plugin specific keymaps are defined in the respective plugin file.
-- For example:
--   Telescope keymaps can be found in lua/plugins/telescope.lua.
--
-- Use `:Telescope keymaps` to search for keymaps across NeoVim setup.
vim.g.mapleader = " "

-- Add blank line below/above current line
vim.keymap.set("n", "<leader>j", "o<Esc>", { noremap = true })
vim.keymap.set("n", "<leader>k", "O<Esc>", { noremap = true })

-- Clear search highlights
vim.keymap.set("n", "<leader><Esc>", ":noh<CR>", { noremap = true })

-- <C-w> is one too many key stroke.
-- Remap it to <Tab> for windows operation
vim.keymap.set("n", "<Tab>", "<C-w>", { noremap = true })

-- Paste without losing what's in the "" register
-- Use <leader>p to paste after vi[wWp..]
-- Think "Select and replace" operation -> <leader>p
vim.keymap.set("x", "<leader>p", '"_dP', { noremap = true })

-- Terminal
vim.keymap.set("n", "<C-`>", ":tabnew<CR>:terminal<CR>", { noremap = true })
vim.keymap.set("t", "<C-`>", "<C-\\><C-n>", { noremap = true })

-- Misc
vim.keymap.set({ "n", "v" }, "<leader><leader>x", ":source %<CR>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader><leader>l", ":Lazy<CR>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader><leader>m", ":Mason<CR>", { noremap = true })
