#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

# OS detection function
is_osx() {
    [ "$(get_os)" = "osx" ]
}

# This script is only supported with OS X
if ! is_osx; then
    e_failure "error: this script is only supported with macOS"
    exit 1
fi

# Check if zsh is already installed
if has "zsh"; then
    e_success "zsh: already installed"
    
    # Set zsh as login shell if it's not already
    if ! contains "${SHELL:-}" "zsh"; then
        zsh_path="$(which zsh)"
        
        # Check if zsh is in /etc/shells
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
    exit 0
fi

# Install zsh using Homebrew
if has "brew"; then
    e_header "Installing zsh with Homebrew"
    brew install zsh
else
    e_failure "error: Homebrew is required but not installed"
    e_header "Please install Homebrew first: https://brew.sh"
    exit 1
fi

# Verify zsh installation
if ! has "zsh"; then
    e_failure "error: zsh installation failed"
    exit 1
fi

e_success "zsh installation completed successfully"

# Set zsh as login shell
zsh_path="$(which zsh)"
if [ -z "$zsh_path" ]; then
    e_failure "error: zsh path not found"
    exit 1
fi

# Add zsh to /etc/shells if needed
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

e_success "zsh setup completed successfully" 