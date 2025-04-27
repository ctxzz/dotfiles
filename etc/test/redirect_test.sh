#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

# リダイレクトテスト
unit1() {
    e_header "リダイレクトテストの実行"
    
    # dot.omata.me へのアクセステスト
    if curl -fsSL dot.omata.me >/dev/null 2>&1; then
        e_success "dot.omata.me へのアクセスが成功しました"
    else
        e_failure "dot.omata.me へのアクセスに失敗しました"
        ERR=1
        return
    fi
    
    # GitHubとの内容比較
    local github_content
    local dotme_content
    
    github_content=$(wget -qO - raw.githubusercontent.com/ctxzz/dotfiles/master/etc/install)
    dotme_content=$(wget -qO - dot.omata.me)
    
    if diff -qs <(echo "$github_content") <(echo "$dotme_content") | grep -q "identical"; then
        e_success "dot.omata.me の内容が GitHub と一致しています"
    else
        e_failure "dot.omata.me の内容が GitHub と一致しません"
        ERR=1
        
        # 差分の詳細を表示
        e_header "差分の詳細:"
        diff -u <(echo "$github_content") <(echo "$dotme_content") | e_indent 4
    fi
}

# メイン処理
main() {
    unit1
    
    if [ "$ERR" -eq 0 ]; then
        e_success "すべてのリダイレクトテストが成功しました"
    else
        e_failure "一部のリダイレクトテストが失敗しました"
    fi
    
    return "$ERR"
}

# メイン処理の実行
main
