# vim:ft=zsh

# ZLEの関数ネストレベルを制限
export FUNCNEST=50

# キーバインドの設定
bindkey -e

# 補完システムの初期化
autoload -Uz compinit && compinit
zmodload zsh/complist

# 履歴検索
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history

# 単語移動
bindkey '^F' forward-word
bindkey '^B' backward-word

# 行頭・行末移動
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# 削除
bindkey '^D' delete-char
bindkey '^H' backward-delete-char
bindkey '^W' backward-kill-word

# 補完
bindkey '^I' complete-word

# インクリメンタルサーチ
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# 元に戻す/やり直し
bindkey '^_' undo
bindkey '^X^U' redo

# コマンドライン編集
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# 補完メニューの移動
bindkey -M menuselect '^P' up-line-or-history
bindkey -M menuselect '^N' down-line-or-history
bindkey -M menuselect '^B' backward-char
bindkey -M menuselect '^F' forward-char
bindkey -M menuselect '^G' send-break
bindkey -M menuselect '^J' accept-and-menu-complete
bindkey -M menuselect '^M' accept-and-menu-complete

# tmux環境でのキーバインド設定
if [[ -n $TMUX ]]; then
    # tmuxでの補完メニュー表示を有効化
    bindkey -M menuselect '^[[Z' reverse-menu-complete
    bindkey -M menuselect '^[[A' up-line-or-history
    bindkey -M menuselect '^[[B' down-line-or-history
    bindkey -M menuselect '^[[D' backward-char
    bindkey -M menuselect '^[[C' forward-char
fi 