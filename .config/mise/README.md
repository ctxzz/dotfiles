# mise - 開発ツールバージョン管理

[mise](https://mise.jdx.dev/)は、Node.js、Python、Rubyなどの複数のプログラミング言語やツールのバージョンを統一管理できるツールです。

## 特徴

- **高速**: Rustで書かれており、asdfやnvmより高速
- **互換性**: asdfプラグインと.tool-versionsファイルに対応
- **統合管理**: nvm、nodebrew、pyenv、rbenvなどを置き換え可能
- **環境変数管理**: .envファイルのサポート（direnv代替）
- **タスクランナー**: プロジェクト固有のタスクを定義・実行可能

## インストール

```bash
# Homebrewでインストール
brew install mise

# シェルを再起動するか、設定を再読み込み
exec $SHELL
```

## 基本的な使い方

### グローバルツールのインストール

```bash
# Node.js LTSをインストール
mise use -g node@lts

# Bunをインストール
mise use -g bun@latest

# Pythonをインストール
mise use -g python@3.11

# インストール済みツールを確認
mise list
```

### プロジェクトごとの設定

```bash
# プロジェクトディレクトリで
cd my-project

# プロジェクト用のNode.jsバージョンを設定
mise use node@18.0.0

# .mise.tomlまたは.tool-versionsファイルが作成される
cat .tool-versions
# node 18.0.0
```

### 環境変数の管理

```bash
# プロジェクトの.mise.tomlで環境変数を設定
cat > .mise.toml <<EOF
[tools]
node = "18.0.0"

[env]
DATABASE_URL = "postgres://localhost/mydb"
API_KEY = "your-api-key"
EOF

# ディレクトリに入ると自動的に環境変数が設定される
cd my-project
echo $DATABASE_URL
```

## nvmやbunからの移行

### 現在のNode.jsバージョンを確認

```bash
# nvmの場合
nvm current

# 同じバージョンをmiseでインストール
mise use -g node@$(nvm current)
```

### Bunの移行

```bash
# 現在のBunバージョンを確認
bun --version

# miseでインストール
mise use -g bun@latest
```

### 移行後

nvmとbunの設定（.zshrc/.bashrc内）をコメントアウトまたは削除できます。

## 便利なコマンド

```bash
# 利用可能なツール一覧
mise plugins

# 特定ツールの利用可能バージョン
mise ls-remote node

# ツールの更新
mise upgrade node

# 古いバージョンの削除
mise prune

# 現在のディレクトリで有効なツールと環境変数を表示
mise current
```

## トラブルシューティング

### miseが認識されない

```bash
# シェルの設定を確認
cat ~/.zshrc | grep mise

# 手動で有効化
eval "$(mise activate zsh)"
```

### ツールのインストールに失敗する

```bash
# デバッグモードで実行
mise install -v node@20

# キャッシュをクリア
mise cache clear
```

## 参考リンク

- [公式ドキュメント](https://mise.jdx.dev/)
- [設定リファレンス](https://mise.jdx.dev/configuration.html)
- [利用可能なプラグイン](https://mise.jdx.dev/plugins.html)
