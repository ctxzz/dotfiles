#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

# バンドルテスト
unit1() {
    e_header "バンドル設定のテスト"
    
    # 初期化スクリプトの存在確認
    local init_script="$DOTPATH/etc/init/osx/20_bundle.sh"
    if [ -f "$init_script" ]; then
        e_success "初期化スクリプトが存在します: $init_script"
        
        # スクリプトの実行権限確認
        if [ -x "$init_script" ]; then
            e_success "初期化スクリプトに実行権限があります"
        else
            e_warning "初期化スクリプトに実行権限がありません"
            chmod +x "$init_script"
            e_success "実行権限を付与しました"
        fi
    else
        e_failure "初期化スクリプトが存在しません: $init_script"
        ERR=1
    fi
    
    # Brewfileの存在確認
    local brewfile="$DOTPATH/etc/init/osx/Brewfile"
    if [ -f "$brewfile" ]; then
        e_success "Brewfileが存在します: $brewfile"
        
        # Brewfileの内容確認
        if [ -s "$brewfile" ]; then
            e_success "Brewfileに内容が含まれています"
            
            # 基本的な構文チェック
            if grep -q "^brew \|^cask \|^tap \|^mas " "$brewfile"; then
                e_success "Brewfileの構文が正しいようです"
            else
                e_warning "Brewfileに有効なコマンドが見つかりません"
            fi
        else
            e_warning "Brewfileが空です"
        fi
    else
        e_failure "Brewfileが存在しません: $brewfile"
        ERR=1
    fi
}

# メイン処理
main() {
    unit1
    
    if [ "$ERR" -eq 0 ]; then
        e_success "すべてのバンドルテストが成功しました"
    else
        e_failure "一部のバンドルテストが失敗しました"
    fi
    
    return "$ERR"
}

# メイン処理の実行
main
