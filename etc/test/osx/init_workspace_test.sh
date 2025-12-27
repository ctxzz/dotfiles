#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

# ワークスペースセットアップスクリプトの存在確認
unit1() {
    e_header "ワークスペースセットアップスクリプトの存在確認"
    
    if [ -f "$DOTPATH/etc/init/ws_setup.sh" ]; then
        e_success "ws_setup.sh が存在します"
    else
        e_failure "ws_setup.sh が見つかりません"
        ERR=1
        return
    fi
    
    # スクリプトの実行権限確認
    if [ -x "$DOTPATH/etc/init/ws_setup.sh" ]; then
        e_success "ws_setup.sh に実行権限があります"
    else
        e_warning "ws_setup.sh に実行権限がありません"
    fi
}

# ワークスペースセットアップスクリプトの構文チェック
unit2() {
    e_header "ワークスペースセットアップスクリプトの構文チェック"
    
    if [ ! -f "$DOTPATH/etc/init/ws_setup.sh" ]; then
        e_warning "ws_setup.sh が見つからないためスキップします"
        return
    fi
    
    if bash -n "$DOTPATH/etc/init/ws_setup.sh" 2>/dev/null; then
        e_success "ws_setup.sh の構文チェックが成功しました"
    else
        e_failure "ws_setup.sh の構文エラーがあります"
        bash -n "$DOTPATH/etc/init/ws_setup.sh"
        ERR=1
    fi
}

# ワークスペースディレクトリ構造のテスト（モック環境）
unit3() {
    e_header "ワークスペースディレクトリ構造のテスト（モック環境）"
    
    if [ ! -f "$DOTPATH/etc/init/ws_setup.sh" ]; then
        e_warning "ws_setup.sh が見つからないためスキップします"
        return
    fi
    
    # テスト用の一時ディレクトリを作成
    local test_home="/tmp/ws_test_$$"
    mkdir -p "$test_home"
    
    # モック環境でスクリプトを実行
    e_header "モック環境でスクリプトを実行中..."
    local output
    if output=$(HOME="$test_home" bash "$DOTPATH/etc/init/ws_setup.sh" 2>&1); then
        e_success "スクリプトが正常に実行されました"
        
        # 基本ディレクトリの確認
        if [ -d "$test_home/ws/local" ]; then
            e_success "~/ws/local が作成されました"
        else
            e_failure "~/ws/local が作成されていません"
            echo "Script output:" >&2
            echo "$output" >&2
            ERR=1
        fi
        
        if [ -d "$test_home/ws/local/sandbox" ]; then
            e_success "~/ws/local/sandbox が作成されました"
        else
            e_failure "~/ws/local/sandbox が作成されていません"
            ERR=1
        fi
        
        if [ -d "$test_home/ws/local/work" ]; then
            e_success "~/ws/local/work が作成されました"
        else
            e_failure "~/ws/local/work が作成されていません"
            ERR=1
        fi
        
        if [ -d "$test_home/Cloud" ]; then
            e_success "~/Cloud が作成されました"
        else
            e_failure "~/Cloud が作成されていません"
            ERR=1
        fi
    else
        e_failure "スクリプトの実行に失敗しました"
        echo "Script output:" >&2
        echo "$output" >&2
        ERR=1
    fi
    
    # クリーンアップ
    rm -rf "$test_home"
    e_success "テスト環境をクリーンアップしました"
}

