#!/bin/bash
set -eu
trap 'e_failure "An error occurred. Exiting."; exit 1' ERR INT

###############################################################################
# ws / Cloud セットアップスクリプト
# - Google Drive（メールアドレス秘匿）
# - iCloud（Obsidian）
# - ws/local（ローカル専用）
###############################################################################

# Load vital library for logging
if [ -n "${DOTPATH:-}" ] && [ -f "$DOTPATH/etc/lib/vital.sh" ]; then
    . "$DOTPATH/etc/lib/vital.sh"
else
    # Fallback log functions if vital.sh is not available
    e_header() { printf "\n==> %s\n" "$*"; }
    e_success() { printf "✓ %s\n" "$*"; }
    e_failure() { printf "✗ %s\n" "$*" >&2; }
    e_warning() { printf "! %s\n" "$*"; }
fi

# ===== 設定 =====
GD_PREFIX="GoogleDrive-omata"   # ここまでなら公開OK
WS_DIR="$HOME/ws"
CLOUD_DIR="$HOME/Cloud"

OBSIDIAN_REAL="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents"

GD_MYDRIVE_REL="My Drive"
GD_SLIDE_REL="03slide"
GD_PAPER_REL="02thesis"
GD_NOTE_REL="06note"
# =================

die() { 
    e_failure "$*"
    exit 1
}

ensure_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        e_success "Created directory: $1"
    fi
}

ensure_symlink() {
    local target="$1"
    local linkpath="$2"

    if [ -L "$linkpath" ]; then
        # Already a symlink - check if it points to the correct target
        local current_target
        current_target="$(readlink "$linkpath")"
        if [ "$current_target" = "$target" ]; then
            e_success "Symlink already exists: $linkpath -> $target"
        else
            e_warning "Symlink exists but points to different target: $linkpath -> $current_target"
            e_warning "Expected: $target"
        fi
        return
    fi
    
    if [ -e "$linkpath" ]; then
        die "Path exists but is not a symlink: $linkpath"
    fi
    
    # Check if target exists before creating symlink
    if [ ! -e "$target" ]; then
        e_warning "Target does not exist, skipping symlink creation: $target"
        return
    fi
    
    ln -s "$target" "$linkpath"
    e_success "Created symlink: $linkpath -> $target"
}

detect_google_drive_root() {
    local pattern="$HOME/Library/CloudStorage/${GD_PREFIX}"'*'
    local first_match
    
    # Find first matching directory
    # Intentional word splitting for glob expansion:
    # pattern is safely controlled ($HOME, GD_PREFIX, and a literal '*')
    # and does not contain spaces.
    # shellcheck disable=SC2231
    for first_match in $pattern; do
        if [ -d "$first_match" ]; then
            printf "%s" "$first_match"
            return 0
        fi
    done
    
    # Not found
    return 1
}

main() {
    e_header "Setting up workspace (ws) and cloud directories"
    
    # Create base directories
    ensure_dir "$WS_DIR/local"
    ensure_dir "$CLOUD_DIR"
    
    # Detect and link Google Drive
    local gd_root=""
    if gd_root="$(detect_google_drive_root)"; then
        e_success "Detected Google Drive: $gd_root"
        ensure_symlink "$gd_root" "$CLOUD_DIR/GoogleDrive"
        
        # Setup Google Drive workspace links
        local gd_mydrive="$CLOUD_DIR/GoogleDrive/$GD_MYDRIVE_REL"
        if [ -d "$gd_mydrive" ]; then
            ensure_symlink "$gd_mydrive/$GD_SLIDE_REL" "$WS_DIR/slide"
            ensure_symlink "$gd_mydrive/$GD_PAPER_REL" "$WS_DIR/paper"
            ensure_symlink "$gd_mydrive/$GD_NOTE_REL"  "$WS_DIR/note"
        else
            e_warning "Google Drive 'My Drive' not found: $gd_mydrive"
            e_warning "Files may still be downloading. Run this script again after sync completes."
        fi
    else
        e_warning "Google Drive for Desktop is not installed or not syncing yet"
        e_warning "This is normal for initial setup. After installing Google Drive:"
        e_warning "  1. Install: https://www.google.com/drive/download/"
        e_warning "  2. Sign in and wait for initial sync to complete"
        e_warning "  3. Re-run: bash ~/.dotfiles/etc/init/ws_setup.sh"
    fi
    
    # Setup Obsidian (iCloud)
    if [ -d "$OBSIDIAN_REAL" ]; then
        ensure_symlink "$OBSIDIAN_REAL" "$WS_DIR/obsidian"
    else
        e_warning "Obsidian iCloud directory not found: $OBSIDIAN_REAL"
        e_warning "This is normal if Obsidian is not installed yet. After installing:"
        e_warning "  1. Install Obsidian: https://obsidian.md/"
        e_warning "  2. Enable iCloud sync in Obsidian settings"
        e_warning "  3. Re-run: bash ~/.dotfiles/etc/init/ws_setup.sh"
    fi
    
    # Create local workspace directories
    ensure_dir "$WS_DIR/local/sandbox"
    ensure_dir "$WS_DIR/local/work"
    
    e_success "Workspace setup completed!"
    echo ""
    e_header "Workspace structure:"
    echo "  ~/ws/               # Main workspace (entry point)"
    echo "  ~/ws/slide          # Google Drive - slides"
    echo "  ~/ws/paper          # Google Drive - papers/thesis"
    echo "  ~/ws/note           # Google Drive - notes"
    echo "  ~/ws/obsidian       # iCloud - Obsidian vault"
    echo "  ~/ws/local/         # Local-only (not synced)"
    echo "  ~/ws/local/sandbox  # Experiments and temporary work"
    echo "  ~/ws/local/work     # Local work files"
    
    # Show summary of what needs to be done if cloud services are missing
    if [ -z "${gd_root:-}" ] || [ ! -d "$OBSIDIAN_REAL" ]; then
        echo ""
        e_header "Note: Some cloud services are not available yet"
        if [ -z "${gd_root:-}" ]; then
            echo "  - Google Drive: Install and sync, then re-run setup"
        fi
        if [ ! -d "$OBSIDIAN_REAL" ]; then
            echo "  - Obsidian (iCloud): Install and enable iCloud, then re-run setup"
        fi
        echo ""
        echo "You can continue using ~/ws/local for now and set up cloud sync later."
    fi
}

main "$@"
