#!/bin/bash
# ShellCheck の自動修正を適用する（ソースを書き換える）。make lint-fix から実行する。
# make test（shellcheck_test.sh）は読み取り専用なので、修正はこちらで明示的に行う。

trap 'echo Error: $0: $LINENO: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh
. "$DOTPATH"/etc/test/shellcheck_targets.sh

if ! has "shellcheck"; then
    die "shellcheck がインストールされていません"
fi

e_header "自動修正を適用します"

while IFS= read -r file; do
    diff=$(shellcheck --format=diff "$file" 2>/dev/null) || true
    [ -n "$diff" ] || continue
    if echo "$diff" | patch "$file"; then
        e_success "$file を修正しました" | e_indent
    else
        e_failure "$file の修正に失敗しました" | e_indent
    fi
done < <(list_shellcheck_targets)
