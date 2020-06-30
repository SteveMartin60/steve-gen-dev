CLS

$Drives = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=4" ProviderName

$Drives

[System.Collections.ArrayList]$MappedNetworkDrives = $Drives


foreach ($Drive in $Drives)
{
    $MappedNetworkDrives.Remove($Drive)
}

foreach ($Drive in $Drives)
{
    $MappedNetworkDrives.Add($Drive.ProviderName)
}

foreach ($DrivePath in $MappedNetworkDrives)
{
    
}


$MappedNetworkDrives
$MappedNetworkDrives

<#


Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=4" | ForEach-Object { Write-Host ("{0} {1}" -f ($_.DeviceID), ($_.ProviderName)) }

ForEach-Object { Write-Host ("{0} {1}" -f ($_.DeviceID), ($_.ProviderName)) }

New-PSDrive -Name "P" -PSProvider "FileSystem" -Root "\\Server01\Public"

#>


