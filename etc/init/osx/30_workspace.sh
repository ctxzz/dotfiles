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
# Workspace setup should run after Homebrew installation and package installation
if ! has "brew"; then
    e_warning "Homebrew is not installed yet"
    e_warning "Workspace setup will be skipped for now"
    e_warning "After installing Homebrew and cloud services (Google Drive, Obsidian):"
    e_warning "  Run: bash ~/.dotfiles/etc/init/ws_setup.sh"
    exit 0
fi

# Run the workspace setup script
if [ -f "$DOTPATH/etc/init/ws_setup.sh" ]; then
    e_header "Setting up workspace (ws) directories..."
    if bash "$DOTPATH/etc/init/ws_setup.sh"; then
        e_success "Workspace setup script completed"
    else
        e_warning "Workspace setup encountered some issues"
        e_warning "You can run it manually later: bash $DOTPATH/etc/init/ws_setup.sh"
        # Don't fail the entire init process
    fi
else
    e_failure "error: ws_setup.sh not found at $DOTPATH/etc/init/ws_setup.sh"
    exit 1
fi
