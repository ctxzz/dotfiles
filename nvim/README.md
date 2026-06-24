# Neovim Configuration

既存の Vim 設定（`../.vimrc` / `../.vim/`）を **Lua + [lazy.nvim]** 構成へ移植した
Neovim 設定です。VimScript の `source` による互換流用はせず、options / keymaps /
autocmds / plugins をすべて Lua の API に書き直しています。

[lazy.nvim]: https://github.com/folke/lazy.nvim

## 必要要件

- **[Neovim] 0.10 以上**（`vim.uv`, `vim.tbl_keys` 等の API を使用）
  - macOS: `brew install neovim`
  - Linux: `apt install neovim` / `dnf install neovim` / 公式 AppImage
- **git** — lazy.nvim とプラグインの取得に必要
- **[ripgrep]** (`rg`) — telescope の live grep に必要（`<C-f>` / `<leader>a`）
- **C コンパイラ**（`cc`/`gcc`/`clang`）— nvim-treesitter のパーサビルド用
- **[Nerd Font]** — nvim-tree / devicons のアイコン表示用（任意）

[Neovim]: https://github.com/neovim/neovim
[ripgrep]: https://github.com/BurntSushi/ripgrep
[Nerd Font]: https://www.nerdfonts.com/

## ディレクトリ構成

```
nvim/                       # = ~/.config/nvim/
├── init.lua                # エントリポイント（leader 設定 → core/* を require）
├── lua/
│   ├── core/
│   │   ├── options.lua     # vim.opt 各種（旧 base.vim + ui.vim）
│   │   ├── keymaps.lua     # グローバルキーマップ（旧 keymap.vim）
│   │   ├── autocmds.lua    # autocmd（旧 ui.vim + language.vim）
│   │   └── lazy.lua        # lazy.nvim ブートストラップ + spec ロード
│   └── plugins/            # lazy.nvim プラグイン spec（1 ファイル 1 関心事）
│       ├── colorscheme.lua # catppuccin
│       ├── telescope.lua   # ファインダ（fzf 置き換え）
│       ├── nvim-tree.lua   # ファイラ（新規）
│       ├── git.lua         # fugitive + gitsigns
│       ├── treesitter.lua  # 構文ハイライト（polyglot 置き換え, markdown は除外）
│       └── markdown.lua    # vim-markdown + tabular
├── after/
│   └── ftplugin/
│       └── markdown.lua    # markdown はコアの treesitter を止め Vim 構文を使う
└── README.md               # このファイル
```

## 導入手順

`make deploy` が `~/.config/nvim` → リポジトリの `nvim/` を自動でシンボリンクします
（`.config` 配下は `DOTFILES` の自動リンク対象外なので、`.claude` と同様に Makefile が
個別にリンクする）。手動で張る場合は:

```bash
ln -sfn ~/.dotfiles/nvim ~/.config/nvim   # ~/.dotfiles は clone 先に合わせる
```

> 既存の `~/.config/nvim` が**実ディレクトリ**だと `ln`/`make deploy` がその中に
> リンクを作ってしまうので、先に退避してから実行してください（symlink なら上書きされます）。

リンク後、`nvim` を起動すると lazy.nvim が自動でブートストラップされ、
プラグインが取得・インストールされます。

## 起動 → 動作確認（3〜4 ステップ）

1. `nvim` を起動する → 初回は lazy.nvim が自動 clone され、続けて全プラグインを取得。
2. インストール完了を待ち（`:Lazy` で進捗確認可）、`:q` で一度閉じて再度 `nvim` 起動。
3. `:checkhealth` で treesitter/telescope の依存（`rg`, コンパイラ等）を確認。
4. `<C-p>`（ファイル検索）・`<leader>e`（ファイラ）・`<leader>gs`（git status）を叩き、
   旧 Vim と挙動差がないか確認する。

## 主要キーマップ

`leader` = `<Space>`（localleader も `<Space>`）。

### ウィンドウ / タブ（旧 keymap.vim）

| キー | 動作 |
| --- | --- |
| `ss` / `sv` | 水平 / 垂直分割 |
| `sq` | ウィンドウを閉じる |
| `sh` `sj` `sk` `sl` | ウィンドウ移動 |
| `tt` | 新規タブ |
| `tT` | 新規タブ（前へ） |
| `tq` / `to` | タブを閉じる / 他タブを閉じる |
| `tn` / `tp` | 次 / 前のタブ |
| `<leader>k` | バッファを閉じる |
| `gsh` | ターミナルを開く（旧 `:sh`） |

