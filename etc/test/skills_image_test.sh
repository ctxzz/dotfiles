#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

# 画像スキル（gen-image / review-image）のスモークテスト
unit1() {
    e_header "画像スキルのスモークテスト"

    if ! command -v python3 >/dev/null 2>&1; then
        e_warning "python3 が無いためスキップします"
        return
    fi

    if DOTPATH="$DOTPATH" python3 "$DOTPATH/etc/test/skills_image_check.py"; then
        e_success "画像スキルのスモークテストが成功しました"
    else
        e_failure "画像スキルのスモークテストが失敗しました"
        ERR=1
    fi
}

# テストの実行
main() {
    unit1

    if [ "$ERR" -eq 0 ]; then
        e_success "すべての画像スキルテストが成功しました"
    else
        e_failure "一部の画像スキルテストが失敗しました"
    fi
}

main
exit "$ERR"
