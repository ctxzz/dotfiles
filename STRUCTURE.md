# Repository Structure

このドキュメントは、dotfilesリポジトリの構造と各ファイル・ディレクトリの役割を説明します。

## ルートディレクトリ

```
.
├── .bash_profile       # Bash起動時に読み込まれる設定
├── .bashrc            # Bash設定（エイリアス、関数など）
├── .claude/           # Claude Code設定（専用スクリプトで個別シンボリンク）
│   ├── CLAUDE.md     # プロジェクト共通の指示
│   ├── settings.json # 権限・フック等の設定
│   ├── ai.env        # 画像スキル用の1Password秘密参照（op run で解決）
│   └── skills/       # カスタムスキル群（commit, gen-image 等）
├── .config/           # アプリケーション設定ディレクトリ（シンボリンク対象外）
│   └── mise/         # mise設定とドキュメント
├── .gitignore         # Git除外設定
├── .gitmodules        # Gitサブモジュール設定
├── .tmp.gitconfig     # Git設定テンプレート
├── .tmux/             # tmuxプラグインディレクトリ
├── .tmux.conf         # tmux設定
├── nvim/              # Neovim設定（Lua + lazy.nvim、~/.config/nvim）
├── .zsh/              # zsh設定ファイル群
├── .zshenv            # zsh環境変数（常に読み込まれる）
├── .zshrc             # zsh設定（インタラクティブシェル用）
├── bin/               # 個人用スクリプト
├── etc/               # 初期化・テストスクリプト
├── Makefile           # デプロイとタスク管理
└── README.md          # プロジェクトドキュメント
```

## etc/ ディレクトリ構造

### etc/init/ - 初期化スクリプト

```
etc/init/
├── init.sh                 # メイン初期化スクリプト（OS判別して適切なスクリプトを実行）
├── mise_setup.sh           # mise、Node.js、Bun、niの自動セットアップ
├── ws_setup.sh             # ワークスペース（ws）セットアップ
├── linux/                  # Linux固有の初期化
│   ├── linux_install.sh   # パッケージインストール
│   └── linux_settings.sh  # システム設定
├── osx/                    # macOS固有の初期化
│   ├── 10_brew.sh         # Homebrewセットアップ
│   ├── 20_bundle.sh       # Homebrew bundleインストール
│   ├── 30_workspace.sh    # ワークスペースセットアップ
│   ├── Brewfile           # インストールするパッケージリスト
│   ├── macos_defaults.sh  # macOSシステム設定
│   └── zsh.sh             # zshセットアップ
└── win/                    # Windows固有の初期化
    ├── windows_install.ps1
    └── windows_settings.ps1
```

### etc/test/ - テストスクリプト

```
etc/test/
├── test.sh                 # メインテストランナー
├── deploy_test.sh          # デプロイ（シンボリンク）テスト
├── skills_image_test.sh    # 画像スキルのスモークテスト（skills_image_check.py を実行）
├── skills_image_check.py   # gen-image / review-image のネットワーク不要テスト
├── redirect_test.sh        # dot.omata.meリダイレクトテスト
├── shellcheck_test.sh      # シェルスクリプト静的解析
├── linux/                  # Linux固有のテスト
│   ├── linux_install_test.sh
│   └── linux_settings_test.sh
└── osx/                    # macOS固有のテスト
    ├── init_brew_test.sh
    ├── init_bundle_test.sh
    └── init_workspace_test.sh  # ワークスペースセットアップテスト
```

### etc/lib/ - 共通ライブラリ

```
etc/lib/
└── vital.sh                # 共通関数（ログ出力、OS判別など）
```

## 主要ファイルの説明

### Makefile

シンボリンクの作成とタスク管理を行います。

**主要なコマンド:**
- `make deploy` - dotfilesをホームディレクトリにシンボリンク
- `make init` - 初期化スクリプトを実行
- `make test` - テストを実行
- `make install` - update, deploy, initを一括実行

**除外リスト（`EXCLUSIONS`）:**
`.DS_Store`, `.git`, `.gitmodules`, `.travis.yml`, `.cursor`, `.config`, `.claude`

`.config` はシンボリンクせず手動管理。`.claude` は除外リストにあるが、`make deploy`
が Makefile 内で**個別に**シンボリンクする（下記参照）。

`nvim/` はドット始まりでも `bin` でもないため `DOTFILES` の自動シンボリンク対象外。
そこで `.claude` と同様、`make deploy` が Makefile 内で**個別に** `~/.config/nvim`
→ リポジトリの `nvim/` をシンボリンクする（`make clean` で除去）。手動で張る場合は:

