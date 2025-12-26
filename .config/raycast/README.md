# Raycast Configuration

## セットアップ方法

1. Raycastのインストール:
   ```bash
   brew install --cask raycast
   ```

2. Script Commandsディレクトリの追加:
   - Raycast Settings を開く
   - Extensions > Script Commands > Add Directory
   - `~/.config/raycast/scripts` を選択

3. Raycast設定のインポート:
   - `configs/` ディレクトリ内の最新の `.rayconfig` ファイルをRaycastにインポート
   - Raycast Settings > Advanced > Import Settings

## ディレクトリ構成

- `scripts/` - カスタムscript commands
  - `navigation/` - ファイル・プロジェクト移動系
  - `development/` - 開発ツール系
  - `media/` - メディア制御系
  - `system/` - システム操作系
- `configs/` - エクスポートした設定ファイル（.rayconfig）を保存

## 設定ファイルの管理

### エクスポート方法
1. Raycast Settings > Advanced > Export Settings
2. エクスポートされたファイル（例: `Raycast 2025-12-26 18.14.07.rayconfig`）を `configs/` ディレクトリに保存
3. Git にコミット

### インポート方法
1. `configs/` ディレクトリ内の最新の `.rayconfig` ファイルを選択
2. Raycast Settings > Advanced > Import Settings からインポート

## Script Command の作成方法

各スクリプトには以下のメタデータを含める：

```bash
#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Script Title
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🚀
# @raycast.packageName Category Name
# @raycast.argument1 { "type": "text", "placeholder": "Argument description" }

# Documentation:
# @raycast.description What this script does
# @raycast.author ctxzz
```

### モード一覧
- `silent` - 出力なし
- `compact` - 1行の簡潔な出力
- `fullOutput` - 全出力を表示
- `inline` - Raycast内にインライン表示

## 参考リンク

- [Raycast Script Commands 公式リポジトリ](https://github.com/raycast/script-commands)
- [Raycast Manual](https://manual.raycast.com/mac)
- [Raycast Manual - Script Commands](https://manual.raycast.com/script-commands)
- [Raycast Manual - Dynamic Placeholders](https://manual.raycast.com/dynamic-placeholders)