# Google Drive検出関数のテスト（モック環境）
unit4() {
    e_header "Google Drive検出関数のテスト（モック環境）"
    
    if [ ! -f "$DOTPATH/etc/init/ws_setup.sh" ]; then
        e_warning "ws_setup.sh が見つからないためスキップします"
        return
    fi
    
    # Google Drive detection pattern (matches the pattern in ws_setup.sh)
    local gd_pattern="GoogleDrive-omata"
    local test_email="${gd_pattern}@example.com"
    
    # テスト用の一時ディレクトリを作成
    local test_home="/tmp/ws_test_gd_$$"
    mkdir -p "$test_home/Library/CloudStorage/${test_email}/My Drive/03slide"
    mkdir -p "$test_home/Library/CloudStorage/${test_email}/My Drive/02thesis"
    mkdir -p "$test_home/Library/CloudStorage/${test_email}/My Drive/06note"
    
    # Google Driveがある環境でスクリプトを実行
    e_header "Google Driveモック環境でスクリプトを実行中..."
    local output
    if output=$(HOME="$test_home" bash "$DOTPATH/etc/init/ws_setup.sh" 2>&1); then
        e_success "Google Drive環境でスクリプトが正常に実行されました"
        
        # シンボリックリンクの存在と正しいターゲットの確認
        if [ -L "$test_home/Cloud/GoogleDrive" ]; then
            local target
            target=$(readlink "$test_home/Cloud/GoogleDrive")
            local expected="$test_home/Library/CloudStorage/${test_email}"
            if [ "$target" = "$expected" ]; then
                e_success "~/Cloud/GoogleDrive シンボリックリンクが正しいターゲットを指しています"
            else
                e_failure "~/Cloud/GoogleDrive のターゲットが不正です: $target (期待値: $expected)"
                ERR=1
            fi
        else
            e_warning "~/Cloud/GoogleDrive シンボリックリンクが作成されていません"
        fi
        
        if [ -L "$test_home/ws/slide" ]; then
            local target
            target=$(readlink "$test_home/ws/slide")
            local expected="$test_home/Cloud/GoogleDrive/My Drive/03slide"
            if [ "$target" = "$expected" ]; then
                e_success "~/ws/slide シンボリックリンクが正しいターゲットを指しています"
            else
                e_failure "~/ws/slide のターゲットが不正です: $target (期待値: $expected)"
                ERR=1
            fi
        else
            e_warning "~/ws/slide シンボリックリンクが作成されていません"
        fi
    else
        e_failure "Google Drive環境でスクリプトの実行に失敗しました"
        echo "Script output:" >&2
        echo "$output" >&2
        ERR=1
    fi
    
    # クリーンアップ
    rm -rf "$test_home"
    e_success "テスト環境をクリーンアップしました"
}

# 冪等性のテスト（複数回実行）
unit5() {
    e_header "冪等性のテスト（複数回実行）"
    
    if [ ! -f "$DOTPATH/etc/init/ws_setup.sh" ]; then
        e_warning "ws_setup.sh が見つからないためスキップします"
        return
    fi
    
    # テスト用の一時ディレクトリを作成
    local test_home="/tmp/ws_test_idem_$$"
    mkdir -p "$test_home"
    
    # 1回目の実行
    if HOME="$test_home" bash "$DOTPATH/etc/init/ws_setup.sh" >/dev/null 2>&1; then
        e_success "1回目の実行が成功しました"
    else
        e_failure "1回目の実行に失敗しました"
        rm -rf "$test_home"
        ERR=1
        return
    fi
    
    # 2回目の実行（冪等性の確認）
    if HOME="$test_home" bash "$DOTPATH/etc/init/ws_setup.sh" >/dev/null 2>&1; then
        e_success "2回目の実行が成功しました（冪等性が確認されました）"
    else
        e_failure "2回目の実行に失敗しました（冪等性がありません）"
        ERR=1
    fi
    
    # クリーンアップ
    rm -rf "$test_home"
    e_success "テスト環境をクリーンアップしました"
}

# 30_workspace.shの存在確認
unit6() {
    e_header "30_workspace.sh の存在確認"
    
    if [ -f "$DOTPATH/etc/init/osx/30_workspace.sh" ]; then
        e_success "30_workspace.sh が存在します"
        
        # 構文チェック
        if bash -n "$DOTPATH/etc/init/osx/30_workspace.sh" 2>/dev/null; then
            e_success "30_workspace.sh の構文チェックが成功しました"
        else
            e_failure "30_workspace.sh の構文エラーがあります"
            ERR=1
        fi
    else
        e_failure "30_workspace.sh が見つかりません"
        ERR=1
    fi
}

# メイン処理
main() {
    unit1
    unit2
    unit3
    unit4
    unit5
    unit6
    
    if [ "$ERR" -eq 0 ]; then
        e_success "すべてのワークスペーステストが成功しました"
    else
        e_failure "一部のワークスペーステストが失敗しました"
    fi
    
    return "$ERR"
}

# メイン処理の実行
main
