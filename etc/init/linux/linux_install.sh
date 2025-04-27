#!/bin/bash

# Linuxのソフトウェアを自動インストールするシェルスクリプト
# 実行方法: ./linux_install.sh

echo "Installing Linux software..."

# パッケージマネージャーの確認と更新
if command -v apt &> /dev/null; then
    # Debian/Ubuntu系
    sudo apt update
    sudo apt upgrade -y
    PACKAGE_MANAGER="apt"
elif command -v dnf &> /dev/null; then
    # Fedora系
    sudo dnf update -y
    PACKAGE_MANAGER="dnf"
elif command -v pacman &> /dev/null; then
    # Arch系
    sudo pacman -Syu --noconfirm
    PACKAGE_MANAGER="pacman"
else
    echo "Unsupported package manager"
    exit 1
fi

# 開発ツール
if [ "$PACKAGE_MANAGER" = "apt" ]; then
    sudo apt install -y build-essential
    sudo apt install -y git
    sudo apt install -y python3
    sudo apt install -y nodejs
    sudo apt install -y golang
    sudo apt install -y rustc
    sudo apt install -y docker.io
    sudo apt install -y code
elif [ "$PACKAGE_MANAGER" = "dnf" ]; then
    sudo dnf groupinstall -y "Development Tools"
    sudo dnf install -y git
    sudo dnf install -y python3
    sudo dnf install -y nodejs
    sudo dnf install -y golang
    sudo dnf install -y rust
    sudo dnf install -y docker
    sudo dnf install -y code
elif [ "$PACKAGE_MANAGER" = "pacman" ]; then
    sudo pacman -S --noconfirm base-devel
    sudo pacman -S --noconfirm git
    sudo pacman -S --noconfirm python
    sudo pacman -S --noconfirm nodejs
    sudo pacman -S --noconfirm go
    sudo pacman -S --noconfirm rust
    sudo pacman -S --noconfirm docker
    sudo pacman -S --noconfirm code
fi

# システムユーティリティ
if [ "$PACKAGE_MANAGER" = "apt" ]; then
    sudo apt install -y htop
    sudo apt install -y neofetch
    sudo apt install -y tmux
    sudo apt install -y zsh
    sudo apt install -y fzf
    sudo apt install -y ripgrep
    sudo apt install -y bat
elif [ "$PACKAGE_MANAGER" = "dnf" ]; then
    sudo dnf install -y htop
    sudo dnf install -y neofetch
    sudo dnf install -y tmux
    sudo dnf install -y zsh
    sudo dnf install -y fzf
    sudo dnf install -y ripgrep
    sudo dnf install -y bat
elif [ "$PACKAGE_MANAGER" = "pacman" ]; then
    sudo pacman -S --noconfirm htop
    sudo pacman -S --noconfirm neofetch
    sudo pacman -S --noconfirm tmux
    sudo pacman -S --noconfirm zsh
    sudo pacman -S --noconfirm fzf
    sudo pacman -S --noconfirm ripgrep
    sudo pacman -S --noconfirm bat
fi

# ネットワークツール
if [ "$PACKAGE_MANAGER" = "apt" ]; then
    sudo apt install -y wireshark
    sudo apt install -y nmap
    sudo apt install -y curl
    sudo apt install -y wget
elif [ "$PACKAGE_MANAGER" = "dnf" ]; then
    sudo dnf install -y wireshark
    sudo dnf install -y nmap
    sudo dnf install -y curl
    sudo dnf install -y wget
elif [ "$PACKAGE_MANAGER" = "pacman" ]; then
    sudo pacman -S --noconfirm wireshark-qt
    sudo pacman -S --noconfirm nmap
    sudo pacman -S --noconfirm curl
    sudo pacman -S --noconfirm wget
fi

# マルチメディア
if [ "$PACKAGE_MANAGER" = "apt" ]; then
    sudo apt install -y vlc
    sudo apt install -y gimp
    sudo apt install -y inkscape
    sudo apt install -y audacity
elif [ "$PACKAGE_MANAGER" = "dnf" ]; then
    sudo dnf install -y vlc
    sudo dnf install -y gimp
    sudo dnf install -y inkscape
    sudo dnf install -y audacity
elif [ "$PACKAGE_MANAGER" = "pacman" ]; then
    sudo pacman -S --noconfirm vlc
    sudo pacman -S --noconfirm gimp
    sudo pacman -S --noconfirm inkscape
    sudo pacman -S --noconfirm audacity
fi

# ドキュメント
if [ "$PACKAGE_MANAGER" = "apt" ]; then
    sudo apt install -y libreoffice
    sudo apt install -y evince
    sudo apt install -y okular
elif [ "$PACKAGE_MANAGER" = "dnf" ]; then
    sudo dnf install -y libreoffice
    sudo dnf install -y evince
    sudo dnf install -y okular
elif [ "$PACKAGE_MANAGER" = "pacman" ]; then
    sudo pacman -S --noconfirm libreoffice-fresh
    sudo pacman -S --noconfirm evince
    sudo pacman -S --noconfirm okular
fi

# ブラウザ
if [ "$PACKAGE_MANAGER" = "apt" ]; then
    sudo apt install -y firefox
    sudo apt install -y chromium-browser
elif [ "$PACKAGE_MANAGER" = "dnf" ]; then
    sudo dnf install -y firefox
    sudo dnf install -y chromium
elif [ "$PACKAGE_MANAGER" = "pacman" ]; then
    sudo pacman -S --noconfirm firefox
    sudo pacman -S --noconfirm chromium
fi

# コミュニケーションツール
if [ "$PACKAGE_MANAGER" = "apt" ]; then
    sudo apt install -y slack-desktop
    sudo apt install -y zoom
elif [ "$PACKAGE_MANAGER" = "dnf" ]; then
    sudo dnf install -y slack
    sudo dnf install -y zoom
elif [ "$PACKAGE_MANAGER" = "pacman" ]; then
    sudo pacman -S --noconfirm slack-desktop
    sudo pacman -S --noconfirm zoom
fi

# 仮想化
if [ "$PACKAGE_MANAGER" = "apt" ]; then
    sudo apt install -y virtualbox
    sudo apt install -y qemu
elif [ "$PACKAGE_MANAGER" = "dnf" ]; then
    sudo dnf install -y virtualbox
    sudo dnf install -y qemu
elif [ "$PACKAGE_MANAGER" = "pacman" ]; then
    sudo pacman -S --noconfirm virtualbox
    sudo pacman -S --noconfirm qemu
fi

echo "Done! Some software may require a restart to complete installation." 