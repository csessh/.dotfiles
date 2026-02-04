#!/usr/bin/env bash
set -euo pipefail

# Colors for output (matching bootstrap.sh)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

YUBICO_DIR="$HOME/.config/Yubico"
U2F_KEYS="$YUBICO_DIR/u2f_keys"

# Track which files were configured for summary
CONFIGURED_FILES=()
BACKUP_FILES=()

# ============================================================================
# Pre-flight checks
# ============================================================================

preflight_checks() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "  YubiKey PAM Authentication Setup"
    echo "════════════════════════════════════════════════════════"
    echo ""

    # Check YubiKey is inserted
    if ! ykman info &>/dev/null; then
        error "No YubiKey detected. Please insert your YubiKey and try again."
    fi
    info "YubiKey detected"

    # Check pamu2fcfg is available
    if ! command -v pamu2fcfg &>/dev/null; then
        error "pamu2fcfg not found. Run 'home-manager switch --impure' first."
    fi
    info "pamu2fcfg available"

    # Warn if u2f_keys already exists
    if [ -f "$U2F_KEYS" ]; then
        echo ""
        warn "Existing key registration found at $U2F_KEYS"
        read -p "Overwrite? [y/N]: " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            info "Keeping existing registration. Skipping to PAM setup..."
            return 1
        fi
    fi
    return 0
}

# ============================================================================
# FIDO2 PIN setup
# ============================================================================

setup_fido2_pin() {
    echo ""
    echo "────────────────────────────────────────────────────────"
    echo "  Step 1: FIDO2 PIN"
    echo "────────────────────────────────────────────────────────"
    echo ""
    echo "A PIN is required for PAM authentication (pinverification=1)."
    echo ""
    read -p "Set or change FIDO2 PIN? [y/N]: " set_pin

    if [[ "$set_pin" =~ ^[Yy]$ ]]; then
        ykman fido access change-pin || warn "PIN setup cancelled or failed"
    else
        info "Skipping PIN setup (assuming already configured)"
    fi
}

# ============================================================================
# Key registration
# ============================================================================

register_keys() {
    echo ""
    echo "────────────────────────────────────────────────────────"
    echo "  Step 2: Register YubiKey"
    echo "────────────────────────────────────────────────────────"
    echo ""
    echo "Touch your YubiKey when it blinks."
    echo ""

    mkdir -p "$YUBICO_DIR"

    if pamu2fcfg > "$U2F_KEYS"; then
        info "Primary key registered successfully"
    else
        error "Key registration failed. Is your YubiKey inserted?"
    fi

    # Backup key registration loop
    echo ""
    read -p "Register a backup YubiKey? [y/N]: " add_backup

    while [[ "$add_backup" =~ ^[Yy]$ ]]; do
        echo ""
        warn "Insert your BACKUP YubiKey now, then press Enter"
        read -r

        if pamu2fcfg >> "$U2F_KEYS"; then
            info "Backup key registered successfully"
        else
            warn "Backup key registration failed"
        fi

        read -p "Register another backup key? [y/N]: " add_backup
    done
}

# ============================================================================
# PAM configuration
# ============================================================================

