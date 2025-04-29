# Windowsのソフトウェアを自動インストールするPowerShellスクリプト
# 実行方法: powershell -ExecutionPolicy Bypass -File windows_install.ps1

Write-Host "Installing Windows software..."

# Chocolateyのインストール
if (!(Test-Path -Path "$env:ProgramData\chocolatey\bin\choco.exe")) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# 開発ツール
choco install -y git
choco install -y vscode
choco install -y python
choco install -y nodejs
choco install -y golang
choco install -y rust
choco install -y docker-desktop
choco install -y wsl2

# システムユーティリティ
choco install -y 7zip
choco install -y everything
choco install -y powertoys
choco install -y wox
choco install -y ditto
choco install -y autohotkey

# ネットワークツール
choco install -y wireshark
choco install -y putty
choco install -y winscp
choco install -y filezilla

# マルチメディア
choco install -y vlc
choco install -y gimp
choco install -y inkscape
choco install -y audacity

# ドキュメント
choco install -y sumatrapdf
choco install -y libreoffice-fresh

# ブラウザ
choco install -y googlechrome
choco install -y firefox

# コミュニケーションツール
choco install -y slack
choco install -y discord
choco install -y zoom
choco install -y microsoft-teams

# クラウドストレージ
choco install -y dropbox
choco install -y google-drive-file-stream

# 仮想化
choco install -y virtualbox
choco install -y vmware-workstation-player

Write-Host "Done! Some software may require a restart to complete installation." 