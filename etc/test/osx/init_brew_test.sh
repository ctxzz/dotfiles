#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

# Homebrewのテスト
unit1() {
    e_header "Homebrewのテスト"
    
    # Homebrewのインストール確認
    if command -v brew >/dev/null 2>&1; then
        e_success "Homebrewがインストールされています"
        
        # Homebrewのバージョン確認
        local brew_version
        brew_version=$(brew --version | head -n 1)
        e_success "Homebrewバージョン: $brew_version"
        
        # brew doctorの実行
        e_header "brew doctorの実行"
        if brew doctor >/dev/null 2>&1; then
            e_success "brew doctorが正常に終了しました"
        else
            e_warning "brew doctorで警告があります"
            brew doctor
        fi
        
        # 主要なbrewコマンドの動作確認
        if brew --prefix >/dev/null 2>&1; then
            e_success "brew --prefixが正常に動作します"
        else
            e_failure "brew --prefixが正常に動作しません"
            ERR=1
        fi
        
        if brew --cellar >/dev/null 2>&1; then
            e_success "brew --cellarが正常に動作します"
        else
            e_failure "brew --cellarが正常に動作しません"
            ERR=1
        fi
        
        # インストール済みパッケージの確認
        e_header "インストール済みパッケージの確認"
        local installed_packages
        installed_packages=$(brew list)
        if [ -n "$installed_packages" ]; then
            e_success "インストール済みパッケージがあります"
            echo "$installed_packages"
        else
            e_warning "インストール済みパッケージがありません"
        fi
        
        # キャッシュの確認
        e_header "キャッシュの確認"
        if brew cleanup -n >/dev/null 2>&1; then
            e_success "キャッシュの状態が正常です"
        else
            e_warning "キャッシュに問題があります"
            brew cleanup -n
        fi
    else
        e_failure "Homebrewがインストールされていません"
        ERR=1
    fi
}

# メイン処理
main() {
    unit1
    
    if [ "$ERR" -eq 0 ]; then
        e_success "すべてのHomebrewテストが成功しました"
    else
        e_failure "一部のHomebrewテストが失敗しました"
    fi
    
    return "$ERR"
}

# メイン処理の実行
main

