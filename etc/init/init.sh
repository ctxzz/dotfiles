#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

if [ -z "$DOTPATH" ]; then
    # shellcheck disable=SC2016
    echo '$DOTPATH not set' >&2
    exit 1
fi

# Get OS type
OS="$(get_os)"
if [ "$OS" = "unknown" ]; then
    e_failure "Unknown OS type: $(uname)"
    exit 1
fi
e_header "Detected OS: $OS"

# Ask for the administrator password upfront
if [ "$OS" = "osx" ]; then
    # macOSの場合のみsudoを使用
    sudo -v || true
    # Keep-alive: update existing `sudo` time stamp until the script has finished
    (while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null) &
fi

# Define script execution function
run_script() {
    local script="$1"
    if [ -f "$script" ]; then
        e_header "$(basename "$script")"
        if [ "${DEBUG:-}" != 1 ]; then
            bash "$script" || {
                e_failure "Failed to execute: $script"
                return 1
            }
        fi
    fi
}

# Run OS-specific scripts
case "$OS" in
    "osx")
        # macOS scripts
        for i in "$DOTPATH"/etc/init/osx/*.sh; do
            if [ -f "$i" ]; then
                run_script "$i"
            fi
        done
        ;;
    "linux")
        # Linux scripts
        for i in "$DOTPATH"/etc/init/linux/*.sh; do
            if [ -f "$i" ]; then
                run_script "$i"
            fi
        done
        ;;
    *)
        e_failure "Unsupported OS: $OS"
        exit 1
        ;;
esac

e_success "$0: Finish!!" | sed "s $DOTPATH \$DOTPATH g"
