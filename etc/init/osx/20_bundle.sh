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

# Check if Homebrew is installed
if ! has "brew"; then
    e_failure "error: Homebrew is required but not installed"
    e_header "Please run 10_brew.sh first"
    exit 1
fi

# Change to the directory containing Brewfile
builtin cd "$DOTPATH"/etc/init/osx/

# Backup existing Brewfile if it exists
if [ -f Brewfile ]; then
    timestamp=$(date +%Y%m%d_%H%M%S)
    e_header "Creating backup of existing Brewfile..."
    cp Brewfile "Brewfile.backup.${timestamp}" || {
        e_failure "Failed to create Brewfile backup"
        exit 1
    }
fi

# Check for existing packages and create Brewfile if needed
if [ ! -f Brewfile ]; then
    e_header "Creating new Brewfile from current packages..."
    brew bundle dump --force || {
        e_failure "Failed to create Brewfile"
        exit 1
    }
fi

# Install packages from Brewfile
e_header "Installing packages from Brewfile..."
export HOMEBREW_NO_AUTO_UPDATE=1  # Skip auto-update during bundle
if brew bundle check --no-upgrade >/dev/null 2>&1; then
    e_header "All packages are already installed"
else
    brew bundle install --no-upgrade || {
        e_failure "Some packages failed to install"
        # Continue execution even if some packages fail
        e_warning "Please check the output above for details"
    }
fi

# Cleanup
e_header "Cleaning up old versions..."
brew cleanup || e_warning "Cleanup encountered some issues"

# Final check
e_header "Verifying installations..."
brew bundle check --no-upgrade || {
    e_warning "Some packages may not have been installed correctly"
    e_header "Please review the Brewfile and install any missing packages manually"
}

e_success "Homebrew bundle setup completed"
