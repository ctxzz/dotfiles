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

# Check if Homebrew is already installed
if has "brew"; then
    e_success "Homebrew: already installed"
    
    # Update Homebrew
    e_header "Updating Homebrew..."
    brew update || e_failure "Failed to update Homebrew"
    
    # Upgrade all packages
    e_header "Upgrading packages..."
    brew upgrade || e_warning "Some packages failed to upgrade"
    
    # Doctor check
    e_header "Running brew doctor..."
    brew doctor || e_warning "Some issues were found by brew doctor"
    
    exit 0
fi

# Check for required dependencies
if ! has "curl"; then
    e_failure "error: curl is required for Homebrew installation"
    exit 1
fi

# Install Homebrew
e_header "Installing Homebrew..."
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
    e_failure "Failed to install Homebrew"
    exit 1
}

# Set Homebrew environment variables based on architecture
if [ "$(uname -m)" = "arm64" ]; then
    # For Apple Silicon
    BREW_PATH="/opt/homebrew"
else
    # For Intel
    BREW_PATH="/usr/local"
fi

# Add Homebrew to PATH
if [ -f "$HOME/.zprofile" ]; then
    if ! grep -q "eval \"\$(${BREW_PATH}/bin/brew shellenv)\"" "$HOME/.zprofile"; then
        echo "eval \"\$(${BREW_PATH}/bin/brew shellenv)\"" >> "$HOME/.zprofile"
        e_header "Added Homebrew to .zprofile"
    fi
fi

if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "eval \"\$(${BREW_PATH}/bin/brew shellenv)\"" "$HOME/.zshrc"; then
        echo "eval \"\$(${BREW_PATH}/bin/brew shellenv)\"" >> "$HOME/.zshrc"
        e_header "Added Homebrew to .zshrc"
    fi
fi

# Initialize Homebrew environment
eval "$("$BREW_PATH/bin/brew" shellenv)"

# Verify installation
if has "brew"; then
    e_header "Running brew doctor for initial check..."
    brew doctor || e_warning "Some issues were found by brew doctor"
    
    # Install essential formulae
    e_header "Installing essential formulae..."
    brew install git || e_warning "Failed to install git"
    
    e_success "Homebrew installation completed successfully"
else
    e_failure "error: Homebrew installation failed"
    exit 1
fi
