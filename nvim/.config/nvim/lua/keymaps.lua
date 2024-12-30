-- This file contains custom keymaps for general purposes.
-- Plugin specific keymaps are defined in the respective plugin file.
-- For example:
--   Telescope keymaps can be found in lua/plugins/telescope.lua.
--
-- Use `:Telescope keymaps` to search for keymaps across NeoVim setup.
vim.g.mapleader = " "

-- Editor shortcuts
vim.keymap.set("n", "<leader>j", "o<Esc>", { desc = "Add a blank line below current line. Stay in Normal mode" })
vim.keymap.set("n", "<leader>k", "O<Esc>", { desc = "Add a blank line above current line. Stay in Normal mode" })
vim.keymap.set("n", "<leader><Esc>", ":noh<CR>", { desc = "Clear search highlights" })

-- Use <leader>p to paste after vi[wWp..]
-- Think "Select and replace" operation -> <leader>p
vim.keymap.set("x", "<leader>p", '"_dP', { desc = 'Paste, while in visual mode, without losing "" register value' })

-- Search within visually selected texts
vim.keymap.set("x", "/", "<Esc>/\\%V", { noremap = true, desc = "Search forward within visually selected texts" })
vim.keymap.set("x", "?", "<Esc>?\\%V", { noremap = true, desc = "Search backward within visually selected texts" })

-- Terminal section
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit Insert mode and return to Terminal mode" })

-- Package managers
vim.keymap.set("n", "<leader>X", ":source %<CR>", { desc = "Source current file" })
vim.keymap.set("n", "<leader>L", ":Lazy<CR>", { desc = "Open LazyVim" })
vim.keymap.set("n", "<leader>M", ":Mason<CR>", { desc = "Open Mason" })

-- Disable keymaps
vim.keymap.set("n", "Q", "<nop>", { desc = "Disabled" })
