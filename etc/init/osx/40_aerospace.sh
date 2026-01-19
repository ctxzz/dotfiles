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

# Check if AeroSpace is installed
# AeroSpace setup should run after Homebrew installation and package installation
if ! has "aerospace"; then
    e_warning "AeroSpace is not installed yet"
    e_warning "AeroSpace setup will be skipped for now"
    e_warning "After installing AeroSpace (brew install --cask aerospace):"
    e_warning "  Run: bash ~/.dotfiles/etc/init/aerospace_setup.sh"
    # Exit with success (0) to not fail the overall init process
    exit 0
fi

# Run the AeroSpace setup script
if [ -f "$DOTPATH/etc/init/aerospace_setup.sh" ]; then
    e_header "Setting up AeroSpace configuration..."
    if bash "$DOTPATH/etc/init/aerospace_setup.sh"; then
        e_success "AeroSpace setup script completed"
    else
        aerospace_status=$?
        # Treat critical execution failures (e.g., not executable, not found) as fatal
        if [ "$aerospace_status" -eq 126 ] || [ "$aerospace_status" -eq 127 ]; then
            e_failure "AeroSpace setup script failed to execute (exit code $aerospace_status)"
            e_failure "Please ensure it is executable and has no syntax errors: $DOTPATH/etc/init/aerospace_setup.sh"
            exit 1
        fi
        e_warning "AeroSpace setup encountered some issues (exit code $aerospace_status)"
        e_warning "You can run it manually later: bash $DOTPATH/etc/init/aerospace_setup.sh"
        # Don't fail the entire init process for non-critical AeroSpace issues
    fi
else
    e_failure "error: aerospace_setup.sh not found at $DOTPATH/etc/init/aerospace_setup.sh"
    exit 1
fi
