# bat

A cat clone with syntax highlighting and Git integration.

## Configuration

```bash
cd ~/.dotfiles
stow bat
```

## Settings

- **Theme**: Cyberdream
- **Tabs**: 4 spaces
- **Style**: snip, changes, header-filesize, grid, numbers

## Theme

Custom Cyberdream theme located in `themes/cyberdream.tmTheme`.

To rebuild theme cache after changes:
```bash
bat cache --build
```

To list available themes:
```bash
bat --list-themes
```

## Alias

```bash
cat  # aliased to bat in shell config
```

## Dependencies

Installed via Nix home-manager (see `home-manager/.config/home-manager/packages.nix`).
