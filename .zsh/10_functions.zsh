# コマンドの存在確認
has() {
    type "${1:?too few arguments}" &>/dev/null
}

# OSの種類を取得
ostype() {
    echo ${(L):-$(uname)}
}

# プラットフォームの検出
os_detect() {
    export PLATFORM
    case "$(ostype)" in
        *'linux'*)  PLATFORM='linux'   ;;
        *'darwin'*) PLATFORM='osx'     ;;
        *)          PLATFORM='unknown' ;;
    esac
}

# macOSかどうかの確認
is_osx() {
    os_detect
    if [[ $PLATFORM == "osx" ]]; then
        return 0
    else
        return 1
    fi
}
alias is_mac=is_osx

# Linuxかどうかの確認
is_linux() {
    os_detect
    if [[ $PLATFORM == "linux" ]]; then
        return 0
    else
        return 1
    fi
}

# ログインシェルかどうかの確認
is_login_shell() {
    [[ $SHLVL == 1 ]]
}

# Gitリポジトリかどうかの確認
is_git_repo() {
    git rev-parse --is-inside-work-tree &>/dev/null
    return $status
}

# tmuxが起動しているかどうかの確認
is_tmux_runnning() {
    [[ -n $TMUX ]]
}

# インタラクティブシェルかどうかの確認
shell_has_started_interactively() {
    [[ -n $PS1 ]]
}

# SSHセッションかどうかの確認
is_ssh_running() {
    [[ -n $SSH_CLIENT ]]
}

# ファイルパスの取得
get_path() {
    local f="${1:?}"
    if [[ -t 1 ]]; then
        printf "${f:A}\n"
    else
        printf "${f:A}"
    fi
}

# ディレクトリ移動
fd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
            -o -type d -print 2> /dev/null | fzf +m) &&
    cd "$dir"
}

# 隠しディレクトリを含む移動
fda() {
    local dir
    dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# ファイル検索と編集
fe() {
    local files
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# 開発ディレクトリへの移動
devpath() {
    local loc="$(ghq list | fzf-tmux --reverse --multi --cycle --preview="ls -lF $(ghq root)/{}" --preview-window=right:60%)"
    if [[ -n $loc ]]; then
        echo $(ghq root)/$loc
    fi
    return 1
}

# ghqで管理しているリポジトリに移動
gcd() {
    local repo_path
    repo_path="$(ghq list | fzf-tmux --reverse --query="$1" --preview="ls -lF $(ghq root)/{}" --preview-window=right:60%)"
    if [[ -n $repo_path ]]; then
        cd "$(ghq root)/$repo_path"
    fi
}

# 履歴からファイルを検索して開く
fh() {
    local file
    file=$(find . -type f -not -path '*/\.git/*' -not -path '*/node_modules/*' -mtime -7 2>/dev/null | \
        fzf-tmux --reverse --preview 'bat --color=always --style=numbers --line-range=:500 {}' \
        --preview-window=right:60%)
    if [[ -n $file ]]; then
        $EDITOR "$file"
    fi
}

# Gitブランチを対話的に切り替え
fgb() {
    local branch
    branch=$(git branch --all | grep -v HEAD | \
        fzf-tmux --reverse --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' \
        --preview-window=right:60%)
    if [[ -n $branch ]]; then
        git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
    fi
}

# プロセスをインタラクティブに検索してkill
fkill() {
    local pid
    if [[ "$UID" != "0" ]]; then
        pid=$(ps -f -u $UID | sed 1d | fzf-tmux --reverse --preview 'echo {}' --preview-window=down:3:wrap | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf-tmux --reverse --preview 'echo {}' --preview-window=down:3:wrap | awk '{print $2}')
    fi
    if [[ -n $pid ]]; then
        echo "Killing pid $pid"
        kill -${1:-9} $pid
    fi
}

# Docker Composeの実行
unalias dex 2>/dev/null
function dex() {
    if [[ -f docker-compose.yml ]]; then
        docker compose "$@"
    else
        echo "docker-compose.yml not found in the current directory"
        return 1
    fi
}

# Dockerコンテナのログを表示
dlogs() {
    local container
    container=$(docker ps | sed 1d | fzf-tmux --reverse --preview 'docker logs {}' --preview-window=right:60% | awk '{print $1}')
    if [[ -n $container ]]; then
        docker logs -f $container
    fi
}

# 最近のGitブランチを検索して切り替え
fbr() {
    local branches branch
    branches=$(git branch --all | grep -v HEAD) &&
    branch=$(echo "$branches" | \
        fzf-tmux --reverse -d $(( 2 + $(wc -l <<< "$branches") )) \
        --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' \
        --preview-window=right:60%) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# ディレクトリスタックをfzfで操作
fcd() {
    local dir
    dir=$(dirs -v | fzf-tmux --reverse --preview 'ls -lF ~/{2}' --preview-window=right:60% | awk '{print $2}')
    if [[ -n $dir ]]; then
        cd ~/"$dir"
    fi
}

# miseでツールをインタラクティブにインストール
mise-install() {
    if ! command -v mise &> /dev/null; then
        echo "mise is not installed"
        return 1
    fi

    local tool
    tool=$(mise ls-remote | fzf-tmux --reverse --preview 'echo "Select a tool to install"' --preview-window=down:3:wrap)
    if [[ -n $tool ]]; then
        mise install "$tool"
    fi
}

# miseでインストール済みのツールをfzfで選択
mise-select() {
    if ! command -v mise &> /dev/null; then
        echo "mise is not installed"
        return 1
    fi

    mise ls | fzf-tmux --reverse --preview 'mise current {}' --preview-window=right:60%
}

# miseで管理しているツールの情報を表示
mise-info() {
    if ! command -v mise &> /dev/null; then
        echo "mise is not installed"
        return 1
    fi

    echo "=== Mise Configuration ==="
    mise current
    echo ""
    echo "=== Installed Tools ==="
    mise ls
    echo ""
    echo "=== Mise Doctor ==="
    mise doctor
}

# miseで特定のツールバージョンを素早くインストール
mise-quick-install() {
    if ! command -v mise &> /dev/null; then
        echo "mise is not installed"
        return 1
    fi

    local tool="${1:?Please specify a tool (e.g., node@20, python@3.11)}"
    mise install "$tool" && mise use --global "$tool"
} 