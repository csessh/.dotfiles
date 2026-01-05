#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REPO_HTTPS="https://github.com/csessh/.dotfiles.git"
DOTFILES_REPO_SSH="git@github.com:csessh/.dotfiles.git"

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Linux)
            if [ -f /etc/fedora-release ]; then
                echo "fedora"
            elif [ -f /etc/os-release ]; then
                . /etc/os-release
                case "$ID" in
                    ubuntu) echo "ubuntu" ;;
                    debian) echo "debian" ;;
                    *) echo "linux" ;;
                esac
            else
                echo "linux"
            fi
            ;;
        Darwin)
            echo "macos"
            ;;
        *)
            error "Unsupported operating system"
            ;;
    esac
}

OS=$(detect_os)
info "Detected OS: $OS"

# Install Nix
install_nix() {
    if command -v nix &> /dev/null; then
        info "Nix is already installed"
        source_nix
        return
    fi

    info "Installing Nix..."

    case "$OS" in
        fedora)
            # Use Fedora's native Nix package (has SELinux policies)
            sudo dnf install -y nix
            sudo systemctl enable --now nix-daemon
            ;;
        *)
            # Use official installer for other distros
            curl -L https://nixos.org/nix/install | sh -s -- --daemon
            ;;
    esac

    source_nix
}

# Source nix environment
source_nix() {
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
}

# Clone dotfiles
clone_dotfiles() {
    if [ -d "$DOTFILES_DIR" ]; then
        info "Dotfiles already cloned at $DOTFILES_DIR"
        return
    fi

    info "Cloning dotfiles via HTTPS..."
    git clone "$DOTFILES_REPO_HTTPS" "$DOTFILES_DIR"

    info "Switching remote to SSH for future pushes..."
    git -C "$DOTFILES_DIR" remote set-url origin "$DOTFILES_REPO_SSH"
}

# Stow packages
stow_package() {
    local package=$1
    info "Stowing $package..."
    cd "$DOTFILES_DIR"
    stow -R "$package" 2>/dev/null || stow "$package"
}

# Install home-manager
install_home_manager() {
    if command -v home-manager &> /dev/null; then
        info "home-manager is already installed"
        return
    fi

    info "Installing home-manager..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
}

# Install system packages based on OS
install_system_packages() {
    info "Installing system packages for $OS..."

    case "$OS" in
        fedora)
            # Add Docker repository
            if ! sudo dnf repolist | grep -q docker-ce; then
                info "Adding Docker repository..."
                sudo dnf -y install dnf-plugins-core
                sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
            fi

            # Install packages
            sudo dnf install -y \
                ca-certificates \
                curl \
                wget \
                openssl \
                docker-ce \
                docker-ce-cli \
                containerd.io \
                docker-buildx-plugin \
                docker-compose-plugin \
                pam-u2f \
                pamu2fcfg \
                firefox

            # Enable and start Docker
            sudo systemctl enable --now docker
            ;;

        ubuntu|debian)
            # Add Docker repository
            if ! apt-cache policy | grep -q docker; then
                info "Adding Docker repository..."
                sudo apt-get update
                sudo apt-get install -y ca-certificates curl gnupg
                sudo install -m 0755 -d /etc/apt/keyrings
                curl -fsSL https://download.docker.com/linux/$OS/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
                sudo chmod a+r /etc/apt/keyrings/docker.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$OS $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            fi

            sudo apt-get update
            sudo apt-get install -y \
                ca-certificates \
                curl \
                wget \
                openssl \
                docker-ce \
                docker-ce-cli \
                containerd.io \
                docker-buildx-plugin \
                docker-compose-plugin \
                libpam-u2f \
                firefox

            # Enable and start Docker
            sudo systemctl enable --now docker
            ;;

        macos)
            # Install Homebrew if not present
            if ! command -v brew &> /dev/null; then
                info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi

            brew install --cask docker
            brew install --cask firefox
            ;;

        *)
            warn "Unknown OS: $OS - skipping system package installation"
            warn "Please install Docker and other system packages manually"
            ;;
    esac
}

# Add user to docker group for rootless docker commands
setup_docker_group() {
    if [ "$OS" = "macos" ]; then
        info "Docker Desktop on macOS handles permissions automatically"
        return
    fi

    if groups "$USER" | grep -q docker; then
        info "User already in docker group"
        return
    fi

    info "Adding $USER to docker group..."
    sudo usermod -aG docker "$USER"
    warn "You'll need to log out and back in for docker group membership to take effect"
}

# Install oh-my-zsh and set up shell config
setup_shell() {
    # Step 1: Install oh-my-zsh if not present
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        info "Installing oh-my-zsh..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        info "oh-my-zsh is already installed"
    fi

    # Step 2: Remove stock zshrc (conflicts with stow)
    if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
        info "Removing stock .zshrc..."
        rm -f "$HOME/.zshrc"
    fi

    # Step 3: Stow shell config
    stow_package "shell"
}

# Install TPM (Tmux Plugin Manager)
install_tpm() {
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        info "TPM is already installed"
        return
    fi

    info "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
}

# Change default shell to zsh
set_default_shell() {
    if [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
        info "Shell is already zsh"
        return
    fi

    info "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
}

# Main
main() {
    info "Starting bootstrap..."

    # Step 1: Clone dotfiles (needed for stow)
    clone_dotfiles

    # Step 2: Install Nix
    install_nix

    # Step 3: Stow nix config to enable flakes
    stow_package "nix"

    # Step 4: Install home-manager
    install_home_manager

    # Step 5: Stow home-manager config
    stow_package "home-manager"

    # Step 6: Apply home-manager configuration (--impure to read $USER/$HOME)
    info "Applying home-manager configuration..."
    home-manager switch --impure

    # Step 7: Install system packages
    install_system_packages

    # Step 8: Add user to docker group
    setup_docker_group

    # Step 9: Set up shell (oh-my-zsh + stow shell config)
    setup_shell

    # Step 10: Install TPM
    install_tpm

    # Step 11: Stow remaining configs
    info "Stowing configuration packages..."
    for pkg in git nvim tmux bat pet fastfetch ghostty ssh Yubico; do
        if [ -d "$DOTFILES_DIR/$pkg" ]; then
            stow_package "$pkg"
        fi
    done

    # Step 12: Set default shell
    set_default_shell

    info "Bootstrap complete!"
    warn "Please log out and back in for all changes to take effect."
}

main "$@"
