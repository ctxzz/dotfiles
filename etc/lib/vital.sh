#!/bin/bash

# 色の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# コマンドの存在確認
has() {
    type "$1" > /dev/null 2>&1
}

# 文字列に指定された部分文字列が含まれているか確認
contains() {
    [[ "$1" == *"$2"* ]]
}

# ログ出力関数
e_header() {
    printf "\n${BLUE}==>${NC} %s\n" "$1"
}

e_success() {
    printf "${GREEN}✓${NC} %s\n" "$1"
}

e_failure() {
    printf "${RED}✗${NC} %s\n" "$1"
}

e_warning() {
    printf "${YELLOW}!${NC} %s\n" "$1"
}

e_indent() {
    local indent="${1:-4}"
    local pad
    pad="$(printf '%*s' "$indent" '')"
    while IFS= read -r line; do
        printf '%s%s\n' "$pad" "$line"
    done
}

# OS判定関数
ostype() {
    uname | tr '[:upper:]' '[:lower:]'
}

os_detect() {
    export PLATFORM
    case "$(ostype)" in
        *'linux'*)  PLATFORM='linux'   ;;
        *'darwin'*) PLATFORM='osx'     ;;
        *'bsd'*)    PLATFORM='bsd'     ;;
        *'msys'*)   PLATFORM='win'     ;;
        *'cygwin'*) PLATFORM='win'     ;;
        *'mingw'*)  PLATFORM='win'     ;;
        *)          PLATFORM='unknown' ;;
    esac
}

get_os() {
    os_detect
    echo "$PLATFORM"
}

is_osx() {
    [ "$(get_os)" = "osx" ]
}
alias is_mac=is_osx

is_linux() {
    [ "$(get_os)" = "linux" ]
}

is_win() {
    [ "$(get_os)" = "win" ]
}

# 初期化
os_detect 