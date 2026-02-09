# SketchyBar + AeroSpace Configuration

macOS 用の SketchyBar 設定ファイル。AeroSpace ウィンドウマネージャーと連携します。

## 構成

```
sketchybar/
├── sketchybarrc              # メインエントリポイント
├── bar.sh                    # バー外観設定
├── default.sh                # アイテムのデフォルト値
├── colors.sh                 # Catppuccin Macchiato カラーパレット
├── icons.sh                  # SF Symbols アイコン定義
├── items/
│   ├── spaces.sh             # AeroSpace ワークスペース表示
│   ├── front_app.sh          # フォーカス中のアプリ表示
│   └── widgets.sh            # 右側ウィジェット (時計, 音量, バッテリー, WiFi)
├── plugins/
│   ├── aerospace.sh          # ワークスペース切り替えハンドラ
│   ├── front_app.sh          # アプリアイコン表示
│   ├── icon_map_fn.sh        # アプリ名→アイコンマッピング (sketchybar-app-font)
│   ├── calendar.sh           # 日付・時刻表示
│   ├── volume.sh             # 音量表示
│   ├── battery.sh            # バッテリー状態表示
│   └── wifi.sh               # WiFi 速度表示
└── install.sh                # インストールスクリプト
```

## 特徴

- **個別ワークスペースアイテム**: 各ワークスペースが独立したアイテムとして描画され、フォーカス時にハイライト表示
- **exec-on-workspace-change 連携**: AeroSpace が直接 sketchybar にイベントを送信
- **クリックでワークスペース切り替え**: バー上のワークスペース番号をクリックして移動可能
- **Catppuccin Macchiato テーマ**: 統一されたカラーパレット
- **アプリ固有アイコン**: [sketchybar-app-font](https://github.com/kvndrsslr/sketchybar-app-font) によるアプリごとの専用アイコン表示

## インストール

```bash
cd sketchybar
chmod +x install.sh
./install.sh
```

## AeroSpace 側の設定

`~/.aerospace.toml` に以下を追加:

```toml
after-startup-command = [
  'exec-and-forget sketchybar'
]

exec-on-workspace-change = [
  '/bin/bash', '-c',
  'sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE'
]
```

ノード移動時は `--focus-follows-window` を付けてください:

```toml
[mode.main.binding]
alt-shift-1 = 'move-node-to-workspace 1 --focus-follows-window'
```

## 依存関係

- [SketchyBar](https://github.com/FelixKratz/SketchyBar): `brew install sketchybar`
- [AeroSpace](https://github.com/nikitabobko/AeroSpace): `brew install --cask nikitabobko/tap/aerospace`
- [sketchybar-app-font](https://github.com/kvndrsslr/sketchybar-app-font): `curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.32/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf`
- SF Pro フォント (macOS 標準搭載)

## 参考

- [AeroSpace Goodies - Show workspaces in Sketchybar](https://nikitabobko.github.io/AeroSpace/goodies#show-aerospace-workspaces-in-sketchybar)
- [awesome-sketchybar](https://github.com/nicolas-martin/awesome-sketchybar)
- [Kainoa-h/aerospace-sketchybar](https://github.com/Kainoa-h/aerospace-sketchybar)
