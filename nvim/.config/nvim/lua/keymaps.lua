-- This file contains custom keymaps for general purposes.
-- Plugin specific keymaps are defined in the respective plugin file.
-- For example:
--   Telescope keymaps can be found in lua/plugins/telescope.lua.
--
-- Use `:Telescope keymaps` to search for keymaps across NeoVim setup.
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>j", "o<Esc>", { desc = "Add a blank line below current line. Stay in Normal mode" })
vim.keymap.set("n", "<leader>k", "O<Esc>", { desc = "Add a blank line above current line. Stay in Normal mode" })
vim.keymap.set("n", "<leader><Esc>", ":noh<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<Tab>", "<C-w>", { noremap = true, desc = "Shorthand for <C-w>" })

-- Use <leader>p to paste after vi[wWp..]
-- Think "Select and replace" operation -> <leader>p
vim.keymap.set("x", "<leader>p", '"_dP', { desc = 'Paste without losing "" register value' })
vim.keymap.set("x", "/", "<Esc>/\\%V", { noremap = true, desc = "Search forward within visually selected texts" })
vim.keymap.set("x", "?", "<Esc>?\\%V", { noremap = true, desc = "Search backward within visually selected texts" })
vim.keymap.set("t", "<C-`>", "<C-\\><C-n>", { desc = "Exit Insert mode and return to Terminal mode" })
vim.keymap.set("n", "<C-`>", ":tabnew<CR>:terminal<CR>", { desc = "Open Terminal in new tab" })

vim.keymap.set("n", "<leader><leader>x", ":source %<CR>", { desc = "Source current file" })
vim.keymap.set("n", "<leader><leader>l", ":Lazy<CR>", { desc = "Open LazyVim" })
vim.keymap.set("n", "<leader><leader>m", ":Mason<CR>", { desc = "Open Mason" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Disabled" })
vim.keymap.set("n", "<Tab><Tab>", "<nop>", { desc = "Disabled" })
