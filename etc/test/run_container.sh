#!/bin/bash
# Podman を使って dotfiles のコンテナテストを実行するスクリプト
#
# 使い方:
#   run_container.sh [OS] [--init]
#
# OS 引数:
#   ubuntu   (default) Ubuntu 22.04
#   fedora             Fedora 39
#   arch               Arch Linux
#   macos              macOS 擬似テスト (uname=Darwin / brew モック)
#   windows            Windows 擬似テスト (uname=MSYS_NT / pwsh によるPS構文チェック)
#
# オプション:
#   --init   make init (パッケージインストール) も実行する

set -eu

DOTPATH="$(cd "$(dirname "$0")"/../.. && pwd)"
OS="${1:-ubuntu}"
RUN_INIT="false"
MOCK_OS=""

# フラグのパース
for arg in "$@"; do
    case "$arg" in --init) RUN_INIT="true" ;; esac
done

# OS → ベースイメージ / モード のマッピング
case "$OS" in
    ubuntu)  BASE_IMAGE="ubuntu:22.04" ;;
    fedora)  BASE_IMAGE="fedora:39" ;;
    arch)    BASE_IMAGE="archlinux:latest" ;;
    macos|darwin)
        BASE_IMAGE="ubuntu:22.04"
        MOCK_OS="macos"
        ;;
    windows|win)
        BASE_IMAGE="ubuntu:22.04"
        MOCK_OS="windows"
        ;;
    *)
        echo "Error: 不明な OS 指定: '$OS'"
        echo "  使用可能: ubuntu, fedora, arch, macos, windows"
        exit 1
        ;;
esac

IMAGE_NAME="dotfiles-test-${OS}"

# Podman のインストール確認
if ! command -v podman > /dev/null 2>&1; then
    echo "Error: podman がインストールされていません。"
    echo "  macOS: brew install podman"
    echo "  Ubuntu/Debian: sudo apt install podman"
    echo "  Fedora: sudo dnf install podman"
    exit 1
fi

# Podman machine の起動確認 (macOS ホストのみ)
if [[ "$(uname)" == "Darwin" ]]; then
    if ! podman info > /dev/null 2>&1; then
        echo "==> Podman machine を起動しています..."
        podman machine start
    fi
fi

echo "=================================================="
if [ -n "$MOCK_OS" ]; then
    echo " OS: $OS  [擬似テスト / MOCK_OS=$MOCK_OS]"
    echo " ベースイメージ: $BASE_IMAGE (Linux コンテナ内で OS をモック)"
else
    echo " OS: $OS  ($BASE_IMAGE)"
fi
echo " RUN_INIT: $RUN_INIT"
echo "=================================================="
echo ""

echo "==> イメージをビルド中..."
podman build \
    --build-arg BASE_IMAGE="$BASE_IMAGE" \
    --build-arg DISTRO="ubuntu" \
    --build-arg RUN_INIT="$RUN_INIT" \
    --build-arg MOCK_OS="$MOCK_OS" \
    -t "$IMAGE_NAME" \
    -f "$DOTPATH/Containerfile" \
    "$DOTPATH"

echo ""
echo "==> コンテナテストを実行中..."
podman run --rm \
    --name "dotfiles-test-${OS}-$$" \
    "$IMAGE_NAME"

echo ""
echo "==> テスト完了 ($OS)"
