#!/bin/bash
# ShellCheck / zsh -n のチェック対象の定義（shellcheck_test.sh と shellcheck_fix.sh で共有）。
# source して使う（DOTPATH が設定済みであること）。

# list_shellcheck_targets は ShellCheck の対象（bash/sh スクリプト）を 1 行ずつ出力する
list_shellcheck_targets() {
    local f
    for f in \
        "$DOTPATH"/etc/install \
        "$DOTPATH"/etc/lib/*.sh \
        "$DOTPATH"/etc/init/*.sh \
        "$DOTPATH"/etc/init/osx/*.sh \
        "$DOTPATH"/etc/init/linux/*.sh \
        "$DOTPATH"/etc/test/*.sh \
        "$DOTPATH"/etc/test/osx/*.sh \
        "$DOTPATH"/etc/test/linux/*.sh \
        "$DOTPATH"/etc/test/win/*.sh \
        "$DOTPATH"/bin/*
    do
        [ -f "$f" ] || continue
        # ShellCheck は zsh 非対応のため、zsh スクリプトは list_zsh_targets 側で扱う
        head -n 1 "$f" | grep -q 'zsh' && continue
        echo "$f"
    done
}

# list_zsh_targets は zsh -n で構文チェックする zsh スクリプトを 1 行ずつ出力する
list_zsh_targets() {
    local f
    for f in \
        "$DOTPATH"/.zshrc \
        "$DOTPATH"/.zshenv \
        "$DOTPATH"/.zsh/*.zsh \
        "$DOTPATH"/bin/*
    do
        [ -f "$f" ] || continue
        case "$f" in
            "$DOTPATH"/bin/*) head -n 1 "$f" | grep -q 'zsh' || continue ;;
        esac
        echo "$f"
    done
}
