#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

# DOTPATHが未設定の場合はスクリプトのパスから推測
if [ -z "$DOTPATH" ]; then
    DOTPATH=$(cd "$(dirname "$0")"/../.. && pwd)
    export DOTPATH
fi

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

# zsh が無い環境ではスキップ（mosh/tmux 関連は zsh 関数のため）
if ! has zsh; then
    e_warning "zsh が無いため mosh テストをスキップします"
    exit 0
fi

FUNCS="$DOTPATH/.zsh/10_functions.zsh"

# bash から zsh 関数 _is_mosh_proc を実行し、終了コードを返す
# （assert_true/assert_false に "$@" 経由で渡すため shellcheck からは間接呼び出し）
# shellcheck disable=SC2317
is_mosh_proc() {
    zsh -c 'source "$1"; _is_mosh_proc "$2"' _ "$FUNCS" "$1"
}

assert_true() {
    local desc="$1"; shift
    if "$@"; then
        e_success "$desc"
    else
        e_failure "$desc"
        ERR=1
    fi
}

assert_false() {
    local desc="$1"; shift
    if "$@"; then
        e_failure "$desc"
        ERR=1
    else
        e_success "$desc"
    fi
}

# mosh-server を示すコマンド名は真と判定される（basename / フルパス両対応）
unit1() {
    e_header "_is_mosh_proc: mosh-server を検出する"
    assert_true  "basename 'mosh-server' を検出"        is_mosh_proc "mosh-server"
    assert_true  "フルパスの mosh-server を検出"         is_mosh_proc "/opt/homebrew/bin/mosh-server"
    assert_true  "引数付き mosh-server を検出"           is_mosh_proc "mosh-server new -s"
}

# mosh 以外のプロセス名は偽と判定される（誤発動しない）
unit2() {
    e_header "_is_mosh_proc: mosh 以外では発動しない"
    assert_false "zsh では発動しない"                    is_mosh_proc "zsh"
    assert_false "sshd では発動しない"                   is_mosh_proc "sshd"
    assert_false "login では発動しない"                  is_mosh_proc "login"
    assert_false "空文字では発動しない"                  is_mosh_proc ""
}

# 非対話シェルでは _mosh_tmux_autoattach は何もしない（exec しない）。
# exec されると後続の echo に到達しないことを利用して検証する。
unit3() {
    e_header "_mosh_tmux_autoattach: 非対話では no-op（exec しない）"
    local out
    out="$(zsh -c 'source "$1"; _mosh_tmux_autoattach; echo REACHED' _ "$FUNCS" 2>/dev/null)"
    if [ "$out" = "REACHED" ]; then
        e_success "非対話シェルでは tmux に exec せず処理が継続する"
    else
        e_failure "非対話シェルで exec された/到達できなかった (out=$out)"
        ERR=1
    fi
}

# メイン処理
main() {
    unit1
    unit2
    unit3

    if [ "$ERR" -eq 0 ]; then
        e_success "すべての mosh テストが成功しました"
    else
        e_failure "一部の mosh テストが失敗しました"
    fi
}

main
exit "$ERR"
