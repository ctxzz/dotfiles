#!/bin/bash

# AeroSpace セットアップスクリプト
# macOS用ウィンドウマネージャーの設定ファイルを配置

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

e_header "AeroSpace セットアップを開始します"

# macOSかどうか確認
if [ "$(get_os)" != "osx" ]; then
  e_failure "AeroSpace は macOS 専用です"
  exit 1
fi

# AeroSpaceがインストールされているか確認
if ! has "aerospace"; then
  e_failure "AeroSpace がインストールされていません"
  e_warning "まず AeroSpace をインストールしてください: brew install --cask aerospace"
  exit 1
fi

e_success "AeroSpace が検出されました"

# AeroSpaceの設定ファイルを確認
if [ ! -f "$HOME/.config/aerospace/aerospace.toml" ]; then
  e_header "AeroSpace設定ファイルをコピーしています..."
  mkdir -p "$HOME/.config/aerospace"
  cp "$DOTPATH/.config/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
  e_success "AeroSpace設定ファイルをコピーしました"
else
  e_warning "AeroSpace設定ファイルは既に存在します"
  e_warning "既存のファイル: $HOME/.config/aerospace/aerospace.toml"

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
    backup_file="$HOME/.config/aerospace/aerospace.toml.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$HOME/.config/aerospace/aerospace.toml" "$backup_file"
    e_success "既存の設定をバックアップしました: $backup_file"

    cp "$DOTPATH/.config/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
    e_success "AeroSpace設定ファイルを更新しました"
  else
    e_warning "設定ファイルの更新をスキップしました"
  fi
fi

# AeroSpaceの設定を再読み込み
e_header "AeroSpace設定を再読み込みしています..."
if aerospace reload-config; then
  e_success "AeroSpace設定を再読み込みしました"
else
  e_warning "AeroSpace設定の再読み込みに失敗しました"
  e_warning "AeroSpaceが実行中でない可能性があります"
fi

e_success "AeroSpace セットアップが完了しました"
