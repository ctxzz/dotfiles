#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

# 初期化スクリプトの存在確認
unit1() {
    e_header "初期化スクリプトの存在確認"

    local settings_script="$DOTPATH/etc/init/linux/40_settings.sh"
    if [ -f "$settings_script" ]; then
        e_success "設定スクリプトが存在します: $settings_script"
    else
        e_failure "設定スクリプトが存在しません: $settings_script"
        ERR=1
    fi
}

# ディレクトリ構造の確認
unit2() {
    e_header "ディレクトリ構造の確認"

    local dirs=("$HOME/.config" "$HOME/.local/share")
    local missing_dirs=0

    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            e_success "$dir が存在します"
        else
            e_warning "$dir が存在しません"
            missing_dirs=$((missing_dirs + 1))
        fi
    done

    if [ "$missing_dirs" -eq 0 ]; then
        e_success "すべての必要なディレクトリが存在します"
    else
        e_warning "$missing_dirs 個のディレクトリが存在しません（設定実行で作成されます）"
    fi
}

# gsettingsの確認（GNOME環境の場合）
unit3() {
    e_header "デスクトップ環境設定ツールの確認"

    if command -v gsettings >/dev/null 2>&1; then
        e_success "gsettings がインストールされています（GNOME環境）"

        # gsettingsの基本的な動作確認
        if gsettings list-schemas >/dev/null 2>&1; then
            e_success "gsettings が正常に動作します"

            # 主要なスキーマの存在確認
            local schemas=(
                "org.gnome.nautilus.preferences"
                "org.gnome.desktop.peripherals.keyboard"
                "org.gnome.desktop.peripherals.mouse"
                "org.gnome.desktop.interface"
            )

            local available_schemas=0
            for schema in "${schemas[@]}"; do
                if gsettings list-schemas | grep -q "^$schema$"; then
                    available_schemas=$((available_schemas + 1))
                fi
            done

            if [ "$available_schemas" -gt 0 ]; then
                e_success "$available_schemas 個のGNOME設定スキーマが利用可能です"
            else
                e_warning "GNOME設定スキーマが見つかりません"
            fi
        else
            e_warning "gsettings が正常に動作しません"
        fi
    else
        e_warning "gsettings がインストールされていません（GNOME環境以外の可能性があります）"
    fi
}

# 設定ファイルの構文確認
unit4() {
    e_header "設定ファイルの構文確認"

    local settings_script="$DOTPATH/etc/init/linux/40_settings.sh"

    if [ -f "$settings_script" ]; then
        # bashの構文チェック
        if bash -n "$settings_script" 2>/dev/null; then
            e_success "設定スクリプトの構文が正しいです"
        else
            e_failure "設定スクリプトに構文エラーがあります"
            bash -n "$settings_script"
            ERR=1
        fi
    fi
}

# ワークスペースディレクトリの確認（設定実行後）
unit5() {
    e_header "ワークスペースディレクトリの確認"

    local ws_dirs=("$HOME/ws/local/sandbox" "$HOME/ws/local/work")
    local missing=0

    for dir in "${ws_dirs[@]}"; do
        if [ -d "$dir" ]; then
            e_success "$dir が存在します"
        else
            e_warning "$dir が存在しません（40_settings.sh 実行後に作成されます）"
            missing=$((missing + 1))
        fi
    done

    if [ "$missing" -eq 0 ]; then
        e_success "ワークスペースディレクトリが正しく設定されています"
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
        e_success "すべてのLinux設定テストが成功しました"
    else
        e_failure "一部のLinux設定テストが失敗しました"
    fi

}

# メイン処理の実行
main
exit "$ERR"
