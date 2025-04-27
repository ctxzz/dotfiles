#!/bin/bash

# Linuxの設定を自動化するシェルスクリプト
# 実行方法: ./linux_settings.sh

echo "Setting Linux defaults..."

# ディレクトリの作成
mkdir -p ~/.config/autostart
mkdir -p ~/.local/share/applications

# ファイルマネージャーの設定（Nautilusの場合）
if command -v gsettings &> /dev/null; then
    # 隠しファイルを表示
    gsettings set org.gnome.nautilus.preferences show-hidden-files true
    # 拡張子を表示
    gsettings set org.gtk.Settings.FileChooser show-hidden true
    # サイドバーを表示
    gsettings set org.gnome.nautilus.window-state sidebar-width 200
fi

# 電源設定
if command -v gsettings &> /dev/null; then
    # スリープ設定
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 1800
    # バッテリー設定
    gsettings set org.gnome.settings-daemon.plugins.power percentage-low 20
    gsettings set org.gnome.settings-daemon.plugins.power percentage-critical 10
fi

# キーボード設定
if command -v gsettings &> /dev/null; then
    # キーボードリピート
    gsettings set org.gnome.desktop.peripherals.keyboard repeat true
    gsettings set org.gnome.desktop.peripherals.keyboard delay 250
    gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
fi

# マウス設定
if command -v gsettings &> /dev/null; then
    # マウス速度
    gsettings set org.gnome.desktop.peripherals.mouse speed 0.5
    # タッチパッド設定
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
fi

# 通知設定
if command -v gsettings &> /dev/null; then
    gsettings set org.gnome.desktop.notifications show-banners true
    gsettings set org.gnome.desktop.notifications show-in-lock-screen false
fi

# フォント設定
if command -v gsettings &> /dev/null; then
    gsettings set org.gnome.desktop.interface font-name 'Sans 10'
    gsettings set org.gnome.desktop.interface document-font-name 'Sans 10'
    gsettings set org.gnome.desktop.interface monospace-font-name 'Monospace 10'
fi

# テーマ設定
if command -v gsettings &> /dev/null; then
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
    gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
    gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
fi

# スクリーンセーバー設定
if command -v gsettings &> /dev/null; then
    gsettings set org.gnome.desktop.screensaver lock-enabled true
    gsettings set org.gnome.desktop.screensaver idle-activation-enabled true
    gsettings set org.gnome.desktop.session idle-delay 300
fi

# ウィンドウ設定
if command -v gsettings &> /dev/null; then
    gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
    gsettings set org.gnome.desktop.wm.preferences action-double-click-titlebar 'toggle-maximize'
fi

# アプリケーションの自動起動設定
cat > ~/.config/autostart/gnome-terminal.desktop << 'EOF'
[Desktop Entry]
Type=Application
Exec=gnome-terminal
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Terminal
Comment=Start Terminal on login
EOF

echo "Done! Some changes may require a restart to take effect." 