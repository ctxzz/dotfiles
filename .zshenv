# PATHの設定
typeset -gx -U path
path=( \
    /opt/homebrew/bin(N-/) \
    /usr/local/bin(N-/) \
    /usr/local/sbin(N-/) \
    /usr/bin(N-/) \
    /bin(N-/) \
    /usr/sbin(N-/) \
    ~/bin(N-/) \
    /sbin(N-/) \
    ~/.zinit/bin(N-/) \
    ~/.tmux/bin(N-/) \
    ~/.local/bin(N-/) \
    ~/.nodebrew/current/bin(N-/) \
    ~/.bun/bin(N-/) \
    "$path[@]" \
    )

# zinitの設定
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
typeset -gA ZINIT
ZINIT[ZCOMPDUMP_PATH]="${XDG_CACHE_HOME:-${HOME}/.cache}/zcompdump"

# 補完関数のパス設定
typeset -gx -U fpath
fpath=( \
    ~/.zsh/Completion(N-/) \
    ~/.zsh/functions(N-/) \
    ~/.zsh/plugins/zsh-completions(N-/) \
    /usr/local/share/zsh/site-functions(N-/) \
    $fpath \
    )

# 基本的な自動読み込み
autoload -Uz run-help
autoload -Uz add-zsh-hook
autoload -Uz colors && colors
autoload -Uz compinit
autoload -Uz is-at-least

# 補完システムの初期化
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# 言語設定
export LANGUAGE="en_US.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"

# エディタ設定
export EDITOR=vim
export CVSEDITOR="${EDITOR}"
export SVN_EDITOR="${EDITOR}"
export GIT_EDITOR="${EDITOR}"

# direnvの初期化
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi

# ページャー設定
export PAGER=less
export LESS='-R -f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESSCHARSET='utf-8'

# manページの色設定
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[00;44;37m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# ls コマンドの色設定
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# Go言語の設定
export GOPATH="$HOME/golang"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"

# NVM
export NVM_DIR="$HOME/.nvm"

# スペル訂正の除外パターン
export CORRECT_IGNORE='_*'
export CORRECT_IGNORE_FILE='.*'

# 単語の区切り文字
export WORDCHARS='*?.[]~&;!#$%^(){}<>'

# 履歴の設定
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
export LISTMAX=50

# rootユーザーの場合は履歴を残さない
if [[ $UID == 0 ]]; then
    unset HISTFILE
    export SAVEHIST=0
fi

# fzfの設定
export FZF_DEFAULT_OPTS="--extended --ansi --multi"

# dotfilesのパス
export DOTPATH=${0:A:h}
