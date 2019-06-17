CLS

Copy-Item -Force -Path '\\192.168.1.169\IT Management\Powershell\Powershell Scripts\Reporting\generate-report.ps1' -Destination '$env:LOCALAPPDATA\PowerShell\generate-report.ps1'

Copy-Item -Force -Path '\\192.168.1.169\IT Management\Powershell\Powershell Scripts\Reporting\generate-report.ps1' -Destination '$env:LOCALAPPDATA\PowerShell\generate-report.ps1'

Remove-Item '$env:LOCALAPPDATA\PowerShell\generate-report.ps1'
