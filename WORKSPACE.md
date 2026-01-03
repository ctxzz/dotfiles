# Workspace（ws）運用ルール

このドキュメントでは、作業ディレクトリを一元管理する**ワークスペース（ws）システム**について説明します。

## 目的

* クラウド同期しているもの／していないものを**一目で判別**できるようにする
* 日常的な作業ディレクトリを **1 か所（ws）に集約**する
* Google Drive の実体パスに含まれる **個人情報（メールアドレス）を隠蔽**する
* 将来マシンを移行しても、同じ構成を簡単に再現できるようにする

---

## 設計方針（要点）

* **`ws` は唯一の作業入口**
* **クラウド同期は `ws` 直下にのみ置く**
* **ローカル専用データは `ws/local` に集約**
* `Cloud` はクラウド実体への **抽象リンク置き場（裏側）**
* Google Drive のアカウント名（メールアドレス）は
  **ドキュメント・パス・スクリプトに書かない**

---

## 全体構成

```text
~
├── ws/                     # 作業用ワークスペース（唯一の入口）
│   ├── slide               # Google Drive（同期）
│   ├── paper               # Google Drive（同期）
│   ├── note                # Google Drive（同期）
│   ├── obsidian            # iCloud（同期）
│   └── local/              # ローカル専用（非同期）
│       ├── sandbox
│       └── work
└── Cloud/                  # クラウド同期実体（裏側）
    ├── GoogleDrive/
    └── iCloud/
```

---

## クラウド同期領域（ws 直下）

### slide

```text
~/ws/slide -> ~/Cloud/GoogleDrive/My Drive/03slide
```

* スライド・発表資料
* 共有・履歴管理が必要な成果物

### paper

```text
~/ws/paper -> ~/Cloud/GoogleDrive/My Drive/02thesis
```

* 論文・原稿
* バックアップ・同期重視

### note

```text
~/ws/note -> ~/Cloud/GoogleDrive/My Drive/06note
```

* メモ・下書き・軽量テキスト
* 検索性・可搬性重視

### obsidian

```text
~/ws/obsidian
  -> ~/Library/Mobile Documents/iCloud~md~obsidian/Documents
```

* Obsidian Vault
* iCloud 同期前提
* 思考メモ・知識管理専用
* Obsidian が実際に管理しているディレクトリを直接参照する
* Note: `~/Cloud/iCloud` シンボリックリンクを経由することも可能

---

## ローカル専用領域（ws/local）

```text
~/ws/local
```

* **この配下はすべて非同期**
* 見ただけで「ローカル専用」と分かることを最優先にする

### sandbox

```text
~/ws/local/sandbox
```

* 実験・検証・一時作業用
* 破壊してよいデータ

### work

```text
~/ws/local/work
```

* ローカル作業用の実体ディレクトリ
* 以下のような用途を想定：
  * 同期不要な作業データ
  * 機密性のあるデータ
  * build / dist などの生成物
  * cache / tmp
  * 外部に出したくない中間ファイル

---

## Google Drive パスの扱いについて（重要）

実際の Google Drive 実体は、次のように
**メールアドレスを含むディレクトリ名**になります。

```text
~/Library/CloudStorage/GoogleDrive-omata@xxx.com/
```

このメールアドレス部分は、

* ドキュメントに書きたくない
* スクリプトにも残したくない

ため、次の方針を取ります。

### 方針

* `GoogleDrive-omata*` に **部分一致**するディレクトリを自動検出
* それに対して

  ```text
  ~/Cloud/GoogleDrive
  ```

  という **固定名のシンボリックリンク**を作成
* 以降はこの抽象パスのみを使用する

---

## iCloud Drive パスの扱いについて

実際の iCloud Drive 実体は、次のように
**長いディレクトリ名**になります。

```text
~/Library/Mobile Documents/
```

このパスを直接参照すると可読性が低いため、次の方針を取ります。

### 方針

* iCloud Drive のルートディレクトリに対して

  ```text
  ~/Cloud/iCloud
  ```

  という **固定名のシンボリックリンク**を作成
* Obsidian などの iCloud 連携アプリは、`~/Cloud/iCloud` を経由して参照する
* Google Drive と同様、抽象パスを使用することで一貫性を保つ

---

## セットアップ方法

### 自動セットアップ（推奨）

dotfiles のインストール時に自動的にワークスペースがセットアップされます。

```bash
# dotfiles のインストール
cd ~/.dotfiles
make install
```

もしくは、ワークスペースのみをセットアップする場合：

```bash
# ワークスペースのみセットアップ
bash ~/.dotfiles/etc/init/ws_setup.sh
```

### 前提条件

#### システム要件

ワークスペースセットアップは **Homebrew** がインストールされている必要があります。`make install` 実行時は、以下の順序で処理されます：

1. Homebrew のインストール（`10_brew.sh`）
2. パッケージのインストール（`20_bundle.sh`）
3. **ワークスペースのセットアップ**（`30_workspace.sh`）

Homebrew がインストールされていない場合、ワークスペースセットアップは自動的にスキップされ、後で手動実行できます。

#### クラウドサービス（オプション）

