#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

# 設定スクリプトの存在確認
unit1() {
    e_header "Windows設定スクリプトの存在確認"

    local script="$DOTPATH/etc/init/win/30_settings.ps1"
    if [ -f "$script" ]; then
        e_success "設定スクリプトが存在します: $(basename "$script")"
    else
        e_failure "設定スクリプトが存在しません: $script"
        ERR=1
    fi
}

# ワークスペースディレクトリの確認（設定実行後）
unit2() {
    e_header "ワークスペースディレクトリの確認"

    # On Windows via msys/Git Bash, $HOME maps to the Windows user profile
    local ws_dirs=("$HOME/ws/local/sandbox" "$HOME/ws/local/work")
    local missing=0

    for dir in "${ws_dirs[@]}"; do
        if [ -d "$dir" ]; then
            e_success "$dir が存在します"
        else
            e_warning "$dir が存在しません（30_settings.ps1 実行後に作成されます）"
            missing=$((missing + 1))
        fi
    done

    if [ "$missing" -eq 0 ]; then
        e_success "ワークスペースディレクトリが正しく設定されています"
    fi
}

# Windowsレジストリ設定の確認（msys/Git Bash 環境のみ）
unit3() {
    e_header "Windowsレジストリ設定の確認"

    if ! has "reg"; then
        e_warning "reg コマンドが見つかりません — レジストリチェックをスキップします"
        return
    fi

    # Explorer: hidden files setting
    local hidden_val
    hidden_val=$(reg query \
        "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced" \
        /v Hidden 2>/dev/null | grep -o "0x[0-9]*" | head -1 || echo "")
    if [ "$hidden_val" = "0x1" ]; then
        e_success "隠しファイル表示が有効になっています"
    else
        e_warning "隠しファイル表示設定が未適用です（30_settings.ps1 実行後に確認してください）"
    fi

    # Explorer: file extensions
    local ext_val
    ext_val=$(reg query \
        "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced" \
        /v HideFileExt 2>/dev/null | grep -o "0x[0-9]*" | head -1 || echo "")
    if [ "$ext_val" = "0x0" ]; then
        e_success "ファイル拡張子の表示が有効になっています"
    else
        e_warning "ファイル拡張子表示設定が未適用です（30_settings.ps1 実行後に確認してください）"
    fi
}

# メイン処理
main() {
    unit1
    unit2
    unit3

    if [ "$ERR" -eq 0 ]; then
        e_success "すべてのWindows設定テストが成功しました"
    else
        e_failure "一部のWindows設定テストが失敗しました"
    fi
}

# メイン処理の実行
main
exit "$ERR"