### ファインダ（telescope, 旧 fzf）

| キー | 動作 |
| --- | --- |
| `<C-p>` | ファイル検索（find_files） |
| `<C-g>` / `<leader>f` | Git 管理ファイル（git_files） |
| `<C-f>` / `<leader>a` | 全文検索（live_grep） |
| `<leader>b` | バッファ一覧 |
| `<leader>x` | コマンド一覧 |
| `<leader>r` | 最近使ったファイル（oldfiles） |

### ファイラ（nvim-tree, 新規）

| キー | 動作 |
| --- | --- |
| `<leader>e` | ファイルツリーをトグル |

### Git（fugitive + gitsigns, 旧 git.vim）

| キー | 動作 |
| --- | --- |
| `<leader>gs` | `:Git`（status） |
| `<leader>gd` | `:Gdiffsplit` |
| `<leader>gc` | `:Git commit` |
| `<leader>gb` | `:Git blame` |
| `<leader>gl` | `:Git log` |
| `<leader>gp` | `:Git push` |
| `<leader>gr` / `gw` / `ge` | checkout / add / edit |
| `<leader>hn` / `hN` | 次 / 前の hunk |
| `<leader>hp` | hunk プレビュー |
| `<leader>hs` | hunk ステージ |
| `<leader>hr` / `hu` | hunk を戻す |

## 移行マッピング表（旧 Vim → 新 Neovim）

### 設定ファイル

| 旧（VimScript） | 新（Lua） |
| --- | --- |
| `.vimrc` → `.vim/init.vim` | `nvim/init.lua` |
| `.vim/settings/base.vim` | `lua/core/options.lua`（一部 `autocmds.lua`） |
| `.vim/settings/ui.vim` | `lua/core/options.lua` + `lua/core/autocmds.lua` |
| `.vim/settings/keymap.vim` | `lua/core/keymaps.lua` + 各 plugin spec の `keys` |
| `.vim/settings/file.vim` | （後述：移植せず） |
| `.vim/plugins/init.vim`（vim-plug） | `lua/core/lazy.lua` + `lua/plugins/*.lua` |
| `.vim/plugins/fzf.vim` | `lua/plugins/telescope.lua` |
| `.vim/plugins/git.vim` | `lua/plugins/git.lua` |
| `.vim/plugins/language.vim` | `lua/core/autocmds.lua` + `lua/plugins/markdown.lua` |

### プラグイン

| 旧プラグイン | 新プラグイン | 種別 |
| --- | --- | --- |
| vim-plug | **lazy.nvim** | マネージャ置き換え |
| `catppuccin/vim` | `catppuccin/nvim` | Lua ネイティブ版へ |
| `junegunn/fzf` + `fzf.vim` | `nvim-telescope/telescope.nvim`（+ `plenary.nvim`） | Lua ネイティブ版へ |
| （ファイラなし） | `nvim-tree/nvim-tree.lua`（+ `nvim-web-devicons`） | **新規追加** |
| `airblade/vim-gitgutter` | `lewis6991/gitsigns.nvim` | Lua ネイティブ版へ |
| `sheerun/vim-polyglot` | `nvim-treesitter/nvim-treesitter` | Lua ネイティブ版へ |
| `tpope/vim-fugitive` | `tpope/vim-fugitive` | 維持（Neovim でも動作） |
| `godlygeek/tabular` | `godlygeek/tabular` | 維持 |
| `preservim/vim-markdown` | `preservim/vim-markdown` | 維持 |

### options（主なもの）

`set` 系はすべて `vim.opt` に変換。挙動は等価です。代表例：

| 旧 | 新 |
| --- | --- |
| `set number relativenumber` | `vim.opt.number / relativenumber = true` |
| `set tabstop=2 shiftwidth=2 expandtab` | `vim.opt.tabstop/shiftwidth = 2`, `expandtab = true` |
| `set ignorecase smartcase incsearch hlsearch` | 対応する `vim.opt.*` |
| `set undofile / undodir=~/.vim/undo` | `vim.opt.undofile`, `undodir = stdpath('data')/undo`（後述の変更点） |
| `set termguicolors background=dark` | 同左 |
| `colorscheme catppuccin_mocha` | `catppuccin-mocha`（plugin spec で適用） |
| 自作 `statusline` | `vim.opt.statusline`（同一文字列で維持） |

