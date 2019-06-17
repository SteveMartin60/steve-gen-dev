@ECHO OFF
wpeinit.exe /unattend=X:\Windows\System32\WinPEResolution.xml
cd X:\Windows\system32
Start Powershell
powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -File X:\Windows\system32\Boot-ExternalUSBDrive_64.ps1
CLS
GoTo:EOF
