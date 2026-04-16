#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

# パッケージマネージャーのテスト
unit1() {
    e_header "パッケージマネージャーのテスト"

    local package_manager=""

    if command -v apt-get &> /dev/null; then
        package_manager="apt"
        e_success "apt-get が検出されました"
    elif command -v dnf &> /dev/null; then
        package_manager="dnf"
        e_success "dnf が検出されました"
    elif command -v pacman >/dev/null 2>&1; then
        package_manager="pacman"
        e_success "pacman が検出されました"
    else
        e_failure "サポートされているパッケージマネージャーが見つかりません"
        ERR=1
        return
    fi

    # パッケージマネージャーの基本的な動作確認
    case "$package_manager" in
        "apt")
            if apt-get --version >/dev/null 2>&1; then
                e_success "apt-get が正常に動作します"
            else
                e_failure "apt-get が正常に動作しません"
                ERR=1
            fi
            ;;
        "dnf")
            if dnf --version >/dev/null 2>&1; then
                e_success "dnf が正常に動作します"
            else
                e_failure "dnf が正常に動作しません"
                ERR=1
            fi
            ;;
        "pacman")
            if pacman --version >/dev/null 2>&1; then
                e_success "pacman が正常に動作します"
            else
                e_failure "pacman が正常に動作しません"
                ERR=1
            fi
            ;;
    esac
}

# 初期化スクリプトの存在確認（全スクリプト）
unit2() {
    e_header "Linuxセットアップスクリプトの存在確認"

    local scripts=(
        "$DOTPATH/etc/init/linux/10_install.sh"
        "$DOTPATH/etc/init/linux/20_mise.sh"
        "$DOTPATH/etc/init/linux/30_zsh.sh"
        "$DOTPATH/etc/init/linux/40_settings.sh"
    )
    local missing=0

    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            e_success "スクリプトが存在します: $(basename "$script")"
        else
            e_failure "スクリプトが存在しません: $script"
            missing=$((missing + 1))
            ERR=1
        fi
    done

    if [ "$missing" -eq 0 ]; then
        e_success "すべてのセットアップスクリプトが存在します"
    fi
}

# 構文チェック
unit3() {
    e_header "Linuxセットアップスクリプトの構文チェック"

    local scripts=(
        "$DOTPATH/etc/init/linux/10_install.sh"
        "$DOTPATH/etc/init/linux/20_mise.sh"
        "$DOTPATH/etc/init/linux/30_zsh.sh"
        "$DOTPATH/etc/init/linux/40_settings.sh"
    )

    for script in "${scripts[@]}"; do
        if [ ! -f "$script" ]; then
            e_warning "スキップ (見つかりません): $(basename "$script")"
            continue
        fi
        if bash -n "$script" 2>/dev/null; then
            e_success "構文OK: $(basename "$script")"
        else
            e_failure "構文エラー: $script"
            bash -n "$script"
            ERR=1
        fi
    done
}

# 開発ツールの確認
unit4() {
    e_header "開発ツールの確認"

    local tools=("git" "curl" "wget")
    local missing_tools=0

    for tool in "${tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            e_success "$tool がインストールされています"
        else
            e_warning "$tool がインストールされていません"
            missing_tools=$((missing_tools + 1))
        fi
    done

    if [ "$missing_tools" -eq 0 ]; then
        e_success "すべての基本ツールがインストールされています"
    else
        e_warning "$missing_tools 個のツールがインストールされていません"
    fi
}

# システムユーティリティの確認
unit5() {
    e_header "システムユーティリティの確認"

    local utils=("tmux" "zsh")
    local missing_utils=0

    for util in "${utils[@]}"; do
        if command -v "$util" >/dev/null 2>&1; then
            e_success "$util がインストールされています"
        else
            e_warning "$util がインストールされていません"
            missing_utils=$((missing_utils + 1))
        fi
    done

    if [ "$missing_utils" -eq 0 ]; then
        e_success "すべてのシステムユーティリティがインストールされています"
    else
        e_warning "$missing_utils 個のシステムユーティリティがインストールされていません"
    fi
}

# メイン処理
main() {
    unit1
    unit2
    unit3
    unit4
    unit5

    if [ "$ERR" -eq 0 ]; then
        e_success "すべてのLinuxインストールテストが成功しました"
    else
        e_failure "一部のLinuxインストールテストが失敗しました"
    fi

    return "$ERR"
}

# メイン処理の実行
main
