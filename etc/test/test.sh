#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

# DOTPATHが設定されていない場合は、スクリプトのパスから推測
if [ -z "$DOTPATH" ]; then
    DOTPATH=$(cd $(dirname $0)/../.. && pwd)
    export DOTPATH
fi

. "$DOTPATH/etc/lib/vital.sh"

ERR=0
export ERR
#
# -- END

# テスト結果のレポート
report_test() {
    local test_name="$1"
    local status="$2"
    local message="$3"
    
    case "$status" in
        "success")
            e_success "$test_name: $message"
            ;;
        "failure")
            e_failure "$test_name: $message"
            ERR=1
            ;;
        "skip")
            e_warning "$test_name: $message"
            ;;
    esac
}

# テストの実行
run_test() {
    local test_file="$1"
    local test_name="$(basename "$test_file")"
    
    echo -n "テスト実行中: $test_name... "
    
    if [ ! -x "$test_file" ]; then
        echo "スキップ (実行権限がありません)"
        report_test "$test_name" "skip" "実行権限がありません"
        return
    fi
    
    if bash "$test_file"; then
        echo "成功"
        report_test "$test_name" "success" "テストが成功しました"
    else
        echo "失敗"
        report_test "$test_name" "failure" "テストが失敗しました"
    fi
}

# メインのテスト実行
main() {
    local test_files=()
    local os_specific_tests=()
    
    # 共通テストの収集
    echo "共通テストを収集中..."
    for i in "$DOTPATH"/etc/test/*_test.sh; do
        test_files+=("$i")
        echo "  - $(basename "$i")"
    done
    
    # OS固有のテストの収集
    if [ -n "$(get_os)" ]; then
        echo "$(get_os)固有のテストを収集中..."
        for i in "$DOTPATH"/etc/test/"$(get_os)"/*_test.sh; do
            [ -f "$i" ] && os_specific_tests+=("$i")
            echo "  - $(basename "$i")"
        done
    fi
    
    # テストの実行
    e_header "共通テストの実行"
    for test_file in "${test_files[@]}"; do
        run_test "$test_file"
    done
    
    if [ ${#os_specific_tests[@]} -gt 0 ]; then
        e_header "$(get_os)固有のテストの実行"
        for test_file in "${os_specific_tests[@]}"; do
            run_test "$test_file"
        done
    fi
    
    # テスト結果の集計
    local n_unit=$(find "$DOTPATH"/etc/test -name "*_test.sh" | xargs grep "^unit[0-9]$" | wc -l | sed "s/ //g")
    local n_file=$(find "$DOTPATH"/etc/test -name "*_test.sh" | wc -l | sed "s/ //g")
    
    e_header "テスト結果の集計"
    echo "テストファイル数: $n_file"
    echo "テストケース数: $n_unit"
    echo "エラー数: $ERR"
    
    [ "$ERR" = 0 ] && e_success "すべてのテストが成功しました" || e_failure "一部のテストが失敗しました"
    return "$ERR"
}

# メイン処理の実行
main
