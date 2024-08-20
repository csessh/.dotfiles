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

## Notable dependencies

There are a number of important integrations worth mentioning: 

* [fzf](https://github.com/junegunn/fzf)
* [ripgrep](https://github.com/BurntSushi/ripgrep)
* [fd](https://github.com/sharkdp/fd) 
* [xclip](https://github.com/astrand/xclip) or any other compatible clipboard manager

## Keybindings 

TODO: Update this section
