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

# zplugの初期化
if [[ ! -d ~/.zplug ]]; then
    export ZPLUG_HOME=~/.zplug
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
    zplug update --self
fi

if [[ -f ~/.zplug/init.zsh ]]; then
    export ZPLUG_LOADFILE=~/.zsh/zplug.zsh
    source ~/.zplug/init.zsh

    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
        echo
    fi
    zplug load
fi

# 補完システムの再初期化
autoload -Uz compinit
compinit -C

# ローカル設定の読み込み
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

# zsh設定ファイルの読み込み
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

# z（ディレクトリジャンプ）の設定
if [ -f "/usr/local/etc/profile.d/z.sh" ]; then
    . "/usr/local/etc/profile.d/z.sh"
fi

# Homebrewの設定
eval "$(/opt/homebrew/bin/brew shellenv)"

# fzfの設定
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Bunの補完
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# NVMの読み込み
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
