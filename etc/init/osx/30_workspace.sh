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

# Run the workspace setup script
if [ -f "$DOTPATH/etc/init/ws_setup.sh" ]; then
    e_header "Setting up workspace (ws) directories..."
    bash "$DOTPATH/etc/init/ws_setup.sh" || {
        e_warning "Workspace setup encountered some issues"
        e_warning "You can run it manually later: bash $DOTPATH/etc/init/ws_setup.sh"
        # Don't exit with error - allow setup to continue
    }
else
    e_failure "error: ws_setup.sh not found at $DOTPATH/etc/init/ws_setup.sh"
    exit 1
fi

e_success "Workspace setup script completed"
