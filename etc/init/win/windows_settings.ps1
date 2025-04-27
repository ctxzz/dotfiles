# Windowsの設定を自動化するPowerShellスクリプト
# 実行方法: powershell -ExecutionPolicy Bypass -File windows_settings.ps1

Write-Host "Setting Windows defaults..."

# エクスプローラーの設定
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1  # 隠しファイルを表示
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0  # 拡張子を表示
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Value 1  # システムファイルを表示

# タスクバーの設定
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Value 1  # 小さいタスクバーボタン
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Value 2  # タスクバーボタンを常に結合

# 電源設定
powercfg /change monitor-timeout-ac 30  # AC電源時のモニタータイムアウトを30分に
powercfg /change disk-timeout-ac 0  # AC電源時のディスクタイムアウトを無効に
powercfg /change standby-timeout-ac 0  # AC電源時のスタンバイを無効に
powercfg /change hibernate-timeout-ac 0  # AC電源時の休止を無効に

# マウス設定
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 1  # マウス速度
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 0  # マウス加速なし
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 0  # マウス加速なし

# キーボード設定
Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Value 0  # キーボードリピート遅延
Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardSpeed" -Value 31  # キーボードリピート速度

# フォントのスムージング設定
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothing" -Value 2  # ClearTypeを有効化
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothingType" -Value 2  # ClearTypeの設定

# スクリーンセーバー設定
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaveActive" -Value 0  # スクリーンセーバーを無効化

# 通知設定
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name "NOC_GLOBAL_SETTING_TOAST_SIZE" -Value 1  # 通知のサイズを小さく

# エクスプローラーの再起動
Stop-Process -Name explorer -Force
Start-Process explorer

Write-Host "Done! Some changes may require a restart to take effect." 