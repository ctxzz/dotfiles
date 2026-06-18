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

# zsh が無い環境ではスキップ（ob 系は zsh 関数のため）
if ! has zsh; then
    e_warning "zsh が無いため ob テストをスキップします"
    exit 0
fi

FUNCS="$DOTPATH/.zsh/10_functions.zsh"
DATE="$(date +%Y%m%d)"
VAULT=""

# 偽の Vault を構築
setup_vault() {
    VAULT="$(mktemp -d)"
    mkdir -p \
        "$VAULT/00_Inbox" \
        "$VAULT/10_Memo/11_Meetings" \
        "$VAULT/10_Memo/12_Events" \
        "$VAULT/10_Memo/13_Lectures" \
        "$VAULT/10_Memo/14_Workshops" \
        "$VAULT/10_Memo/19_Misc" \
        "$VAULT/20_Note/21_Projects" \
        "$VAULT/20_Note/22_Research" \
        "$VAULT/99_Archive" \
        "$VAULT/System/Templates"
    printf 'QUICK_TEMPLATE_MARKER\n'    > "$VAULT/System/Templates/Quick.md"
    printf 'MEETINGS_TEMPLATE_MARKER\n' > "$VAULT/System/Templates/Meetings.md"
}

teardown_vault() {
    [ -n "$VAULT" ] && [ -d "$VAULT" ] && rm -rf "$VAULT"
    VAULT=""
}

# bash から zsh 関数 _ob_new を実行（エディタ起動・プロンプトは抑止）
ob_new() {
    OBSIDIAN_VAULT="$VAULT" EDITOR=true zsh -c '
        source "$1"
        _ob_new "$2" "$3"
    ' _ "$FUNCS" "$1" "$2"
}

# bash から _ob_notebooks を実行
ob_notebooks() {
    OBSIDIAN_VAULT="$VAULT" zsh -c 'source "$1"; _ob_notebooks' _ "$FUNCS"
}

assert_file() {
    local path="$1" desc="$2"
    if [ -f "$path" ]; then
        e_success "$desc: $(basename "$path")"
    else
        e_failure "$desc: 期待したファイルが無い ($path)"
        ERR=1
    fi
}

assert_no_file() {
    local path="$1" desc="$2"
    if [ ! -f "$path" ]; then
        e_success "$desc"
    else
        e_failure "$desc: 想定外のファイルが存在 ($path)"
        ERR=1
    fi
}

# 10_Memo 配下とエイリアスは日付付き＋テンプレ解決
unit1() {
    e_header "10_Memo: エイリアス解決・日付プレフィックス・テンプレート"
    setup_vault
    ob_new meeting "週次MTG"
    local f="$VAULT/10_Memo/11_Meetings/${DATE}_週次mtg.md"
    assert_file "$f" "meeting は日付付きで作成される"
    if [ -f "$f" ] && grep -q MEETINGS_TEMPLATE_MARKER "$f"; then
        e_success "Meetings.md テンプレートが適用される"
    else
        e_failure "Meetings.md テンプレートが適用されていない"
        ERR=1
    fi
    teardown_vault
}

# 00_Inbox は日付付き
unit2() {
    e_header "00_Inbox: 日付プレフィックス付き"
    setup_vault
    ob_new inbox "メモ"
    assert_file "$VAULT/00_Inbox/${DATE}_メモ.md" "inbox は日付付きで作成される"
    teardown_vault
}

# 20_Note 配下は日付なし（名前一致で解決）＋テンプレは Quick.md にフォールバック
unit3() {
    e_header "20_Note: 日付なし・名前解決・テンプレフォールバック"
    setup_vault
    ob_new research "量子計算"
    local dated="$VAULT/20_Note/22_Research/${DATE}_量子計算.md"
    local plain="$VAULT/20_Note/22_Research/量子計算.md"
    assert_file "$plain" "research は日付なしで作成される"
    assert_no_file "$dated" "research に日付は付かない"
    if [ -f "$plain" ] && grep -q QUICK_TEMPLATE_MARKER "$plain"; then
        e_success "専用テンプレ不在時は Quick.md にフォールバックする"
    else
        e_failure "Quick.md フォールバックが効いていない"
        ERR=1
    fi
    teardown_vault
}

# 99_Archive も日付なし。番号接頭辞を除いた名前(大小無視)で解決できる
unit4() {
    e_header "99_Archive / 番号接頭辞を除いた名前での解決"
    setup_vault
    ob_new archive "古いメモ"
    assert_file "$VAULT/99_Archive/古いメモ.md" "archive は日付なしで作成される"
    ob_new projects "新規PJ"
    assert_file "$VAULT/20_Note/21_Projects/新規pj.md" "projects -> 21_Projects に解決される"
    teardown_vault
}

# _ob_notebooks はリーフのみ列挙し、System と中間フォルダを除外する
unit5() {
    e_header "_ob_notebooks: リーフフォルダ列挙"
    setup_vault
    local out
    out="$(ob_notebooks)"
    if contains "$out" "10_Memo/11_Meetings" && contains "$out" "20_Note/22_Research" && contains "$out" "00_Inbox"; then
        e_success "リーフのノートブックが列挙される"
    else
        e_failure "リーフのノートブックが列挙されない"
        ERR=1
    fi
    if contains "$out" "System"; then
        e_failure "System 配下が除外されていない"
        ERR=1
    else
        e_success "System 配下は除外される"
    fi
    # 中間フォルダ(サブフォルダを持つ)は含めない
    if printf '%s\n' "$out" | grep -qx "10_Memo"; then
        e_failure "中間フォルダ 10_Memo が除外されていない"
        ERR=1
    else
        e_success "中間フォルダ(10_Memo)は除外される"
    fi
    teardown_vault
}

# メイン処理
main() {
    unit1
    unit2
    unit3
    unit4
    unit5

    if [ "$ERR" -eq 0 ]; then
        e_success "すべての ob テストが成功しました"
    else
        e_failure "一部の ob テストが失敗しました"
    fi
}

main
exit "$ERR"
