#!/bin/bash

# macOSのデフォルト設定を変更するスクリプト
# 実行方法: ./macos_defaults.sh

echo "Setting macOS defaults..."

# Finder関連の設定
defaults write NSGlobalDomain AppleShowAllExtensions -bool true  # 拡張子まで表示
defaults write com.apple.Finder AppleShowAllFiles -bool true     # 隠しファイルを表示
defaults write com.apple.finder ShowPathbar -bool true           # パスバーを表示
defaults write com.apple.finder WarnOnEmptyTrash -bool false     # ゴミ箱を空にする際の警告を無効化
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false  # 拡張子変更時の警告を無効化
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true  # タイトルバーにフルパスを表示

# システム全体の設定
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"  # スクロールバーを常に表示
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true  # 保存ダイアログを拡張
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false  # 新規ドキュメントをiCloudに保存しない

# セキュリティ関連の設定
defaults write com.apple.LaunchServices LSQuarantine -bool false  # 未確認ファイルを開く際の警告を無効化
defaults write com.apple.screensaver askForPassword -int 1  # スクリーンセーバーからの復帰時にパスワードを要求
defaults write com.apple.screensaver askForPasswordDelay -int 0  # スクリーンセーバーからの復帰時のパスワード要求を即時

# キーボードとマウスの設定
defaults write NSGlobalDomain KeyRepeat -int 2  # キーリピート速度
defaults write NSGlobalDomain InitialKeyRepeat -int 15  # キーリピート開始までの時間
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1  # タップでクリック
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1.5  # トラックパッドの感度

# Dockの設定
defaults write com.apple.dock autohide -bool true  # Dockを自動的に隠す
defaults write com.apple.dock autohide-delay -float 0  # Dockの自動非表示の遅延を0に
defaults write com.apple.dock autohide-time-modifier -float 0.5  # Dockの表示/非表示のアニメーション速度
defaults write com.apple.dock show-recents -bool false  # 最近使った項目を表示しない

# メニューバーの設定
defaults write com.apple.menuextra.battery ShowPercent -string "YES"  # バッテリー残量をパーセント表示
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm"  # 日付と時刻の表示形式

# スクリーンショットの設定
defaults write com.apple.screencapture location -string "$HOME/Desktop"  # スクリーンショットの保存先
defaults write com.apple.screencapture type -string "png"  # スクリーンショットの形式
defaults write com.apple.screencapture disable-shadow -bool true  # スクリーンショットの影を無効化

# アプリケーションの設定
defaults write com.apple.Safari IncludeDevelopMenu -bool true  # Safariの開発メニューを表示
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true  # Safariの開発者向け機能を有効化
defaults write com.apple.Terminal "Default Window Settings" -string "Pro"  # ターミナルのデフォルトプロファイル
defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"  # ターミナルの起動時のプロファイル

# 設定の反映
killall Finder
killall Dock
killall SystemUIServer

echo "Done! Some changes may require a restart to take effect." 