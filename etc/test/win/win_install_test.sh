#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

# インストールスクリプトの存在確認
unit1() {
    e_header "Windowsインストールスクリプトの存在確認"

    local scripts=(
        "$DOTPATH/etc/init/win/10_install.ps1"
        "$DOTPATH/etc/init/win/20_mise.ps1"
        "$DOTPATH/etc/init/win/30_settings.ps1"
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
        e_success "すべてのWindowsセットアップスクリプトが存在します"
    fi
}

# PowerShellスクリプトの基本構文チェック（pwsh が利用可能な場合）
unit2() {
    e_header "PowerShellスクリプトの構文チェック"

    local pwsh=""
    if has "pwsh"; then
        pwsh="pwsh"
    elif has "powershell.exe"; then
        pwsh="powershell.exe"
    else
        e_warning "PowerShell が見つかりません — 構文チェックをスキップします"
        return
    fi

    local scripts=(
        "$DOTPATH/etc/init/win/10_install.ps1"
        "$DOTPATH/etc/init/win/20_mise.ps1"
        "$DOTPATH/etc/init/win/30_settings.ps1"
    )

    for script in "${scripts[@]}"; do
        if [ ! -f "$script" ]; then
            e_warning "スキップ (見つかりません): $(basename "$script")"
            continue
        fi
        if "$pwsh" -NoProfile -NonInteractive -Command "
            \$errors = \$null
            \$null = [System.Management.Automation.Language.Parser]::ParseFile(
                '$script', [ref]\$null, [ref]\$errors)
            exit \$errors.Count
        " 2>/dev/null; then
            e_success "構文OK: $(basename "$script")"
        else
            e_failure "構文エラー: $(basename "$script")"
            ERR=1
        fi
    done
}

# winget / Chocolatey の利用可能性確認
unit3() {
    e_header "パッケージマネージャーの確認"

    if has "winget"; then
        e_success "winget が利用可能です"
        winget --version 2>/dev/null || true
    elif has "choco"; then
        e_success "Chocolatey が利用可能です"
        choco --version 2>/dev/null || true
    else
        e_warning "winget / Chocolatey が見つかりません（インストール後に再確認してください）"
    fi
}

# メイン処理
main() {
    unit1
    unit2
    unit3

    if [ "$ERR" -eq 0 ]; then
        e_success "すべてのWindowsインストールテストが成功しました"
    else
        e_failure "一部のWindowsインストールテストが失敗しました"
    fi

    return "$ERR"
}

# メイン処理の実行
main
