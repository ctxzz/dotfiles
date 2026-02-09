#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "======================================"
echo "SketchyBar Configuration Installer"
echo "======================================"
echo ""
echo "Source: $SCRIPT_DIR"

if ! command -v sketchybar &> /dev/null; then
    echo "SketchyBar is not installed."
    echo "Install it with: brew install sketchybar"
    exit 1
fi

echo "SketchyBar is installed"

if ! command -v aerospace &> /dev/null; then
    echo "Aerospace is not installed."
    echo "Install it with: brew install --cask nikitabobko/tap/aerospace"
    echo "Continue anyway? (y/n)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "Aerospace is installed"
fi

if [ ! -f "$HOME/Library/Fonts/sketchybar-app-font.ttf" ]; then
    echo ""
    echo "Installing sketchybar-app-font..."
    curl -fsSL https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.32/sketchybar-app-font.ttf -o "$HOME/Library/Fonts/sketchybar-app-font.ttf"
    echo "sketchybar-app-font installed"
else
    echo "sketchybar-app-font is installed"
fi

mkdir -p "$HOME/.config/sketchybar/plugins"
mkdir -p "$HOME/.config/sketchybar/items"

echo ""
echo "Copying configuration files..."

cp "$SCRIPT_DIR/sketchybarrc" "$HOME/.config/sketchybar/"
cp "$SCRIPT_DIR/colors.sh" "$HOME/.config/sketchybar/"
cp "$SCRIPT_DIR/icons.sh" "$HOME/.config/sketchybar/"
cp "$SCRIPT_DIR/bar.sh" "$HOME/.config/sketchybar/"
cp "$SCRIPT_DIR/default.sh" "$HOME/.config/sketchybar/"

cp "$SCRIPT_DIR/items/"*.sh "$HOME/.config/sketchybar/items/"
cp "$SCRIPT_DIR/plugins/"*.sh "$HOME/.config/sketchybar/plugins/"

echo "Setting permissions..."
chmod +x "$HOME/.config/sketchybar/sketchybarrc"
chmod +x "$HOME/.config/sketchybar/"*.sh
chmod +x "$HOME/.config/sketchybar/plugins/"*.sh
chmod +x "$HOME/.config/sketchybar/items/"*.sh

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "1. Start SketchyBar: brew services start sketchybar"
echo "2. Reload config: sketchybar --reload"
echo ""
