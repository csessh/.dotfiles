require "options"
require "keymaps"
require "autocmds"

-- Package manager: Lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)
-- Servers skip LSP/completion/format/lint plugins (lua/plugins/dev)
local is_server = vim.env.NVIM_PROFILE == "server"
require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.dev", enabled = not is_server },
  },
  change_detection = {
    notify = false,
  },
})