configure_pam_file() {
    local pam_file="$1"
    local backup_file="${pam_file}.yubikey-backup"

    if [ ! -f "$pam_file" ]; then
        warn "File not found: $pam_file (skipping)"
        return 1
    fi

    # Backup original
    sudo cp "$pam_file" "$backup_file"
    info "Backed up $pam_file"

    # Add YubiKey auth line at top (after #%PAM header if present)
    # Insert before the first 'auth' line
    sudo sed -i '0,/^auth/{s/^auth/auth required pam_u2f.so cue pinverification=1\nauth/}' "$pam_file"
    info "Modified $pam_file"

    # Test prompt
    echo ""
    warn "═══════════════════════════════════════════════════════"
    warn "  TEST NOW in a NEW terminal window!"
    warn "═══════════════════════════════════════════════════════"
    echo ""
    case "$pam_file" in
        */sudo)
            echo "  Run: sudo whoami"
            echo "  Expected: PIN prompt → touch YubiKey → 'root'"
            ;;
        */gdm-password|*/gdm-fingerprint)
            echo "  Lock your screen and unlock with YubiKey"
            echo "  Expected: PIN prompt → touch YubiKey → unlocked"
            ;;
    esac
    echo ""
    read -p "Did it work? [y/N]: " worked

    if [[ ! "$worked" =~ ^[Yy]$ ]]; then
        warn "Restoring backup..."
        sudo cp "$backup_file" "$pam_file"
        info "Restored $pam_file from backup"
        return 1
    fi

    CONFIGURED_FILES+=("$pam_file")
    BACKUP_FILES+=("$backup_file")
    info "$pam_file configured successfully"
    return 0
}

configure_pam() {
    echo ""
    echo "────────────────────────────────────────────────────────"
    echo "  Step 3: Configure PAM Files"
    echo "────────────────────────────────────────────────────────"
    echo ""
    echo "Select which files to configure (YubiKey required for auth):"
    echo ""
    echo "  1) /etc/pam.d/sudo            - Terminal sudo commands"
    echo "  2) /etc/pam.d/gdm-password    - GDM login screen"
    echo "  3) /etc/pam.d/gdm-fingerprint - GDM fingerprint prompt"
    echo ""
    echo "  Example: '1' for sudo only, '1 2 3' for all"
    echo ""
    read -p "Enter numbers separated by spaces: " selections

    for selection in $selections; do
        case "$selection" in
            1) configure_pam_file "/etc/pam.d/sudo" ;;
            2) configure_pam_file "/etc/pam.d/gdm-password" ;;
            3) configure_pam_file "/etc/pam.d/gdm-fingerprint" ;;
            *) warn "Unknown selection: $selection" ;;
        esac
    done
}

# ============================================================================
# Fingerprint disable
# ============================================================================

disable_fingerprint() {
    echo ""
    echo "────────────────────────────────────────────────────────"
    echo "  Step 4: Fingerprint Reader (Optional)"
    echo "────────────────────────────────────────────────────────"
    echo ""
    echo "Disabling prevents fingerprint from bypassing YubiKey at GDM."
    echo ""
    read -p "Disable fingerprint reader? [y/N]: " disable_fp

    if [[ "$disable_fp" =~ ^[Yy]$ ]]; then
        sudo systemctl mask fprintd.service
        info "Fingerprint reader disabled (masked fprintd.service)"
        echo "  To re-enable: sudo systemctl unmask fprintd.service"
    fi
}

# ============================================================================
# Summary
# ============================================================================

print_summary() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "  YubiKey PAM Setup Complete"
    echo "════════════════════════════════════════════════════════"
    echo ""

    if [ ${#CONFIGURED_FILES[@]} -gt 0 ]; then
        echo "Configured files:"
        for f in "${CONFIGURED_FILES[@]}"; do
            echo "  ✓ $f"
        done
        echo ""
        echo "Backup locations:"
        for f in "${BACKUP_FILES[@]}"; do
            echo "  $f"
        done
    else
        echo "No PAM files were configured."
    fi

    echo ""
    warn "RECOVERY (if locked out):"
    echo "  1. Boot from live USB"
    echo "  2. Mount root filesystem:"
    echo "     sudo mount /dev/sdaX /mnt"
    echo "  3. Restore PAM files:"
    echo "     sudo cp /mnt/etc/pam.d/sudo.yubikey-backup /mnt/etc/pam.d/sudo"
    echo "  4. Unmount and reboot:"
    echo "     sudo umount /mnt && reboot"
    echo ""
}

# ============================================================================
# Main
# ============================================================================

main() {
    if preflight_checks; then
        setup_fido2_pin
        register_keys
    fi

    configure_pam
    disable_fingerprint
    print_summary
}

main "$@"
