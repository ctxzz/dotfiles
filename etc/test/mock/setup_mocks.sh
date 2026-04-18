#!/bin/bash
# コンテナ内で OS モックを /usr/local/bin に配置するセットアップスクリプト
# 引数: MOCK_OS (macos | windows)

set -eu

MOCK_OS="${1:-}"
MOCK_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN=/usr/local/bin

case "$MOCK_OS" in
    macos)
        echo "[mock] macOS (Darwin) 環境をセットアップします"

        # uname を Darwin を返すようにモック
        cat > "$BIN/uname" <<'EOF'
#!/bin/bash
case "${1:-}" in
    ""|"-s") echo "Darwin" ;;
    *)       exec "$(command -v uname 2>/dev/null || echo /bin/uname)" "$@" ;;
esac
EOF
        chmod +x "$BIN/uname"

        # brew モックをインストール
        install -m 755 "$MOCK_DIR/brew" "$BIN/brew"

        echo "[mock] 配置済み: uname (Darwin), brew"
        ;;

    windows)
        echo "[mock] Windows (MSYS_NT) 環境をセットアップします"

        # uname を MSYS_NT を返すようにモック
        cat > "$BIN/uname" <<'EOF'
#!/bin/bash
case "${1:-}" in
    ""|"-s") echo "MSYS_NT-10.0" ;;
    *)       exec "$(command -v uname 2>/dev/null || echo /bin/uname)" "$@" ;;
esac
EOF
        chmod +x "$BIN/uname"

        echo "[mock] 配置済み: uname (MSYS_NT-10.0)"
        ;;

    "")
        echo "[mock] MOCK_OS 未指定 — モックなしで続行"
        ;;

    *)
        echo "[mock] 未知の MOCK_OS: '$MOCK_OS'" >&2
        exit 1
        ;;
esac
