#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

# miseスクリプトの存在・構文確認
unit1() {
    e_header "Windows mise スクリプトの存在確認"

    local script="$DOTPATH/etc/init/win/20_mise.ps1"
    if [ -f "$script" ]; then
        e_success "スクリプトが存在します: $(basename "$script")"
    else
        e_failure "スクリプトが存在しません: $script"
        ERR=1
        return
    fi
}

# miseコマンドの確認
unit2() {
    e_header "mise の確認"

    if has "mise"; then
        e_success "mise が利用可能です"
        mise --version 2>/dev/null || true
    else
        e_warning "mise がインストールされていません（20_mise.ps1 実行後に確認してください）"
    fi
}

# Node.js の確認
unit3() {
    e_header "Node.js の確認"

    if has "node"; then
        local node_version
        node_version=$(node --version 2>/dev/null || echo "unknown")
        e_success "Node.js が利用可能です: $node_version"
    else
        e_warning "Node.js がインストールされていません（20_mise.ps1 実行後に確認してください）"
    fi
}

# npm / ni の確認
unit4() {
    e_header "npm / ni の確認"

    if has "npm"; then
        local npm_version
        npm_version=$(npm --version 2>/dev/null || echo "unknown")
        e_success "npm が利用可能です: $npm_version"
    else
        e_warning "npm が見つかりません"
    fi

    if has "ni"; then
        e_success "ni が利用可能です"
    else
        e_warning "ni がインストールされていません（20_mise.ps1 実行後に確認してください）"
    fi
}

# メイン処理
main() {
    unit1
    unit2
    unit3
    unit4

    if [ "$ERR" -eq 0 ]; then
        e_success "すべてのWindows mise テストが成功しました"
    else
        e_failure "一部のWindows mise テストが失敗しました"
    fi

    return "$ERR"
}

# メイン処理の実行
main
