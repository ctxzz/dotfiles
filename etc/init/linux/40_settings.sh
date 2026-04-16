#!/bin/bash

# Linux システム設定スクリプト
# GNOME デスクトップ設定とワークスペースディレクトリの作成

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

if ! is_linux; then
    e_failure "error: this script is only supported on Linux"
    exit 1
fi

e_header "Setting Linux defaults..."

# GNOME settings (only if gsettings is available)
if has "gsettings"; then
    e_header "Configuring GNOME settings..."

    # File manager: show hidden files
    gsettings set org.gnome.nautilus.preferences show-hidden-files true || true
    gsettings set org.gtk.Settings.FileChooser show-hidden true || true

    # Power settings
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600 || true
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 1800 || true

    # Keyboard settings
    gsettings set org.gnome.desktop.peripherals.keyboard repeat true || true
    gsettings set org.gnome.desktop.peripherals.keyboard delay 250 || true
    gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30 || true

    # Mouse / touchpad settings
    gsettings set org.gnome.desktop.peripherals.mouse speed 0.5 || true
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true || true
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false || true

    # Window manager settings
    gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close' || true
    gsettings set org.gnome.desktop.wm.preferences action-double-click-titlebar 'toggle-maximize' || true

    e_success "GNOME settings configured"
else
    e_warning "gsettings not found — skipping GNOME configuration"
fi

# Create workspace directories (mirrors macOS ws_setup.sh structure)
e_header "Creating workspace directories..."
mkdir -p "$HOME/ws/local/sandbox"
mkdir -p "$HOME/ws/local/work"
e_success "Workspace directories created"

e_success "Linux settings completed"
