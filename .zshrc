# 基本設定
umask 022
limit coredumpsize 0

# プロンプト設定
if [[ -n "$TMUX" ]]; then
    PROMPT='%n$ '
else
    PROMPT='%n$ '
fi

# Vimから呼び出された場合は設定をスキップ
if [[ -n $VIMRUNTIME ]]; then
    return 0
fi

# tmuxの自動アタッチ（無効化）
# if [[ -x ~/bin/tmuxx ]]; then
#     ~/bin/tmuxx
# fi

# ローカル設定の読み込み
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

# zsh設定ファイルの読み込み
# （brew / mise / direnv などの初期化は .zsh/00_base.zsh に集約）
if [[ -d ~/.zsh ]]; then
    for f in ~/.zsh/[0-9]*.(sh|zsh)
    do
        if [[ ! -x $f ]]; then
            source "$f" && echo "loading $f"
        fi
    done

    printf "\n"
    printf "$fg_bold[cyan] This is ZSH $fg_bold[red]$ZSH_VERSION"
    printf "$fg_bold[cyan] - DISPLAY on $fg_bold[red]$DISPLAY$reset_color\n\n"
fi

# 補完システムの初期化（プラグイン読み込み後に一度だけ）
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# z（ディレクトリジャンプ）の設定
if [ -f "/usr/local/etc/profile.d/z.sh" ]; then
    . "/usr/local/etc/profile.d/z.sh"
fi

# fzfの設定
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
