CLS

Write-Host "Getting Installed Software..."

$Path   = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
$Output = @()
            
$Software01 = Get-ItemProperty $Path | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, UninstallString, InstallLocation, Version, URLInfoAbout, HelpLink

$Path = 'HKLM:\SOFTWARE\microsoft\Windows\CurrentVersion\Uninstall\*'
            
$Software02 = Get-ItemProperty $Path | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, UninstallString, InstallLocation, Version, URLInfoAbout, HelpLink

$SoftwareAll = $Software01 + $Software02

foreach($Line in $SoftwareAll)
{
    if($Line.DisplayName.Length -gt 0)
    {
        $Output += $Line
    }
}

$Output | Sort-Object DisplayName | Select-Object DisplayName, Publisher
