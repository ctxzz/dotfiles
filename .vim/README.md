# Vim Configuration (legacy — migrated to Neovim)

> **Status: legacy / kept for reference.**
> このディレクトリ（`.vim/`）と `../.vimrc` は **Neovim へ移行済み**です。
> 現行のエディタ設定は **[`../nvim/`](../nvim/)**（Lua + lazy.nvim, `~/.config/nvim`）
> にあります。ここは「素の Vim をまだ使う場合」と「移行の検証が済むまでの保険」
> として残しています。
>
> 旧 → 新の対応や変更点は **[`../nvim/README.md` の移行マッピング表](../nvim/README.md#移行マッピング表旧-vim--新-neovim)**
> を参照してください。

## このディレクトリの位置づけ

- **Neovim を使う**: 何もしなくてよい。`../nvim/` が `~/.config/nvim` を担当する。
  Vim と Neovim は設定ディレクトリが独立しているため共存できる。
- **素の Vim も使い続ける**: この `.vim/` + `../.vimrc` がそのまま機能する。
- **Vim をもう使わない**: 「[削除してよいもの](#削除してよいもの)」に従って撤去できる。

## ファイル構成

```
.vim/
├── autoload/
│   └── plug.vim       # vim-plug 本体（ベンダリングして追跡）
├── init.vim           # メイン設定（.vimrc から source される）
├── plugins/
│   ├── init.vim       # vim-plug 定義 + プラグイン設定の読み込み
│   ├── fzf.vim        # fzf.vim 設定
│   ├── git.vim        # fugitive / gitgutter 設定
│   └── language.vim   # vim-polyglot / ファイルタイプ別設定
├── settings/
│   ├── base.vim       # 基本オプション + ユーティリティ関数
│   ├── file.vim       # ファイル操作系（:Ls2 等）
│   ├── keymap.vim     # キーマップ
│   └── ui.vim         # 表示・カラースキーム・透過背景
└── README.md          # このファイル
```

`undo/`・`plugged/`（プラグイン実体）は生成物で、`.gitignore` で除外。

## 必要要件（素の Vim を使う場合）

- Vim 8.0 以上（`termguicolors`・`undofile` 等を使用）
- git / curl（vim-plug とプラグイン取得）
- ripgrep (`rg`)・fzf（fuzzy finder）

## インストール（素の Vim を使う場合）

dotfiles の `make deploy` が `~/.vimrc` → `../.vimrc`、`~/.vim` → この `.vim/` を
symlink する。初回はプラグインを取得する:

```bash
vim +PlugInstall +qall
```

## 削除してよいもの

Neovim へ完全移行し、素の Vim を今後使わないと判断したら以下を撤去できる:

- `../.vimrc`
- この `.vim/` ディレクトリ一式
- ルート `../.gitignore` 内の `.vim/*` 関連エントリ

> 上記は dotfiles の symlink（`~/.vimrc`, `~/.vim`）も併せて掃除すること。
> 迷う場合は残しておいても Neovim 側には一切影響しない。

## Neovim 側との対応（要約）

| 旧 Vim（このディレクトリ） | 新 Neovim（`../nvim/`） |
| --- | --- |
| `init.vim` / `settings/*.vim` | `lua/core/options.lua`・`keymaps.lua`・`autocmds.lua` |
| `plugins/init.vim`（vim-plug） | `lua/core/lazy.lua` + `lua/plugins/*.lua`（lazy.nvim） |
| `plugins/fzf.vim`（fzf） | `lua/plugins/telescope.lua`（telescope） |
| `plugins/git.vim`（fugitive+gitgutter） | `lua/plugins/git.lua`（fugitive+gitsigns） |
| `plugins/language.vim`（polyglot） | `lua/plugins/treesitter.lua` + `markdown.lua` |

詳細・変更点・残した VimScript の理由は `../nvim/README.md` を参照。
