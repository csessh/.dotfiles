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
-- Servers skip LSP/completion/format/lint plugins (lua/plugins/dev); the server home-manager config writes this file
local profile_path = vim.env.HOME .. "/.config/nvim-profile"
local is_server = vim.fn.filereadable(profile_path) == 1 and vim.fn.readfile(profile_path, "", 1)[1] == "server"
local lazy_opts = {
  change_detection = {
    notify = false,
  },
}

-- lazy.nvim rewrites its lockfile without disabled plugins; keep the server's copy out of the repo,
-- seeded from (and refreshed by) the repo's pins
if is_server then
  local repo_lockfile = vim.fn.stdpath "config" .. "/lazy-lock.json"
  local server_lockfile = vim.fn.stdpath "data" .. "/lazy-lock.json"
  local repo_stat = vim.uv.fs_stat(repo_lockfile)
  local server_stat = vim.uv.fs_stat(server_lockfile)
  if repo_stat and (not server_stat or repo_stat.mtime.sec > server_stat.mtime.sec) then
    vim.fn.mkdir(vim.fn.stdpath "data", "p")
    vim.uv.fs_copyfile(repo_lockfile, server_lockfile)
  end
  lazy_opts.lockfile = server_lockfile
end

require("lazy").setup({
  { import = "plugins" },
  { import = "plugins.dev", enabled = not is_server },
}, lazy_opts)
