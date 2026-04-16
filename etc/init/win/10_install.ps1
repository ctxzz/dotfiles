# Windows package installation script
# Uses winget (built-in on Windows 10/11) with Chocolatey as fallback.
# Run with: powershell -ExecutionPolicy Bypass -File 10_install.ps1

Write-Host "`n==> Installing Windows packages..." -ForegroundColor Blue

# Determine available package manager
$useWinget = $false
$useChoco  = $false

if (Get-Command winget -ErrorAction SilentlyContinue) {
    $useWinget = $true
    Write-Host "✓ Using winget as package manager" -ForegroundColor Green
} elseif (Get-Command choco -ErrorAction SilentlyContinue) {
    $useChoco = $true
    Write-Host "✓ Using Chocolatey as package manager" -ForegroundColor Green
} else {
    # Install Chocolatey as fallback
    Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = `
        [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString(
        'https://chocolatey.org/install.ps1'))
    $useChoco = $true
}

function Install-Pkg {
    param(
        [string]$WingetId,
        [string]$ChocoId = ""
    )
    try {
        if ($useWinget -and $WingetId) {
            winget install --id $WingetId --silent `
                --accept-source-agreements --accept-package-agreements 2>&1 | Out-Null
            Write-Host "  ✓ $WingetId" -ForegroundColor Green
        } elseif ($useChoco -and $ChocoId) {
            choco install -y $ChocoId 2>&1 | Out-Null
            Write-Host "  ✓ $ChocoId" -ForegroundColor Green
        }
    } catch {
        Write-Host "  ! Failed to install $WingetId/$ChocoId (skipping)" -ForegroundColor Yellow
    }
}

# --- Development tools ---
Write-Host "`n==> Development tools" -ForegroundColor Blue
Install-Pkg "Git.Git"                        "git"
Install-Pkg "Microsoft.VisualStudioCode"     "vscode"
Install-Pkg "Python.Python.3"                "python"
Install-Pkg "OpenJS.NodeJS.LTS"              "nodejs-lts"
Install-Pkg "GoLang.Go"                      "golang"
Install-Pkg "Rustlang.Rustup"                "rust"
Install-Pkg "Docker.DockerDesktop"           "docker-desktop"
Install-Pkg "GitHub.cli"                     "gh"

# --- Shell and terminal utilities ---
Write-Host "`n==> Shell and terminal utilities" -ForegroundColor Blue
Install-Pkg "Microsoft.PowerShell"           ""
Install-Pkg "Microsoft.WindowsTerminal"      ""
Install-Pkg "Starship.Starship"              ""
Install-Pkg "junegunn.fzf"                   "fzf"
Install-Pkg "BurntSushi.ripgrep.MSVC"        "ripgrep"
Install-Pkg "sharkdp.bat"                    "bat"
Install-Pkg "sharkdp.fd"                     "fd"
Install-Pkg "eza-community.eza"              ""
Install-Pkg "jqlang.jq"                      "jq"

# --- System utilities ---
Write-Host "`n==> System utilities" -ForegroundColor Blue
Install-Pkg "7zip.7zip"                      "7zip"
Install-Pkg "Microsoft.PowerToys"            "powertoys"

# --- Applications ---
Write-Host "`n==> Applications" -ForegroundColor Blue
Install-Pkg "Google.Chrome"                  "googlechrome"
Install-Pkg "Mozilla.Firefox"                "firefox"
Install-Pkg "Zoom.Zoom"                      "zoom"
Install-Pkg "SlackTechnologies.Slack"        "slack"
Install-Pkg "VideoLAN.VLC"                   "vlc"
Install-Pkg "Discord.Discord"                "discord"

Write-Host "`n✓ Package installation completed" -ForegroundColor Green
Write-Host "Some software may require a restart to complete installation." -ForegroundColor Yellow