## 等価ではない・意図的に変えた点

挙動を完全には引き継がず変更した箇所（理由つき）：

- **undo ディレクトリ**: `~/.vim/undo` → `stdpath('data')/undo`
  （`~/.local/share/nvim/undo`）。Vim と Neovim で undo ファイルを共有しないため。
- **`lazyredraw`**: 設定しない。モダンな Lua プラグイン UI と相性が悪いため除外。
- **ベル**: `set visualbell` + `set t_vb=` → `vim.opt.belloff = "all"`。
  `t_vb` 等のターミナルコードは Neovim に存在しないため。「全ベル無効」の意図を踏襲。
- **`<C-f>` / `<leader>a`**: 旧 fzf は `ag`(silver searcher) を使用していたが、
  telescope の `live_grep` は **ripgrep** を使用（dotfiles でも rg を採用済み）。
- **fugitive のコマンド名**: `:Gstatus` `:Gcommit` `:Gblame` `:Gdiff` `:Glog` `:Gpush`
  は廃止予定のため、現行の `:Git` / `:Git commit` / `:Git blame` / `:Gdiffsplit` /
  `:Git log` / `:Git push` にマッピングを更新。
- **`gZZ`（端末コードを使った quit）**: Neovim では不要なため削除。`gsh` は
  `:terminal` に置き換え。
- **GUI / IME 専用コード**（`s:gui()`, `multi_byte_ime`/`xim` 周り, `guifont` 等）:
  Neovim 本体は GUI を持たず、IME/フォントは各 GUI フロントエンド側の責務のため削除。
- **`[Space]t` マッピング**: 旧設定では `[Space]` がプレフィックス定義されておらず
  実質デッドコードだったため削除。
- **polyglot 無効化フラグ**（`g:polyglot_disabled`, `g:jsx_ext_required`,
  `g:vim_json_syntax_conceal`）: polyglot 撤去に伴い不要なため削除。インデントは
  `core/autocmds.lua` のファイルタイプ別設定が引き続き権威。
- **Markdown のハイライト**: treesitter ではなく **vim-markdown（Vim 時代の見た目）**
  を使用。Neovim はコア（`ftplugin/markdown.lua`）とプラグインの双方が markdown を
  treesitter で起動しようとし、vim-markdown と二重に当たって表示が崩れるため、
  treesitter 側は `ignore_install` + `highlight.disable` で markdown を無効化し、
  コア分は `after/ftplugin/markdown.lua` で `vim.treesitter.stop()` して Vim 構文を
  読ませている。markdown 以外は従来どおり treesitter。
- **背景の透過**: catppuccin の `transparent_background = true` に一本化。旧実装は
  `nvim_set_hl(group, { bg = "none" })` で **前景色まで消していた**（Vim の
  `:hi Normal guibg=NONE` は fg を保持する挙動と差異）ため、これをやめて文字色を維持。
  Vim 由来の青いステータスラインだけ `core/autocmds.lua` で再指定。

## 残した VimScript

`source` による旧 vimrc の流用は行っていません。`lua/plugins/*.lua` で
lazy.nvim 管理下に置いている **vim-fugitive / vim-markdown / tabular** は
VimScript 製プラグインですが、これは「旧設定の互換流用」ではなく
「Neovim でも動作する優良プラグインをそのまま採用」したものです
（Lua ネイティブの完全同等品がない、ないし置き換えの必要が薄いため）。

## 移植せず残した旧設定

`.vim/settings/file.vim`（および `base.vim` 末尾）の自作関数
`s:rm` / `s:ls`（`:Ls2` コマンド）は移植していません。日常運用での使用頻度が低く、
Neovim では telescope / nvim-tree / `:terminal` で代替できるためです。
必要になれば Lua の `vim.api.nvim_create_user_command` で追加できます。

## 旧 Vim 設定について

移行が完了したため、旧 Vim 設定（`../.vimrc`, `../.vim/`）は**リポジトリから削除済み**です。
本ファイルの移行マッピング表は、当時どこから移植したかの記録として残しています。

既に dotfiles をデプロイ済みの環境では、ぶら下がった symlink を掃除してください：

```bash
rm -f ~/.vimrc ~/.vim   # 旧 Vim 設定へのリンク（リンク先は削除済み）
```

> 素の Vim を使うことはありますが（`nvim` 未インストール環境でのフォールバック等）、
> その場合は Vim 標準の挙動になります。Vim 専用設定が再び必要になったら別途用意してください。
