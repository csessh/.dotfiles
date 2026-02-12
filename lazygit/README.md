# lazygit

Terminal UI for git commands.

## Configuration

```bash
cd ~/.dotfiles
stow lazygit
```

## Settings

- **Theme**: Cyberdream
- **Nerd Fonts**: v3
- **Border**: rounded
- **Branch log**: `git log --all --decorate --oneline --graph --stat`

## Custom Keybindings

| Context | Key | Action |
|---------|-----|--------|
| Stash | `p` | Pop stash |
| Stash | `r` | Rename stash |

## Alias

```bash
lazy  # alias for lazygit
```

## Dependencies

Installed via Nix home-manager (see `home-manager/.config/home-manager/packages.nix`).
