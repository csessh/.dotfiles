#!/usr/bin/env bash
# Runs inside a test VM as the target user. Prints PASS/FAIL per check, exits 1 on any FAIL.
set -uo pipefail

if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
    set +u
    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    set -u
fi
export PATH="$HOME/.nix-profile/bin:$PATH"

. /etc/os-release
OS_ID=$ID
failure_count=0

check() {
    local name=$1 reason
    if reason=$("$name" 2>&1); then
        echo "PASS $name"
    else
        echo "FAIL $name: ${reason:-failed}" | head -5
        failure_count=$((failure_count + 1))
    fi
}

links_into_dotfiles() {
    local path resolved
    for path in "$@"; do
        resolved=$(readlink -f "$path") || { echo "$path missing"; return 1; }
        case "$resolved" in
            "$HOME/.dotfiles/"*) ;;
            *) echo "$path -> $resolved"; return 1 ;;
        esac
    done
}

# First interactive shell installs zinit plugins; judge the second one.
# Without a tty zsh warns "can't change option: zle"; that line is not a config error.
zsh_starts() {
    zsh -i -c 'exit 0' >/dev/null 2>&1 </dev/null || true
    local stderr_output
    stderr_output=$(zsh -i -c 'exit 0' 2>&1 >/dev/null </dev/null) || { echo "exit $?: $stderr_output"; return 1; }
    stderr_output=$(grep -v "can't change option: zle" <<<"$stderr_output")
    [ -z "$stderr_output" ] || { echo "$stderr_output"; return 1; }
}

stow_links() {
    links_into_dotfiles ~/.zshrc ~/.tmux.conf ~/.gitconfig ~/.config/nvim/init.lua ~/.config/bat/config
}

# Config errors only: headless +qa interrupts async parser/Mason installs, whose noise is not a config fault.
nvim_starts() {
    local output
    output=$(nvim --headless "+Lazy! restore" +qa 2>&1) || { echo "exit $?: $output"; return 1; }
    if grep -qE "Failed to load|Error detected while processing|Error in .*init\.lua|E5113" <<<"$output"; then
        grep -m3 -E -A2 "Failed to load|Error detected while processing|Error in .*init\.lua|E5113" <<<"$output"
        return 1
    fi
}

docker_works() {
    docker info >/dev/null
}

hm_generation() {
    [ -n "$(home-manager generations 2>/dev/null)" ] || { echo "no home-manager generations"; return 1; }
}

nvim_profile_server() {
    local profile
    profile=$(zsh -i -c 'printf "\nNVIM_PROFILE=%s" "$NVIM_PROFILE"' 2>/dev/null </dev/null | sed -n 's/^NVIM_PROFILE=//p')
    [ "$profile" = "server" ] || { echo "NVIM_PROFILE='$profile'"; return 1; }
}

no_mason() {
    [ ! -e ~/.local/share/nvim/mason ] || { echo "mason data dir exists"; return 1; }
}

# lazy.nvim rewrites its lockfile without disabled plugins; servers must not dirty the repo's copy.
repo_lock_clean() {
    git -C "$HOME/.dotfiles" diff --quiet -- nvim/.config/nvim/lazy-lock.json ||
        { git -C "$HOME/.dotfiles" diff --stat -- nvim/.config/nvim/lazy-lock.json; return 1; }
}

no_dev_plugins() {
    local plugin found=""
    for plugin in mason.nvim nvim-cmp conform.nvim nvim-lint LuaSnip outline.nvim eagle.nvim \
        glance.nvim symbol-usage.nvim trouble.nvim tiny-code-action.nvim; do
        [ -e ~/.local/share/nvim/lazy/"$plugin" ] && found="$found $plugin"
    done
    [ -z "$found" ] || { echo "installed:$found"; return 1; }
}

hm_activation() {
    local result
    result=$(systemctl show -p Result "home-manager-$USER.service")
    [ "$result" = "Result=success" ] || { echo "$result"; return 1; }
}

MASON_PACKAGES="bash-language-server clangd docker-compose-language-service dockerfile-language-server
lua-language-server markdown-oxide pyright ruff taplo typescript-language-server
cpplint eslint_d jsonlint shellcheck yamllint"