```bash
ln -sfn $(pwd)/nvim ~/.config/nvim
```

### .claude/ のデプロイ

`~/.claude` には Claude Code のランタイム状態（`projects/`, `todos/`, `history/`,
`shell-snapshots/`, `settings.local.json` 等）が同居するため、ディレクトリごと
シンボリンクはしない。`make deploy` が本体と同じ `ln -sfnv` で（`Makefile` の
`CLAUDE_FILES` / `CLAUDE_SKILLS` を用いて）次のように貼る：

- `CLAUDE.md` / `settings.json` / `ai.env` … `~/.claude/` 直下に個別リンク
- `skills/` … 実ディレクトリのまま、リポジトリの各スキルを `~/.claude/skills/<name>`
  に個別リンク（`session-start-hook` 等のランタイム/グローバルスキルと共存）

`make clean` でこれらのリンク（と他の dotfile・リポジトリ本体）が除去される。

#### 画像スキルの秘密管理（ai.env / 1Password）

`gen-image` / `review-image` は API キーを `.claude/ai.env` の **1Password 参照**
（`op://...`）で持ち、実行時に `op run --env-file=$HOME/.claude/ai.env -- ...` で
解決する。鍵そのものはリポジトリに含めない。利用前に `op signin` が必要。

### .zshenv vs .zshrc

- **.zshenv**: 環境変数とPATH設定（全てのzshで読み込まれる）
- **.zshrc**: エイリアス、プロンプト、プラグイン（インタラクティブシェルのみ）

### .config/mise/

mise（バージョン管理ツール）の設定ディレクトリ。

- `config.toml` - グローバルツール設定（Node.js, Bun等）
- `README.md` - miseとniの使い方ガイド（日本語）

## デプロイフロー

1. **Clone**: リポジトリをクローン
2. **Deploy**: `make deploy` でシンボリンクを作成
3. **Init**: `make init` で初期化スクリプトを実行（OS固有の設定）
4. **mise Setup**: `etc/init/mise_setup.sh` でNode.js、Bun、niをインストール

## テストフロー

`make test` を実行すると：

1. 共通テストを実行（deploy, skills_image, redirect, shellcheck）
2. OS固有のテストを実行（osx/ または linux/）
3. テスト結果を集計して表示

## 管理されているツール

### バージョン管理
- **mise**: Node.js, Bun, Python, Ruby等の統一管理
- **ni**: npm/yarn/pnpm/bunの統一インターフェース

### シェル
- **zsh**: メインシェル（プラグイン: zinit）
- **bash**: 互換性用

### エディタ・ターミナル
- **neovim**: メインエディタ（Lua + lazy.nvim、`nvim/` = `~/.config/nvim`）
- **tmux**: ターミナルマルチプレクサ

### 開発ツール
- **git**: バージョン管理
- **gh**: GitHub CLI
- **ghq**: リポジトリ管理
- **fzf**: ファジーファインダー
- **ripgrep**: 高速grep

## ワークスペース（ws）システム

作業ディレクトリの一元管理システムです。詳細は [WORKSPACE.md](WORKSPACE.md) を参照してください。

### 概要

* `~/ws/` - 唯一の作業入口
* `~/ws/slide`, `~/ws/paper`, `~/ws/note` - Google Drive 同期ディレクトリ
* `~/ws/obsidian` - Obsidian（iCloud 同期）
* `~/ws/local/` - ローカル専用（非同期）

### セットアップ

```bash
# 自動セットアップ（dotfiles インストール時）
make install

# 手動セットアップ
bash ~/.dotfiles/etc/init/ws_setup.sh
```

詳細な運用ルールやトラブルシューティングについては [WORKSPACE.md](WORKSPACE.md) を参照してください。

## メンテナンス

### ファイルの追加
新しいdotfileを追加する場合：
1. ルートディレクトリに配置
2. `make deploy` で自動的にシンボリンク作成
3. 除外したい場合は `Makefile` の `EXCLUSIONS` に追加

### テストの追加
新しいテストを追加する場合：
1. `etc/test/` に `*_test.sh` を作成
2. `unit1()`, `unit2()` などの関数でテストを記述
3. `make test` で自動的に実行される

### 初期化スクリプトの追加
1. `etc/init/[os]/` に新しいスクリプトを追加
2. `etc/init/init.sh` または OS固有の初期化スクリプトから呼び出す
