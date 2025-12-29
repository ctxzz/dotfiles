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
    # Exit with success (0) to not fail the overall init process
    # Note: This means init.sh won't detect that workspace setup was skipped
    # The warnings above inform the user about this situation
    exit 0
fi

# Run the workspace setup script
if [ -f "$DOTPATH/etc/init/ws_setup.sh" ]; then
    e_header "Setting up workspace (ws) directories..."
    if bash "$DOTPATH/etc/init/ws_setup.sh"; then
        e_success "Workspace setup script completed"
    else
        ws_status=$?
        # Treat critical execution failures (e.g., not executable, not found) as fatal
        if [ "$ws_status" -eq 126 ] || [ "$ws_status" -eq 127 ]; then
            e_failure "Workspace setup script failed to execute (exit code $ws_status)"
            e_failure "Please ensure it is executable and has no syntax errors: $DOTPATH/etc/init/ws_setup.sh"
            exit 1
        fi
        e_warning "Workspace setup encountered some issues (exit code $ws_status)"
        e_warning "You can run it manually later: bash $DOTPATH/etc/init/ws_setup.sh"
        # Don't fail the entire init process for non-critical workspace issues
    fi
else
    e_failure "error: ws_setup.sh not found at $DOTPATH/etc/init/ws_setup.sh"
    exit 1
fi
