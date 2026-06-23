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

# Obsidian vaultのパスを返す
_obsidian_vault() {
  print -r -- "${OBSIDIAN_VAULT:-$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Suitcase}"
}

# Obsidianノート用のスラグを生成
_obsidian_slug() {
  local slug="${1:l}"
  slug="${slug// /_}"
  slug="${slug//[^[:alnum:]_ぁ-んァ-ヶ一-龠々-]/}"
  slug="${slug##[_ ]}"
  slug="${slug%%[_ ]}"
  print -r -- "$slug"
}

# Obsidian vault操作のディスパッチャ
ob() {
  emulate -L zsh
  setopt pipefail extendedglob

  local subcommand="${1:-}"
  if (( $# > 0 )); then
    shift
  fi

  case "$subcommand" in
    new)      _ob_new "$@" ;;
    search)   _ob_search "$@" ;;
    grep)     _ob_grep "$@" ;;
    recent)   _ob_recent "$@" ;;
    inbox)    _ob_new inbox "$@" ;;
    *)
      print -u2 "usage: ob <subcommand> [args]"
      print -u2 "  ob new [notebook|alias] [title]"
      print -u2 "  ob search <query>"
      print -u2 "  ob grep <pattern>"
      print -u2 "  ob recent [n]"
      print -u2 "  ob inbox [title]"
      return 1
      ;;
  esac
}

# Obsidian vault内のノートブック(リーフ=最下層フォルダ)を列挙
# System配下と、サブフォルダを持つ中間フォルダは除外する
_ob_notebooks() {
  local vault="$(_obsidian_vault)"
  local dir
  # System を除く全フォルダ(中間階層・最下層の両方)を列挙する。
  # 中間フォルダも対象にすることで 20_Note/24_Book のような階層の
  # 直下にもノートを作成できる(fzf 選択・名前解決の両方に効く)。
  find "$vault" -type d \
    -not -path "$vault" \
    -not -path "$vault/System" \
    -not -path "$vault/System/*" \
    2>/dev/null | while IFS= read -r dir; do
      print -r -- "${dir#$vault/}"
    done | sort
}

# ノートブックのテンプレートを規約ベースで解決
# System/Templates/<番号接頭辞を除いた名前>.md → Quick.md → なし(空ファイル)
_ob_template() {
  emulate -L zsh
  setopt extendedglob
  local vault="$1" rel="$2"
  local base="${rel:t}"
  local name="${base#<->_}"
  local t
  for t in "$vault/System/Templates/$name.md" "$vault/System/Templates/Quick.md"; do
    if [[ -f "$t" ]]; then
      print -r -- "$t"
      return 0
    fi
  done
  return 1
}

