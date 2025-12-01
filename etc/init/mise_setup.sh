#!/bin/bash

# mise セットアップスクリプト
# Node.js, Bun, およびniのインストール

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

e_header "mise セットアップを開始します"

# miseがインストールされているか確認
if ! has "mise"; then
    e_failure "mise がインストールされていません"
    e_warning "まず mise をインストールしてください: brew install mise"
    exit 1
fi

e_success "mise が検出されました"

# miseの設定ファイルを確認
if [ ! -f "$HOME/.config/mise/config.toml" ]; then
    e_header "mise設定ファイルをコピーしています..."
    mkdir -p "$HOME/.config/mise"
    cp "$DOTPATH/.config/mise/config.toml" "$HOME/.config/mise/config.toml"
    e_success "mise設定ファイルをコピーしました"
fi

# Node.js LTSをインストール
e_header "Node.js LTS をインストールしています..."
if mise use -g node@lts; then
    e_success "Node.js LTS がインストールされました"
else
    e_failure "Node.js LTS のインストールに失敗しました"
    exit 1
fi

# Bunをインストール
e_header "Bun をインストールしています..."
if mise use -g bun@latest; then
    e_success "Bun がインストールされました"
else
    e_warning "Bun のインストールに失敗しました（スキップ）"
fi

# シェル設定を再読み込み（miseのactivate）
e_header "mise環境を有効化しています..."
eval "$(mise activate bash)"

# niをインストール
e_header "ni (パッケージマネージャー統一ツール) をインストールしています..."
if npm install -g @antfu/ni; then
    e_success "ni がインストールされました"

    # niのバージョンを表示
    if has "ni"; then
        ni_version=$(ni --version 2>/dev/null || echo "unknown")
        e_success "ni バージョン: $ni_version"
    fi
else
    e_warning "ni のインストールに失敗しました"
fi

# インストール済みツールを表示
e_header "インストール済みツール:"
mise list

e_header "セットアップが完了しました！"
echo ""
echo "次のステップ:"
echo "  1. シェルを再起動: exec \$SHELL"
echo "  2. niを使ってみる: ni (プロジェクトディレクトリで実行)"
echo ""
echo "詳細は .config/mise/README.md を参照してください"
