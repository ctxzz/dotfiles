#!/bin/bash

# zsh セットアップスクリプト (Linux)
# zsh のインストールとデフォルトシェルへの設定

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

if ! is_linux; then
    e_failure "error: this script is only supported on Linux"
    exit 1
fi

# Install zsh if not present
if has "zsh"; then
    e_success "zsh: already installed"
else
    e_header "Installing zsh..."
    if has "apt-get"; then
        sudo apt-get install -y zsh
    elif has "dnf"; then
        sudo dnf install -y zsh
    elif has "pacman"; then
        sudo pacman -S --noconfirm zsh
    else
        e_failure "No supported package manager found"
        exit 1
    fi
fi

# Set zsh as the login shell
if ! contains "${SHELL:-}" "zsh"; then
    zsh_path="$(which zsh)"

    # Register in /etc/shells if needed
    if ! grep -xq "$zsh_path" /etc/shells; then
        e_header "Adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    # Change shell for current user
    if [ -x "$zsh_path" ]; then
        if chsh -s "$zsh_path" "${USER:-root}"; then
            e_success "Changed shell to $zsh_path for ${USER:-root}"
        else
            e_failure "Failed to change shell to $zsh_path"
            e_failure "Please check if $zsh_path is in /etc/shells"
            exit 1
        fi
    else
        e_failure "error: $zsh_path is not executable"
        exit 1
    fi
else
    e_success "zsh is already the login shell"
fi

e_success "zsh setup completed"
