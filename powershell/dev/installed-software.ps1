CLS

$Installed_1 = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*             | Select-Object DisplayName | Format-Table –AutoSize

foreach ($software in $Installed_1)
{
   Write-Host $software | Select-Object DisplayName
}


$Installed_2 = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName | Format-Table –AutoSize

