CLS

Write-Host "Setting Password Policy..."
#..............................................................................

#..............................................................................
$FileName = "${env:appdata}\secpol.cfg"

[String[]] $FileIntermediate = @()
[String[]] $FileOriginal     = @()
[String[]] $FileFinal        = @()

Set-Content $FileName $FileFinal

SecEdit /export /cfg $FileName

$StartSystemAccessValues = "MinimumPasswordAge"
$StartRegistryValues     = "CachedLogonsCount"

$P1 = "LockoutBadCount"
$P2 = "ResetLockoutCount"
$P3 = "LockoutDuration"
$P4 = "DisableCAD"

$FileOriginal = Get-Content $FileName

Foreach ($Line in $FileOriginal)
{    
    if (!($Line -match $P1) -and !($Line -match $P2) -and !($Line -match $P3) -and !($Line -match $P4))
    {
        $FileIntermediate += $Line
    }
}

Set-Content $FileName $FileIntermediate

Foreach ($Line in $FileIntermediate)
{    
    $FileFinal += $Line

    if ($Line -match $StartSystemAccessValues) 
    {
        $FileFinal += 'LockoutBadCount = 12'
        $FileFinal += 'ResetLockoutCount = 12'
        $FileFinal += 'LockoutDuration = 12'
    }
}

Foreach ($Line in $FileIntermediate)
{    
    $FileFinal += $Line

    if ($Line -match $StartRegistryValues)
    {
        $FileFinal += '"MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableCAD=4,0"'
    }
}

Set-Content $FileName $FileFinal

(Get-Content $FileName).replace("PasswordComplexity = 1"   , "PasswordComplexity = 0")    | Out-File $FileName
(Get-Content $FileName).replace("MinimumPasswordLength = 0", "MinimumPasswordLength = 9") | Out-File $FileName
(Get-Content $FileName).replace("EnableAdminAccount = 1"   , "EnableAdminAccount = 0")    | Out-File $FileName
(Get-Content $FileName).replace("EnableGuestAccount = 1"   , "EnableGuestAccount = 0")    | Out-File $FileName

SecEdit /configure /db c:\windows\security\local.sdb /cfg ${env:appdata}\secpol.cfg /areas SECURITYPOLICY

Remove-Item -Force ${env:appdata}\secpol.cfg -Confirm:$false

Write-Host
Write-Host "All Done!"
