#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: $LINENO: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh
. "$DOTPATH"/etc/test/shellcheck_targets.sh

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

    # チェック対象のファイル（etc/test/shellcheck_targets.sh で定義）
    # （macOS 標準の bash 3.2 には mapfile が無いため read で読む）
    local files=() f
    while IFS= read -r f; do files+=("$f"); done < <(list_shellcheck_targets)

    # カスタムルール
    local custom_rules=(
        -e SC1090  # Can't follow non-constant source
        -e SC1091  # Not following
        -e SC2006  # Use $(..) instead of legacy `..`
        -e SC2086  # Double quote to prevent globbing and word splitting
        -e SC2088  # Tilde does not expand in quotes (intentional in display messages)
        -e SC2155  # Declare and assign separately to avoid masking return values
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
        if output=$(shellcheck "${custom_rules[@]}" "$file" 2>&1); then
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

# zsh スクリプトの構文チェック（ShellCheck は zsh 非対応のため zsh -n を使う）
unit2() {
    if ! has "zsh"; then
        e_warning "zsh がインストールされていません"
        return
    fi

    e_header "zsh スクリプトの構文チェックを開始します"

    local file output
    while IFS= read -r file; do
        if output=$(zsh -n "$file" 2>&1); then
            e_success "$file" | e_indent
        else
            e_failure "$file" | e_indent
            echo "$output" | e_indent 8
            ERR=1
        fi
    done < <(list_zsh_targets)
}

# 自動修正（ソースを書き換える）は make lint-fix（etc/test/shellcheck_fix.sh）に分離。
# make test は読み取り専用に保つ。

# メイン処理
main() {
    unit1
    unit2
}

# メイン処理の実行
main
exit "$ERR"
