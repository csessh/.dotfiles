# fastfetch

System information tool. Inspired by neofetch but faster.

## Configuration

```bash
cd ~/.dotfiles
stow fastfetch
```

## Display

Custom layout showing:
- User and hostname
- Hardware: machine, monitor, board, BIOS, boot manager
- System: uptime, terminal, terminal font, shell
- Performance: CPU, GPU, Vulkan
- Storage: SSD, secondary storage, memory, swap
- Software: distro, DE, WM, login manager, kernel, packages
- Appearance: theme, icons, cursor, font
- Connectivity: WiFi, camera, sound, media
- Color palette

## Dependencies

Installed via Nix home-manager (see `home-manager/.config/home-manager/packages.nix`).
