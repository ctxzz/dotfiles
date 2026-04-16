# Windows システム設定スクリプト
# Explorer, 電源, キーボード, マウス設定を自動化します
# Run with: powershell -ExecutionPolicy Bypass -File 30_settings.ps1

Write-Host "`n==> Setting Windows defaults..." -ForegroundColor Blue

# Explorer settings
Write-Host "Configuring Explorer..." -ForegroundColor Yellow
$explorerAdv = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $explorerAdv -Name "Hidden"          -Value 1  # Show hidden files
Set-ItemProperty -Path $explorerAdv -Name "HideFileExt"     -Value 0  # Show file extensions
Set-ItemProperty -Path $explorerAdv -Name "ShowSuperHidden" -Value 1  # Show system files
Set-ItemProperty -Path $explorerAdv -Name "TaskbarSmallIcons" -Value 1
Set-ItemProperty -Path $explorerAdv -Name "TaskbarGlomLevel"  -Value 2

# Power settings
Write-Host "Configuring power settings..." -ForegroundColor Yellow
powercfg /change monitor-timeout-ac 30  # Monitor off after 30 min on AC
powercfg /change disk-timeout-ac 0      # Never spin down disk on AC
powercfg /change standby-timeout-ac 0   # Never standby on AC
powercfg /change hibernate-timeout-ac 0 # Never hibernate on AC

# Mouse settings (disable acceleration)
Write-Host "Configuring mouse settings..." -ForegroundColor Yellow
$mouse = "HKCU:\Control Panel\Mouse"
Set-ItemProperty -Path $mouse -Name "MouseSpeed"      -Value 1
Set-ItemProperty -Path $mouse -Name "MouseThreshold1" -Value 0
Set-ItemProperty -Path $mouse -Name "MouseThreshold2" -Value 0

# Keyboard settings (fast repeat)
Write-Host "Configuring keyboard settings..." -ForegroundColor Yellow
$keyboard = "HKCU:\Control Panel\Keyboard"
Set-ItemProperty -Path $keyboard -Name "KeyboardDelay" -Value 0   # Shortest repeat delay
Set-ItemProperty -Path $keyboard -Name "KeyboardSpeed" -Value 31  # Fastest repeat rate

# Font smoothing (ClearType)
$desktop = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $desktop -Name "FontSmoothing"     -Value 2
Set-ItemProperty -Path $desktop -Name "FontSmoothingType" -Value 2

# Disable screensaver
Set-ItemProperty -Path $desktop -Name "ScreenSaveActive" -Value 0

# Create workspace directories (mirrors macOS/Linux ws structure)
Write-Host "Creating workspace directories..." -ForegroundColor Yellow
$wsDir = "$env:USERPROFILE\ws"
New-Item -ItemType Directory -Force -Path "$wsDir\local\sandbox" | Out-Null
New-Item -ItemType Directory -Force -Path "$wsDir\local\work"    | Out-Null
Write-Host "✓ Workspace directories created: $wsDir" -ForegroundColor Green

# Restart Explorer to apply registry changes
Write-Host "Restarting Explorer to apply changes..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Start-Process explorer

Write-Host "`n✓ Windows settings completed" -ForegroundColor Green
Write-Host "Some changes may require a restart to take effect." -ForegroundColor Yellow
