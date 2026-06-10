# vim:ft=zsh

# zinitのインストール
if [[ ! -f $ZINIT_HOME/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$(dirname $ZINIT_HOME)"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$ZINIT_HOME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# 自動補完
zinit light "zsh-users/zsh-completions"

# シンタックスハイライト
zinit light "zsh-users/zsh-syntax-highlighting"

# 履歴検索
zinit light "zsh-users/zsh-history-substring-search"

# 自動提案
zinit light "zsh-users/zsh-autosuggestions"

# fzf（fzf-binはアーカイブ済み。本体のGitHub Releasesからバイナリを取得）
zinit ice from"gh-r" as"program"
zinit light "junegunn/fzf"
zinit ice as"program" pick"bin/fzf-tmux"
zinit light "junegunn/fzf"

# enhancd
zinit light "b4b4r07/enhancd"

# プロンプトテーマ
zinit ice pick"async.zsh" src"pure.zsh"
zinit light "sindresorhus/pure"

# 各設定ファイルは .zshrc が読み込む（ここで再読込すると全設定が二重になる）
# compinit も .zshrc 側で一度だけ実行する
