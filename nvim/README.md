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

Leader key: `<Space>`

### General

| Binding | Action |
|---------|--------|
| `<leader>j` | Insert blank line below |
| `<leader>k` | Insert blank line above |
| `<leader><Esc>` | Clear search highlights |
| `<leader>%` | Source current file |
| `/ (visual)` | Search within selection (forward) |
| `? (visual)` | Search within selection (backward) |
| `<Esc> (terminal)` | Exit terminal insert mode |

### LSP & Code

| Binding | Action |
|---------|--------|
| `<leader>ca` | Code actions |
| `<leader>fm` | Format buffer |
| `<leader>rn` | Rename symbol |
| `gd` | Go to definition (Glance) |
| `gr` | Go to references (Glance) |
| `gi` | Go to implementations (Glance) |

### Telescope

| Binding | Action |
|---------|--------|
| `<leader>ff` | Find files |
| `<leader>gr` | Live grep |
| `<leader>gw` | Grep word under cursor |
| `<leader>bf` | Show buffers |

### File Navigation

| Binding | Action |
|---------|--------|
| `<leader>-` | Toggle Neo-tree |
| `-` | Open Oil file manager |
| `,o` | Toggle Outline |

### Oil (within buffer)

| Binding | Action |
|---------|--------|
| `<CR>` | Select |
| `-` | Go to parent |
| `<C-s>` | Open in vertical split |
| `<C-v>` | Open in horizontal split |
| `<C-t>` | Open in new tab |
| `<C-p>` | Preview |
| `<C-q>` | Close |
| `g.` | Toggle hidden files |
| `gs` | Change sort |
| `gx` | Open external |

### Grapple (bookmarks)

| Binding | Action |
|---------|--------|
| `<Up>` | Toggle tags menu |
| `<Down>` | Toggle tag on file |
| `<Right>` | Cycle to next tag |
| `<Left>` | Cycle to previous tag |

### Git (Gitsigns)

| Binding | Action |
|---------|--------|
| `\p` | Preview hunk |
| `\/` | Show deleted lines inline |
| `\r` | Reset hunk |
| `\?` | Blame current line |
| `]\` | Next hunk |
| `[\` | Previous hunk |

### Diagnostics (Trouble)

| Binding | Action |
|---------|--------|
| `<leader>xX` | Workspace diagnostics |
| `<leader>xx` | Buffer diagnostics |

### Motion

| Binding | Action |
|---------|--------|
| `<leader>l` | Leap (bi-directional) |
| `<leader>L` | Leap across windows |
| `w`, `e`, `b` | CamelCase-aware word motions (Spider) |

### Treesitter Textobjects

**Selection** (visual/operator-pending):

| Binding | Action |
|---------|--------|
| `af` / `if` | Function outer/inner |
| `ac` / `ic` | Class outer/inner |
| `ai` / `ii` | Conditional outer/inner |
| `al` / `il` | Loop outer/inner |

**Movement**:

| Binding | Action |
|---------|--------|
| `]f` / `[f` | Next/prev function start |
| `]c` / `[c` | Next/prev class start |
| `]F` / `[F` | Next/prev function end |
| `]C` / `[C` | Next/prev class end |
| `]i` / `[i` | Next/prev conditional |
| `]l` / `[l` | Next/prev loop |
| `]z` / `[z` | Next/prev fold |

### Completion (nvim-cmp)

| Binding | Action |
|---------|--------|
| `<Tab>` | Confirm completion |
| `<C-b>` | Scroll docs up |
| `<C-f>` | Scroll docs down |

### Snippets (LuaSnip)

| Binding | Action |
|---------|--------|
| `<C-l>` | Expand or jump to next placeholder |
| `<C-h>` | Jump to previous placeholder |

### Mini Operators

| Binding | Action |
|---------|--------|
| `,j` | Split line |
| `,J` | Join lines |
| `,=` | Evaluate |
| `,r` | Replace operator |
| `,s` | Sort |
| `,m` | Exchange |

### Surround (nvim-surround)

| Binding | Action |
|---------|--------|
| `ys{motion}{char}` | Add surround |
| `ds{char}` | Delete surround |
| `cs{old}{new}` | Change surround |

### Window/Pane Navigation

| Binding | Action |
|---------|--------|
| `<C-h/j/k/l>` | Navigate panes (tmux-aware) |
| `<C-\>` | Last active pane |

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
