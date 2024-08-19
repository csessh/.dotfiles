# Neovim 

## dotfiles 

```bash
cd ~/.dotfiles
stow nvim
```

It's just that easy.

Additionally, in order for nvim-treesitter to properly enable `auto_install` option:

```bash
npm install tree-sitter-cli 
```

## LSPs and auto-completion

See [code-completion.lua](./.config/nvim/lua/plugins/code-completion.lua) for a complete list of required LSPs. 

Find and install necessary LSPs via Mason:

```bash 
:Mason
```

## Linters and Formatters 

See [nonels.lua](./.config/nvim/lua/plugins/nonels.lua) for a complete list of required linters and formatters. 

Find and install necessary linters and formatters via Mason: 

```vim
:Mason
```

## Keybindings 

TODO: Update this section
