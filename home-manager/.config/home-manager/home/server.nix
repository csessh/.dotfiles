{ lib, ... }:

{
  # nvim skips its LSP plugins on servers (see nvim/.config/nvim/init.lua). A file, not a session
  # variable: nvim started outside zsh (`ssh host nvim`, git from bash) never sources hm-session-vars.
  xdg.configFile."nvim-profile".text = "server\n";

  # The old bootstrap wrote host-type=desktop on desktops; this server-only profile would strip their
  # GUI tooling. Runs at switch time on the target, before anything is written.
  home.activation.refuseDesktopHost = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    if grep -qx desktop "$HOME/.config/host-type" 2>/dev/null; then
      echo "~/.config/host-type says desktop, but this flake's standalone configs are server-only now" >&2
      echo "(desktops run NixOS: nixosConfigurations.fw13). Delete ~/.config/host-type to apply it anyway;" >&2
      echo "on the old Fedora desktop also run 'stow -D ssh' (its ssh-agent.service is gone)." >&2
      exit 1
    fi
  '';
}
