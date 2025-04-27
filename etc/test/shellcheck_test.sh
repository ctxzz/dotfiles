#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: $LINENO: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

# シェルチェックの実行
unit1() {
    if ! has "shellcheck"; then
        e_warning "shellcheck がインストールされていません"
        return
    fi

    # チェック対象のファイル
    local files=()
    files+=("$DOTPATH"/etc/init/*.sh)
    files+=("$DOTPATH"/etc/init/osx/*.sh)
    files+=("$DOTPATH"/etc/init/linux/*.sh)
    files+=("$DOTPATH"/etc/test/*.sh)

    # カスタムルール
    local custom_rules=(
        "-e SC1090"  # Can't follow non-constant source
        "-e SC1091"  # Not following
        "-e SC2006"  # Use $(..) instead of legacy `..`
        "-e SC2086"  # Double quote to prevent globbing and word splitting
        "-e SC2155"  # Declare and assign separately to avoid masking return values
    )

    e_header "シェルスクリプトのチェックを開始します"

    local total_files=0
    local error_files=0
    local warning_files=0

    for file in "${files[@]}"; do
        if [ ! -f "$file" ]; then
            continue
        fi

        total_files=$((total_files + 1))
        local output
        output=$(shellcheck "${custom_rules[@]}" "$file" 2>&1)

        if [ $? -eq 0 ]; then
            e_success "$file" | e_indent
        else
            if [[ "$output" == *"warning"* ]]; then
                e_warning "$file" | e_indent
                warning_files=$((warning_files + 1))
            else
                e_failure "$file" | e_indent
                error_files=$((error_files + 1))
                ERR=1
            fi
            
            # エラーや警告の詳細を表示
            echo "$output" | e_indent 8
        fi
    done

    # 結果の集計
    e_header "チェック結果の集計"
    echo "総ファイル数: $total_files"
    echo "エラーファイル数: $error_files"
    echo "警告ファイル数: $warning_files"

    if [ "$error_files" -eq 0 ] && [ "$warning_files" -eq 0 ]; then
        e_success "すべてのファイルが問題ありません"
    else
        if [ "$error_files" -gt 0 ]; then
            e_failure "$error_files 個のファイルにエラーがあります"
        fi
        if [ "$warning_files" -gt 0 ]; then
            e_warning "$warning_files 個のファイルに警告があります"
        fi
    fi
}

# 自動修正の試行
unit2() {
    if ! has "shellcheck"; then
        return
    fi

    e_header "自動修正を試行します"

    local files=()
    files+=("$DOTPATH"/etc/init/*.sh)
    files+=("$DOTPATH"/etc/init/osx/*.sh)
    files+=("$DOTPATH"/etc/init/linux/*.sh)
    files+=("$DOTPATH"/etc/test/*.sh)

    for file in "${files[@]}"; do
        if [ ! -f "$file" ]; then
            continue
        fi

        # 修正可能な問題をチェック
        if shellcheck --format=diff "$file" | patch "$file"; then
            e_success "$file を修正しました" | e_indent
        fi
    done
}

# メイン処理
main() {
    unit1
    unit2
    
    return "$ERR"
}

# メイン処理の実行
main