# Mason installs on startup, but a headless +qa earlier (nvim_starts) aborts those installs and
# mason-nvim-lint may not re-queue them; queue whatever is missing and not already installing.
# Then every Mason binary must start: prebuilt ones need nix-ld on NixOS.
mason_binaries() {
    local expected wait_lua binary output exit_code broken=""
    expected=$(printf '"%s",' $MASON_PACKAGES)
    wait_lua="local ok, registry = pcall(require, 'mason-registry')
if not ok then vim.cmd('cquit 2') end
local expected = { ${expected} }
local done = vim.wait(1200000, function()
  for _, name in ipairs(expected) do
    local ok, package = pcall(registry.get_package, name)
    if not ok then return false end
    if not package:is_installed() and not package:is_installing() then package:install() end
    if package:is_installing() or not package:is_installed() then return false end
  end
  return true
end, 5000)
if not done then
  local missing = {}
  for _, name in ipairs(expected) do
    local found, package = pcall(registry.get_package, name)
    if not found or not package:is_installed() then table.insert(missing, name) end
  end
  io.stdout:write('MASON_MISSING=' .. table.concat(missing, ' ') .. '\\n')
  vim.cmd('cquit 1')
end"
    local started=$SECONDS wait_output
    wait_output=$(nvim --headless -c "lua $wait_lua" -c qa 2>&1) || {
        echo "Mason not ready after $((SECONDS - started))s (exit $?): $(grep -o 'MASON_MISSING=.*' <<<"$wait_output")"
        tail -3 "$HOME/.local/state/nvim/mason.log" 2>/dev/null
        return 1
    }
    compgen -G "$HOME/.local/share/nvim/mason/bin/*" >/dev/null || { echo "no Mason binaries"; return 1; }
    for binary in "$HOME"/.local/share/nvim/mason/bin/*; do
        output=$(timeout 10 "$binary" --version </dev/null 2>&1)
        exit_code=$?
        if [ "$exit_code" -eq 126 ] || [ "$exit_code" -eq 127 ] ||
            grep -qE "Could not start dynamically linked executable|No such file or directory" <<<"$output"; then
            broken="$broken $(basename "$binary")($exit_code)"
        fi
    done
    [ -z "$broken" ] || { echo "cannot start:$broken"; return 1; }
}

pcscd_active() {
    systemctl is-active --quiet pcscd.socket || systemctl is-active --quiet pcscd.service ||
        { echo "pcscd inactive"; return 1; }
}

ssh_agent() {
    systemctl --user is-active --quiet ssh-agent || { echo "ssh-agent user service inactive"; return 1; }
    local socket
    socket=$(zsh -i -c 'printf "\nSSH_AUTH_SOCK=%s" "$SSH_AUTH_SOCK"' 2>/dev/null </dev/null | sed -n 's/^SSH_AUTH_SOCK=//p')
    [ -n "$socket" ] || { echo "SSH_AUTH_SOCK empty in zsh"; return 1; }
}

stow_links_workstation() {
    links_into_dotfiles ~/.config/ghostty/config ~/.ssh/config \
        ~/.claude/CLAUDE.md ~/.claude/RTK.md ~/.config/ccstatusline/settings.json
}

# Stow folds a missing target dir into a symlink to the repo; for these, secrets would land in the repo.
private_dirs_real() {
    local dir
    for dir in "$HOME/.claude" "$HOME/.ssh"; do
        [ -d "$dir" ] && [ ! -L "$dir" ] || { echo "$dir is a symlink or missing"; return 1; }
    done
}

# The workstation must not also carry the server home-manager profile.
no_server_profile() {
    local profile
    profile=$(zsh -i -c 'printf "\nNVIM_PROFILE=%s" "$NVIM_PROFILE"' 2>/dev/null </dev/null | sed -n 's/^NVIM_PROFILE=//p')
    [ -z "$profile" ] || { echo "NVIM_PROFILE='$profile'"; return 1; }
}

apps_on_path() {
    local app missing=""
    for app in ghostty obsidian google-chrome-stable postman dbeaver localsend_app yubioath-flutter claude rtk; do
        command -v "$app" >/dev/null || missing="$missing $app"
    done
    [ -z "$missing" ] || { echo "missing:$missing"; return 1; }
}

ghostty_version() {
    ghostty --version >/dev/null
}

ibus_bamboo() {
    [ -e /run/current-system/sw/share/ibus/component/bamboo.xml ] || { echo "bamboo.xml missing"; return 1; }
}

fingerprint_pam() {
    systemctl cat fprintd.service >/dev/null 2>&1 || { echo "no fprintd.service"; return 1; }
    grep -q pam_fprintd.so /etc/pam.d/sudo || { echo "sudo PAM lacks pam_fprintd"; return 1; }
    ! grep -rq pam_u2f /etc/pam.d || { echo "pam_u2f still configured"; return 1; }
}

check zsh_starts
check stow_links
check nvim_starts
check docker_works

case "$OS_ID" in
    ubuntu|fedora)
        check hm_generation
        check nvim_profile_server
        check no_mason
        check no_dev_plugins
        check repo_lock_clean
        ;;
    nixos)
        check hm_activation
        check no_server_profile
        check private_dirs_real
        check stow_links_workstation
        check apps_on_path
        check ghostty_version
        check ibus_bamboo
        check pcscd_active
        check ssh_agent
        check fingerprint_pam
        check mason_binaries
        ;;
    *)
        echo "FAIL os: unsupported ID=$OS_ID"
        failure_count=$((failure_count + 1))
        ;;
esac

echo "$failure_count failure(s)"
[ "$failure_count" -eq 0 ]
