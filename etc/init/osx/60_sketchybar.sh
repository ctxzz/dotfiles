#!/bin/bash

# sketchybar セットアップスクリプト
# macOS用メニューバー代替ツールの設定ファイルを配置

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# DOTPATH が未定義の場合、自動検出
if [ -z "${DOTPATH:-}" ]; then
  # スクリプトのディレクトリから DOTPATH を推測
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  DOTPATH="$(cd "$SCRIPT_DIR/../../.." && pwd)"
  export DOTPATH
fi

. "$DOTPATH"/etc/lib/vital.sh

e_header "sketchybar セットアップを開始します"

# macOSかどうか確認
if [ "$(get_os)" != "osx" ]; then
  e_failure "sketchybar は macOS 専用です"
  exit 1
fi

# sketchybarがインストールされているか確認
if ! has "sketchybar"; then
  e_failure "sketchybar がインストールされていません"
  e_warning "まず sketchybar をインストールしてください: brew install sketchybar"
  exit 1
fi

e_success "sketchybar が検出されました"

# sketchybarの設定ディレクトリを作成
mkdir -p "$HOME/.config/sketchybar/plugins"
mkdir -p "$HOME/.config/sketchybar/items"

# sketchybar-app-fontのインストール確認
if [ ! -f "$HOME/Library/Fonts/sketchybar-app-font.ttf" ]; then
  e_header "sketchybar-app-fontをインストールしています..."
  if curl -fsSL https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.32/sketchybar-app-font.ttf -o "$HOME/Library/Fonts/sketchybar-app-font.ttf"; then
    e_success "sketchybar-app-fontをインストールしました"
  else
    e_warning "sketchybar-app-fontのインストールに失敗しました"
    e_warning "手動でインストールしてください: https://github.com/kvndrsslr/sketchybar-app-font"
  fi
else
  e_success "sketchybar-app-fontは既にインストール済みです"
fi

# 設定ファイルのコピー関数
copy_config_file() {
  local file="$1"
  local dest="$2"
  local file_desc="${3:-設定ファイル}"
  
  if [ ! -f "$dest" ]; then
    cp "$file" "$dest"
    e_success "$file_desc をコピーしました: $(basename "$file")"
  else
    if [ "${FORCE:-}" = "1" ]; then
      cp "$dest" "${dest}.backup"
      cp "$file" "$dest"
      e_success "$file_desc を更新しました: $(basename "$file")"
    else
      e_warning "$file_desc は既に存在します: $(basename "$file")"
    fi
  fi
}

# 主要な設定ファイルをコピー
e_header "sketchybar設定ファイルをコピーしています..."
copy_config_file "$DOTPATH/.config/sketchybar/sketchybarrc" "$HOME/.config/sketchybar/sketchybarrc" "sketchybarrc"
copy_config_file "$DOTPATH/.config/sketchybar/colors.sh" "$HOME/.config/sketchybar/colors.sh" "colors.sh"
copy_config_file "$DOTPATH/.config/sketchybar/icons.sh" "$HOME/.config/sketchybar/icons.sh" "icons.sh"
copy_config_file "$DOTPATH/.config/sketchybar/bar.sh" "$HOME/.config/sketchybar/bar.sh" "bar.sh"
copy_config_file "$DOTPATH/.config/sketchybar/default.sh" "$HOME/.config/sketchybar/default.sh" "default.sh"

# pluginsディレクトリの内容をコピー
if [ -d "$DOTPATH/.config/sketchybar/plugins" ]; then
  e_header "sketchybar pluginsをコピーしています..."
  plugin_files=$(find "$DOTPATH/.config/sketchybar/plugins" -type f ! -name '.gitkeep' 2>/dev/null || true)
  if [ -n "$plugin_files" ]; then
    while IFS= read -r file; do
      cp "$file" "$HOME/.config/sketchybar/plugins/"
      chmod +x "$HOME/.config/sketchybar/plugins/$(basename "$file")"
    done <<< "$plugin_files"
    e_success "sketchybar pluginsをコピーしました"
  fi
fi

# itemsディレクトリの内容をコピー
if [ -d "$DOTPATH/.config/sketchybar/items" ]; then
  e_header "sketchybar itemsをコピーしています..."
  item_files=$(find "$DOTPATH/.config/sketchybar/items" -type f ! -name '.gitkeep' 2>/dev/null || true)
  if [ -n "$item_files" ]; then
    while IFS= read -r file; do
      cp "$file" "$HOME/.config/sketchybar/items/"
      chmod +x "$HOME/.config/sketchybar/items/$(basename "$file")"
    done <<< "$item_files"
    e_success "sketchybar itemsをコピーしました"
  fi
fi

# コピーした設定ファイルに実行権限を付与
chmod +x "$HOME/.config/sketchybar/sketchybarrc" 2>/dev/null || true
chmod +x "$HOME/.config/sketchybar/"*.sh 2>/dev/null || true

# sketchybarが実行中か確認
if brew services list | grep -q "sketchybar.*started"; then
  e_header "sketchybar設定を再読み込みしています..."
  if sketchybar --reload; then
    e_success "sketchybar設定を再読み込みしました"
  else
    e_warning "sketchybar設定の再読み込みに失敗しました"
  fi
else
  e_warning "sketchybarは起動していません"
  e_warning "起動するには: brew services start sketchybar"
fi

e_success "sketchybar セットアップが完了しました"
