#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

# デプロイテスト
unit1() {
    e_header "デプロイテストの実行"
    
    cd "$DOTPATH" || exit
    if make deploy >/dev/null; then
        e_success "デプロイが成功しました"
    else
        e_failure "デプロイに失敗しました"
        ERR=1
    fi
}

# シンボリックリンクの整合性チェック
unit2() {
    e_header "シンボリックリンクの整合性チェック"
    
    cd "$DOTPATH" || exit
    local invalid_links=0
    
    for i in $(make --silent list | sed "s|[*@/]$||g"); do
        local target="$HOME/$i"
        local source="$DOTPATH/$i"
        
        # ファイルの存在確認
        if [ ! -e "$source" ]; then
            e_warning "ソースファイルが存在しません: $source"
            invalid_links=$((invalid_links + 1))
            continue
        fi
        
        # シンボリックリンクの確認
        if [ ! -L "$target" ]; then
            e_warning "シンボリックリンクではありません: $target"
            invalid_links=$((invalid_links + 1))
            continue
        fi
        
        # リンク先の確認
        local link_target=$(readlink "$target")
        if [ "$link_target" != "$source" ]; then
            e_warning "不正なリンク先: $target -> $link_target (期待: $source)"
            invalid_links=$((invalid_links + 1))
        fi
    done
    
    if [ "$invalid_links" -eq 0 ]; then
        e_success "すべてのシンボリックリンクが正しく設定されています"
    else
        e_failure "$invalid_links 個の不正なリンクが見つかりました"
        ERR=1
    fi
}

# ファイルのパーミッションチェック
unit3() {
    e_header "ファイルのパーミッションチェック"
    
    cd "$DOTPATH" || exit
    local invalid_perms=0
    
    for i in $(make --silent list | sed "s|[*@/]$||g"); do
        local source="$DOTPATH/$i"
        
        # 実行可能ファイルのチェック
        if [[ "$i" == *.sh ]] || [[ "$i" == */bin/* ]]; then
            if [ ! -x "$source" ]; then
                e_warning "実行権限がありません: $source"
                invalid_perms=$((invalid_perms + 1))
            fi
        fi
    done
    
    if [ "$invalid_perms" -eq 0 ]; then
        e_success "すべてのファイルのパーミッションが正しく設定されています"
    else
        e_failure "$invalid_perms 個の不正なパーミッションが見つかりました"
        ERR=1
    fi
}

# .claude のシンボリックリンクチェック
unit4() {
    e_header ".claude のシンボリックリンクチェック"

    cd "$DOTPATH" || exit
    local invalid_links=0

    check_link() {
        local target="$1" source="$2"
        if [ ! -e "$source" ]; then
            e_warning "ソースファイルが存在しません: $source"
            invalid_links=$((invalid_links + 1)); return
        fi
        if [ ! -L "$target" ]; then
            e_warning "シンボリックリンクではありません: $target"
            invalid_links=$((invalid_links + 1)); return
        fi
        local link_target
        link_target=$(readlink "$target")
        if [ "$link_target" != "$source" ]; then
            e_warning "不正なリンク先: $target -> $link_target (期待: $source)"
            invalid_links=$((invalid_links + 1))
        fi
    }

    # 単一ファイルは ~/.claude 直下にリンク
    for f in CLAUDE.md settings.json ai.env; do
        check_link "$HOME/.claude/$f" "$DOTPATH/.claude/$f"
    done

    # skills/ は実ディレクトリのまま、リポジトリの各 skill を個別にリンク
    # （ランタイム/グローバル skill との共存を保つ）
    if [ -L "$HOME/.claude/skills" ]; then
        e_warning "~/.claude/skills は実ディレクトリであるべきです（symlink になっています）"
        invalid_links=$((invalid_links + 1))
    fi
    for d in "$DOTPATH"/.claude/skills/*/; do
        local name
        name=$(basename "$d")
        # 同名の skill がグローバル(バンドル)版として実ディレクトリで既に存在する
        # 場合は、deploy 側でも symlink を張らず共存させるためスキップする。
        if [ -e "$HOME/.claude/skills/$name" ] && [ ! -L "$HOME/.claude/skills/$name" ]; then
            printf "  - スキップ（グローバル skill と共存）: %s\n" "$name"
            continue
        fi
        check_link "$HOME/.claude/skills/$name" "${d%/}"
    done

    if [ "$invalid_links" -eq 0 ]; then
        e_success ".claude のシンボリックリンクが正しく設定されています"
    else
        e_failure "$invalid_links 個の不正な .claude リンクが見つかりました"
        ERR=1
    fi
}

# nvim (~/.config/nvim) のシンボリックリンクチェック
unit5() {
    e_header "nvim のシンボリックリンクチェック"

    cd "$DOTPATH" || exit
    local target="$HOME/.config/nvim"
    local source="$DOTPATH/nvim"

    if [ ! -d "$source" ]; then
        e_warning "ソースディレクトリが存在しません: $source"
        ERR=1
        return
    fi
    if [ ! -L "$target" ]; then
        e_failure "シンボリックリンクではありません: $target"
        ERR=1
        return
    fi
    local link_target
    link_target=$(readlink "$target")
    if [ "$link_target" != "$source" ]; then
        e_failure "不正なリンク先: $target -> $link_target (期待: $source)"
        ERR=1
        return
    fi
    e_success "~/.config/nvim が正しくリンクされています"
}

# テストの実行
main() {
    unit1
    unit2
    unit3
    unit4
    unit5

    if [ "$ERR" -eq 0 ]; then
        e_success "すべてのデプロイテストが成功しました"
    else
        e_failure "一部のデプロイテストが失敗しました"
    fi
    
}

# メイン処理の実行
main
exit "$ERR"