**重要**: クラウドサービスは必須ではありません。Google Drive や Obsidian がインストールされていない場合でも、スクリプトは正常に動作し、`~/ws/local` を使用できます。

クラウド同期機能を使用する場合は、以下がインストールされている必要があります：

* **Google Drive for Desktop**（オプション：Google Drive 同期が必要な場合のみ）
  * `~/Library/CloudStorage/GoogleDrive-omata*` にマウントされていること
  * My Drive 内に `03slide`, `02thesis`, `06note` ディレクトリが存在すること
  * 初期同期が完了していること
* **Obsidian**（オプション：Obsidian を使用する場合のみ）
  * iCloud 同期が有効になっていること
  * `~/Library/Mobile Documents/iCloud~md~obsidian/Documents` が存在すること

### 初期セットアップ時の動作

新しいマシンでの初回セットアップ時：

1. **Homebrew 未インストールの場合**
   * ワークスペースセットアップはスキップされます
   * Homebrew インストール後、手動でワークスペースセットアップを実行してください

2. **Google Drive や Obsidian がまだインストールされていない場合**
   * スクリプトは警告メッセージを表示しますが、エラーで停止しません
   * `~/ws/local` ディレクトリは正常に作成されます
   * クラウドサービスのインストールとログイン完了後、スクリプトを再実行してください

```bash
# Homebrew インストール後、またはクラウドサービスログイン後に再セットアップ
bash ~/.dotfiles/etc/init/ws_setup.sh
```

スクリプトは冪等性があるため、何度実行しても安全です。

### セットアップスクリプトの動作

`etc/init/ws_setup.sh` は以下の処理を自動的に行います：

1. **基本ディレクトリの作成**
   * `~/ws/local` ディレクトリを作成
   * `~/Cloud` ディレクトリを作成

2. **Google Drive の検出とリンク作成**
   * `GoogleDrive-omata*` パターンでディレクトリを検索
   * `~/Cloud/GoogleDrive` シンボリックリンクを作成
   * `~/ws/slide`, `~/ws/paper`, `~/ws/note` リンクを作成

3. **iCloud のリンク作成**
   * `~/Cloud/iCloud` シンボリックリンクを作成（iCloud Drive ルート）
   * `~/ws/obsidian` シンボリックリンクを作成（Obsidian Vault）

4. **ローカルワークスペースの作成**
   * `~/ws/local/sandbox` ディレクトリを作成
   * `~/ws/local/work` ディレクトリを作成

### セットアップ後の確認

```bash
# ワークスペース構造を確認
ls -la ~/ws/

# シンボリックリンクの確認
ls -l ~/ws/slide
ls -l ~/ws/paper
ls -l ~/ws/note
ls -l ~/ws/obsidian

# Cloud ディレクトリの確認
ls -l ~/Cloud/GoogleDrive
ls -l ~/Cloud/iCloud
```

---

## 運用ルール（簡潔）

* 作業は **必ず `~/ws` から開始**
* `ws` 直下
  → クラウド同期対象
* `ws/local` 配下
  → ローカル専用・非同期・機密可
* 新しい作業単位を追加する場合：
  * 同期したい → Google Drive に作り、`ws` にリンク
  * 同期不要 → `ws/local` に作る

---

## トラブルシューティング

### Google Drive が見つからない

```text
Google Drive not found: ~/Library/CloudStorage/GoogleDrive-omata*
```

**解決方法：**
1. Google Drive for Desktop がインストールされているか確認
2. Google Drive が起動しているか確認
3. Google アカウントでログインしているか確認

### Obsidian ディレクトリが見つからない

```text
Obsidian iCloud directory not found
```

**解決方法：**
1. Obsidian がインストールされているか確認
2. Obsidian で iCloud 同期が有効になっているか確認
3. iCloud Drive が有効になっているか確認（システム設定 → Apple ID → iCloud）

### シンボリックリンクが既に存在する

スクリプトは既存のシンボリックリンクをスキップします。
異なるターゲットを指している場合は警告が表示されますが、上書きはしません。

手動で削除してから再実行してください：

```bash
rm ~/ws/slide  # 例：slide リンクを削除
bash ~/.dotfiles/etc/init/ws_setup.sh
```

---

## 既存の Raycast スクリプトとの統合

このワークスペースシステムは、既存の Raycast ワークフローと統合されています：

* **Start Development Mode**（`.config/raycast/scripts/workflow/start-development-mode.sh`）
  * 例として、`~/ws/local/work/hama-med`（ユーザーが任意に作成する開発用ディレクトリ）からプロジェクトを検索します
* **Start Meeting Mode**（`.config/raycast/scripts/workflow/start-meeting-mode.sh`）
  * `~/ws/slide` からスライドディレクトリを検索

これらのスクリプトは、ワークスペースシステムを前提として設計されています。`~/ws/local/work/hama-med` などのプロジェクト用ディレクトリは `ws_setup.sh` では自動作成されないため、必要に応じてユーザーが `~/ws` 配下に任意の名前で作成し、スクリプト側のパス設定も適宜変更してください。

---

## 参考

* Google Drive for Desktop: https://www.google.com/drive/download/
* Obsidian: https://obsidian.md/
