#!/bin/bash

# Linux package installation script
# Installs essential developer tools via the system package manager (apt/dnf/pacman)

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

if ! is_linux; then
    e_failure "error: this script is only supported on Linux"
    exit 1
fi

# Detect package manager
if has "apt-get"; then
    PM="apt"
elif has "dnf"; then
    PM="dnf"
elif has "pacman"; then
    PM="pacman"
else
    e_failure "No supported package manager found (apt, dnf, or pacman)"
    exit 1
fi

e_header "Package manager: $PM"

# Update package lists
e_header "Updating package lists..."
case "$PM" in
    apt)    sudo apt-get update -y ;;
    dnf)    sudo dnf check-update -y || true ;;
    pacman) sudo pacman -Sy --noconfirm ;;
esac

# Helper: install a required package (failure is fatal)
install_pkg() {
    local pkg="$1"
    e_header "Installing $pkg..."
    case "$PM" in
        apt)    sudo apt-get install -y "$pkg" ;;
        dnf)    sudo dnf install -y "$pkg" ;;
        pacman) sudo pacman -S --noconfirm "$pkg" ;;
    esac
    e_success "Installed: $pkg"
}

# Helper: install an optional package (failure is non-fatal)
install_pkg_optional() {
    local pkg="$1"
    install_pkg "$pkg" || e_warning "Failed to install $pkg (skipping)"
}

# Essential build tools
e_header "Installing build tools..."
case "$PM" in
    apt)    sudo apt-get install -y build-essential ;;
    dnf)    sudo dnf groupinstall -y "Development Tools" ;;
    pacman) sudo pacman -S --noconfirm base-devel ;;
esac

# Base tools
e_header "Installing base tools..."
for pkg in git curl wget; do
    install_pkg "$pkg"
done

# Shell and terminal utilities
e_header "Installing shell and terminal utilities..."
for pkg in zsh tmux fzf ripgrep; do
    install_pkg "$pkg"
done

# Better CLI tools
e_header "Installing modern CLI tools..."
case "$PM" in
    apt)
        install_pkg "bat"
        # fd-find is the apt package name; binary is fdfind
        install_pkg_optional "fd-find"
        install_pkg_optional "git-lfs"
        # eza: not in default repos on older Ubuntu/Debian, try optional
        install_pkg_optional "eza"
        install_pkg "jq"
        install_pkg "tree"
        install_pkg "htop"
        install_pkg "direnv"
        ;;
    dnf)
        install_pkg "bat"
        install_pkg_optional "fd-find"
        install_pkg_optional "git-lfs"
        install_pkg_optional "eza"
        install_pkg "jq"
        install_pkg "tree"
        install_pkg "htop"
        install_pkg "direnv"
        ;;
    pacman)
        install_pkg "bat"
        install_pkg "fd"
        install_pkg_optional "git-lfs"
        install_pkg "eza"
        install_pkg "jq"
        install_pkg "tree"
        install_pkg "htop"
        install_pkg "direnv"
        ;;
esac

# GitHub CLI
if ! has "gh"; then
    e_header "Installing GitHub CLI..."
    case "$PM" in
        apt)
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
                | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
                | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt-get update -y
            sudo apt-get install -y gh
            ;;
        dnf)
            sudo dnf install -y gh
            ;;
        pacman)
            sudo pacman -S --noconfirm github-cli
            ;;
    esac
    e_success "GitHub CLI installed"
fi

e_success "Package installation completed"
