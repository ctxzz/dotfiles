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

# sketchybarの設定ファイルを確認
if [ ! -f "$HOME/.config/sketchybar/sketchybarrc" ]; then
  e_header "sketchybar設定ファイルをコピーしています..."
  cp "$DOTPATH/.config/sketchybar/sketchybarrc" "$HOME/.config/sketchybar/sketchybarrc"
  e_success "sketchybar設定ファイルをコピーしました"
else
  e_warning "sketchybar設定ファイルは既に存在します"
  e_warning "既存のファイル: $HOME/.config/sketchybar/sketchybarrc"

  # バックアップを作成してから上書きするか確認
  # FORCE環境変数が設定されている場合は自動的に上書き
  if [ "${FORCE:-}" = "1" ]; then
    REPLY="y"
  elif [ -t 0 ]; then
    # 対話モード（標準入力が端末）の場合のみプロンプト表示
    read -p "既存の設定を上書きしますか？ (バックアップを作成します) [y/N]: " -n 1 -r
    echo
  else
    # 非対話モード（自動化スクリプトなど）ではスキップ
    e_warning "非対話モードのため、設定ファイルの更新をスキップします"
    e_warning "上書きする場合は FORCE=1 を設定してください: FORCE=1 bash $0"
    REPLY="n"
  fi

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    backup_file="$HOME/.config/sketchybar/sketchybarrc.backup"
    cp "$HOME/.config/sketchybar/sketchybarrc" "$backup_file"
    e_success "既存の設定をバックアップしました: $backup_file"

    cp "$DOTPATH/.config/sketchybar/sketchybarrc" "$HOME/.config/sketchybar/sketchybarrc"
    e_success "sketchybar設定ファイルを更新しました"
  else
    e_warning "設定ファイルの更新をスキップしました"
  fi
fi

# pluginsディレクトリの内容をコピー（存在する場合）
if [ -d "$DOTPATH/.config/sketchybar/plugins" ]; then
  e_header "sketchybar pluginsをコピーしています..."
  # pluginsディレクトリ内にファイルがある場合のみコピー（.gitkeepを除く）
  plugin_files=$(find "$DOTPATH/.config/sketchybar/plugins" -type f ! -name '.gitkeep' 2>/dev/null || true)
  if [ -n "$plugin_files" ]; then
    # ファイルごとにコピー
    while IFS= read -r file; do
      cp "$file" "$HOME/.config/sketchybar/plugins/" 2>/dev/null || true
      chmod +x "$HOME/.config/sketchybar/plugins/$(basename "$file")" 2>/dev/null || true
    done <<< "$plugin_files"
    e_success "sketchybar pluginsをコピーしました"
  else
    e_warning "pluginsディレクトリは空です（後で追加してください）"
  fi
fi

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