# ob new: ノートを作成して開く
_ob_new() {
  emulate -L zsh
  setopt extendedglob
  local vault="$(_obsidian_vault)"
  local kind="${1:-}"
  if (( $# > 0 )); then
    shift
  fi
  local title="${*:-}"

  # 頻出ノートブックのエイリアス
  local -A aliases=(
    inbox    00_Inbox
    meeting  10_Memo/11_Meetings
    event    10_Memo/12_Events
    lecture  10_Memo/13_Lectures
  )

  # kindをノートブック(vault相対パス)に解決
  local rel=""
  if [[ -n "$kind" ]]; then
    if [[ -n "${aliases[$kind]}" ]]; then
      rel="${aliases[$kind]}"
    elif [[ -d "$vault/$kind" ]]; then
      rel="$kind"
    else
      # フルパス / basename / 番号接頭辞を除いた名前(大小無視)で一致を探す
      local nb b n
      for nb in ${(f)"$(_ob_notebooks)"}; do
        b="${nb:t}"
        n="${b#<->_}"
        if [[ "$nb" == "$kind" || "$b" == "$kind" || "${n:l}" == "${kind:l}" ]]; then
          rel="$nb"
          break
        fi
      done
    fi
  fi

  # 未指定 or 未解決の場合はfzfで選択
  if [[ -z "$rel" ]]; then
    if command -v fzf >/dev/null 2>&1; then
      rel=$(_ob_notebooks | fzf --prompt="notebook> " --height=~15)
      [[ -z "$rel" ]] && return 1
    else
      print -u2 "usage: ob new <notebook|alias> [title]"
      print -u2 "  aliases: inbox meeting event lecture"
      print -u2 "  notebooks:"
      _ob_notebooks | sed 's/^/    /' >&2
      return 1
    fi
  fi

  # titleが未指定の場合は入力を促す
  if [[ -z "$title" ]]; then
    if [[ ! -r /dev/tty ]]; then
      print -u2 "title is required, but no interactive terminal is available"
      return 1
    fi
    print -n "title> " > /dev/tty
    read -r title < /dev/tty || return 1
    [[ -z "$title" ]] && return 1
  fi

  local date_str="$(date +%Y%m%d)"
  local folder template note_path slug

  folder="$vault/$rel"
  template="$(_ob_template "$vault" "$rel")" || template=""

  mkdir -p "$folder"

  slug="$(_obsidian_slug "$title")"
  # 10_Memo配下とInboxは日付プレフィックス付き、それ以外は日付なし
  if [[ "$rel" == 10_Memo/* || "$rel" == "10_Memo" || "$rel" == "00_Inbox" ]]; then
    note_path="$folder/${date_str}_${slug}.md"
  else
    note_path="$folder/${slug}.md"
  fi

  if [[ -f "$note_path" ]]; then
    ${EDITOR:-vim} "$note_path"
    return
  fi

  if [[ -n "$template" && -f "$template" ]]; then
    cp "$template" "$note_path"
  else
    : > "$note_path"
  fi

  ${EDITOR:-vim} "$note_path"
}

# ob search: ファイル名・内容をfzfで絞り込んで開く
_ob_search() {
  local vault="$(_obsidian_vault)"
  local query="${*:-}"
  local selection

  if [[ -z "$query" ]]; then
    print -u2 "usage: ob search <query>"
    return 1
  fi

  selection=$(find "$vault" -type f -name '*.md' -exec grep -l -e "$query" {} + 2>/dev/null | \
    fzf-tmux --reverse --preview 'bat --color=always --style=numbers --line-range=:500 {}' \
    --preview-window=right:60%)

  if [[ -n "$selection" ]]; then
    ${EDITOR:-vim} "$selection"
  fi
}

# ob grep: ripgrepでvault全文検索してfzfで選択して開く
_ob_grep() {
  local vault="$(_obsidian_vault)"
  local pattern="${*:-}"
  local selection

  if [[ -z "$pattern" ]]; then
    print -u2 "usage: ob grep <pattern>"
    return 1
  fi

  if ! command -v rg &>/dev/null; then
    print -u2 "ob grep requires ripgrep (rg)"
    return 1
  fi

  selection=$(rg --line-number --with-filename --color=never -e "$pattern" "$vault" 2>/dev/null | \
    fzf-tmux --reverse --delimiter=':' \
    --preview 'bat --color=always --style=numbers --line-range={2}:+50 {1}' \
    --preview-window=right:60% | \
    cut -d: -f1)

  if [[ -n "$selection" ]]; then
    ${EDITOR:-vim} "$selection"
  fi
}

# ob recent: 最近更新されたノートをfzfで選択して開く
_ob_recent() {
  local vault="$(_obsidian_vault)"
  local n="${1:-20}"
  local selection

  selection=$(find "$vault" -type f -name '*.md' -print0 | \
    xargs -0 ls -t 2>/dev/null | \
    head -n "$n" | \
    fzf-tmux --reverse --preview 'bat --color=always --style=numbers --line-range=:500 {}' \
    --preview-window=right:60%)

  if [[ -n "$selection" ]]; then
    ${EDITOR:-vim} "$selection"
  fi
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

# 与えられたコマンド名が mosh セッション(mosh-server)を示すか判定する。
# ps の出力(フルパス/basename どちらも)を引数で受け取りテストしやすくしている。
_is_mosh_proc() {
    case "$1" in
        *mosh-server*) return 0 ;;
        *)             return 1 ;;
    esac
}

# mosh で接続したとき「だけ」tmux に自動アタッチする。
# 親プロセスが mosh-server の場合のみ発動するため、ローカルターミナル・
# VS Code 統合ターミナル・通常の SSH には影響しない。
#   - 非対話シェル / すでに tmux 内 / tmux 未インストール の場合は何もしない
#   - 発動時は exec で tmux に置き換え、抜けたらそのままログアウトする
_mosh_tmux_autoattach() {
    [[ -o interactive ]] || return 0
    [[ -z $TMUX ]]       || return 0
    has tmux             || return 0

    local parent
    parent="$(ps -o comm= -p "$PPID" 2>/dev/null)"
    if _is_mosh_proc "$parent"; then
        exec tmux new-session -A -s main
    fi
}
