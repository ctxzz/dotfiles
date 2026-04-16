# mise セットアップスクリプト (Windows)
# mise, Node.js LTS, Bun, ni をインストールします
# Run with: powershell -ExecutionPolicy Bypass -File 20_mise.ps1

Write-Host "`n==> mise セットアップを開始します" -ForegroundColor Blue

# Install mise if not present
if (-not (Get-Command mise -ErrorAction SilentlyContinue)) {
    Write-Host "mise をインストールしています..." -ForegroundColor Yellow

    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id jdx.mise --silent `
            --accept-source-agreements --accept-package-agreements
    } else {
        # Direct download fallback
        $miseDir = "$env:USERPROFILE\.local\bin"
        New-Item -ItemType Directory -Force -Path $miseDir | Out-Null
        $miseUrl = "https://github.com/jdx/mise/releases/latest/download/mise-x86_64-pc-windows-msvc.zip"
        $zipPath = "$env:TEMP\mise.zip"
        Write-Host "Downloading mise from $miseUrl..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $miseUrl -OutFile $zipPath
        Expand-Archive -Path $zipPath -DestinationPath $miseDir -Force
        Remove-Item $zipPath -Force
        $env:PATH = "$miseDir;$env:PATH"
    }
}

if (-not (Get-Command mise -ErrorAction SilentlyContinue)) {
    Write-Host "✗ mise のインストールに失敗しました" -ForegroundColor Red
    exit 1
}

Write-Host "✓ mise が検出されました" -ForegroundColor Green

# Copy mise config if not already present
$miseConfigDir = "$env:USERPROFILE\.config\mise"
$dotpath = Resolve-Path "$PSScriptRoot\..\..\..\" -ErrorAction SilentlyContinue
if ($dotpath) {
    $miseConfigSrc = Join-Path $dotpath ".config\mise\config.toml"
    if (-not (Test-Path "$miseConfigDir\config.toml") -and (Test-Path $miseConfigSrc)) {
        Write-Host "mise設定ファイルをコピーしています..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Force -Path $miseConfigDir | Out-Null
        Copy-Item $miseConfigSrc "$miseConfigDir\config.toml"
        Write-Host "✓ mise設定ファイルをコピーしました" -ForegroundColor Green
    }
}

# Install Node.js LTS
Write-Host "`n==> Node.js LTS をインストールしています..." -ForegroundColor Blue
mise use --global node@lts
Write-Host "✓ Node.js LTS がインストールされました" -ForegroundColor Green

# Install Bun
Write-Host "`n==> Bun をインストールしています..." -ForegroundColor Blue
try {
    mise use --global bun@latest
    Write-Host "✓ Bun がインストールされました" -ForegroundColor Green
} catch {
    Write-Host "! Bun のインストールに失敗しました（スキップ）" -ForegroundColor Yellow
}

# Install ni via npm
Write-Host "`n==> ni (パッケージマネージャー統一ツール) をインストールしています..." -ForegroundColor Blue
try {
    mise exec -- npm install -g @antfu/ni
    Write-Host "✓ ni がインストールされました" -ForegroundColor Green
} catch {
    Write-Host "! ni のインストールに失敗しました" -ForegroundColor Yellow
}

# Show installed tools
Write-Host "`n==> インストール済みツール:" -ForegroundColor Blue
mise list

Write-Host "`n✓ mise セットアップが完了しました" -ForegroundColor Green
