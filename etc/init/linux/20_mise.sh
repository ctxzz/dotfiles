#!/bin/bash

# mise セットアップスクリプト (Linux)
# Node.js, Bun, およびniのインストール

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# DOTPATH が未定義の場合、自動検出
if [ -z "${DOTPATH:-}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    DOTPATH="$(cd "$SCRIPT_DIR/../../.." && pwd)"
    export DOTPATH
fi

. "$DOTPATH"/etc/lib/vital.sh

if ! is_linux; then
    e_failure "error: this script is only supported on Linux"
    exit 1
fi

e_header "mise セットアップを開始します"

# Install mise if not present
if ! has "mise"; then
    e_header "mise をインストールしています..."
    curl https://mise.run | sh

    # Add mise to PATH for this session
    export PATH="$HOME/.local/bin:$PATH"

    if ! has "mise"; then
        e_failure "mise のインストールに失敗しました"
        exit 1
    fi
fi

e_success "mise が検出されました"

# Copy mise config if not present
if [ ! -f "$HOME/.config/mise/config.toml" ] && [ -f "$DOTPATH/.config/mise/config.toml" ]; then
    e_header "mise設定ファイルをコピーしています..."
    mkdir -p "$HOME/.config/mise"
    cp "$DOTPATH/.config/mise/config.toml" "$HOME/.config/mise/config.toml"
    e_success "mise設定ファイルをコピーしました"
fi

# Install Node.js LTS
e_header "Node.js LTS をインストールしています..."
if mise use -g node@lts; then
    e_success "Node.js LTS がインストールされました"
else
    e_failure "Node.js LTS のインストールに失敗しました"
    exit 1
fi

# Install Bun
e_header "Bun をインストールしています..."
if mise use -g bun@latest; then
    e_success "Bun がインストールされました"
else
    e_warning "Bun のインストールに失敗しました（スキップ）"
fi

# Activate mise for this session
e_header "mise環境を有効化しています..."
eval "$(mise activate bash)"

# Install ni
e_header "ni (パッケージマネージャー統一ツール) をインストールしています..."
if npm install -g @antfu/ni; then
    e_success "ni がインストールされました"
    if has "ni"; then
        ni_version=$(ni --version 2>/dev/null || echo "unknown")
        e_success "ni バージョン: $ni_version"
    fi
else
    e_warning "ni のインストールに失敗しました"
fi

# Show installed tools
e_header "インストール済みツール:"
mise list

e_success "mise セットアップが完了しました"
