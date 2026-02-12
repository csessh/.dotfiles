# nvim

Neovim configuration using Lazy.nvim plugin manager.

## Configuration

```bash
cd ~/.dotfiles
stow nvim
```

## Structure

```
nvim/.config/nvim/
├── init.lua           # Entry point, loads Lazy.nvim
├── stylua.toml        # Lua formatter config
└── lua/
    ├── options.lua    # Vim options
    ├── keymaps.lua    # Key mappings
    ├── plugins/       # Plugin configurations
    └── snippets/      # Custom snippets
```

## Theme

Cyberdream (`plugins/scheme.lua`)

## LSP Servers

Configured in `plugins/lsp.lua`:
- bashls
- clangd
- docker_compose_language_service
- dockerls
- lua_ls (with Love2D support)
- markdown_oxide
- pyright
- ruff
- taplo
- ts_ls

Install via Mason:
```vim
:Mason
```

## Formatters

Configured in `plugins/conform.lua` with format-on-save (500ms timeout):
- **Lua**: stylua
- **Python**: ruff_format, ruff_organize_imports
- **TypeScript**: eslint_d

## Linters

Configured in `plugins/linters.lua`:
- **Bash**: shellcheck
- **C++**: cpplint
- **JSON**: jsonlint
- **Python**: ruff
- **YAML**: yamllint

## Key Bindings

| Binding | Action |
|---------|--------|
| `<leader>ca` | Code actions |
| `<leader>fm` | Format |
| `<leader>rn` | Rename symbol |

## Notable Plugins

- **telescope.nvim**: Fuzzy finder
- **neo-tree.nvim**: File explorer
- **oil.nvim**: File manager
- **gitsigns.nvim**: Git integration
- **treesitter**: Syntax highlighting
- **cmp**: Autocompletion
- **leap.nvim**: Motion
- **grapple.nvim**: File bookmarks
- **tmux-nvim-navigation**: Seamless tmux/nvim pane navigation

## Dependencies

Installed via Nix home-manager:
- neovim (0.11+ required)
- fzf
- ripgrep
- fd
- xclip (desktop only)

See `home-manager/.config/home-manager/packages.nix`.
