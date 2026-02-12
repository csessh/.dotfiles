# git

## Configuration

```bash
cd ~/.dotfiles
stow git
```

## Settings

| Setting | Value |
|---------|-------|
| Editor | nvim |
| Default branch | main |
| Pull strategy | rebase |
| Merge conflict style | diff3 |
| Rebase autostash | enabled |

## Delta (diff pager)

Uses [delta](https://github.com/dandavison/delta) for diffs with:
- Cyberdream theme
- Line numbers
- Navigate mode (`n`/`N` to jump between files)

## Git LFS

Git LFS is configured for large file support.

## Aliases

- `git adog`: `log --all --decorate --oneline --graph`

## Dependencies

Installed via Nix home-manager:
- git
- git-lfs
- delta

See `home-manager/.config/home-manager/packages.nix`.
