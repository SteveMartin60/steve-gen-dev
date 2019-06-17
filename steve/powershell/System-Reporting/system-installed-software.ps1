CLS

#..............................................................................

#..............................................................................
Function Write-StartScreenMenuAppsInfo
{
    foreach($App in $StartApps)
    {
        $SoftwareInfo.Add("------------------------------------")
        $SoftwareInfo.Add($App                                  )
    }
}
#..............................................................................

#..............................................................................
Function Write-StartScreenMenuAppsHeader
{
    $SoftwareInfo.Add(""                                                    )
    $SoftwareInfo.Add("****************************************************")
    $SoftwareInfo.Add("*                                                  *")
    $SoftwareInfo.Add("*              Start Screen/Menu Apps              *")
    $SoftwareInfo.Add("*                                                  *")
    $SoftwareInfo.Add("****************************************************")
    $SoftwareInfo.Add(""                                                    )
}
#..............................................................................

#..............................................................................
Function Write-InstalledWindowsApps_Store_Header
{
    $SoftwareInfo.Add(""                                                    )
    $SoftwareInfo.Add("****************************************************")
    $SoftwareInfo.Add("*                                                  *")
    $SoftwareInfo.Add("*          Installed Windows Apps (Store)          *")
    $SoftwareInfo.Add("*                                                  *")
    $SoftwareInfo.Add("****************************************************")
    $SoftwareInfo.Add(""                                                    )
}
#..............................................................................

#..............................................................................
Function Write-InstalledWindowsAppsInfo($AppxPackages)
{
    foreach($AppxPackage in $AppxPackages)
    {
        $UninstallString =  "Get-AppxPackage " + $AppxPackage.Name + " | Remove-AppxPackage"

        $SoftwareInfo.Add("===================================="        )
        $SoftwareInfo.Add("Windows 10 App Name: " + $AppxPackage.Name   )
        $SoftwareInfo.Add("------------------------------------"        )
        $SoftwareInfo.Add("Uninstall String       : " + $UninstallString)
        $SoftwareInfo.Add($AppxPackage                                  )
        $SoftwareInfo.Add("------------------------------------"        )
        $SoftwareInfo.Add(""                                            )
    }
}
#..............................................................................

#..............................................................................
Function Write-InstalledWindowsApps_System_Header
{
    $SoftwareInfo.Add(""                                                    )
    $SoftwareInfo.Add("****************************************************")
    $SoftwareInfo.Add("*                                                  *")
    $SoftwareInfo.Add("*          Installed Windows Apps (System)         *")
    $SoftwareInfo.Add("*                                                  *")
    $SoftwareInfo.Add("*          Warning: Uninstalling System Apps       *")
    $SoftwareInfo.Add("*             May Damage Your Computer             *")
    $SoftwareInfo.Add("*                                                  *")
    $SoftwareInfo.Add("****************************************************")
    $SoftwareInfo.Add(""                                                    )
}
#..............................................................................

#..............................................................................
Function Write-InstalledProgramsInfo
{
    foreach($Program in $Software)
    {
        if(!($Program.Length -eq 1))
        {
            $DisplayName = Get-DisplayName   ($Program)
            $Version     = Get-ProgramVersion($Program)

            $SoftwareInfo.Add("====================================")
            $SoftwareInfo.Add("Program Name   : " + $DisplayName    )
            $SoftwareInfo.Add("Program Version: " + $Version        )
            $SoftwareInfo.Add("------------------------------------")
            $SoftwareInfo.Add($Program                              )
            $SoftwareInfo.Add("------------------------------------")
            $SoftwareInfo.Add(""                                    )
        }
    }
}
#..............................................................................

#..............................................................................
Function Write-InstalledProgramsHeader
{
    $SoftwareInfo.Add("****************************************************")
    $SoftwareInfo.Add("*                                                  *")
    $SoftwareInfo.Add("*                Installed Programs                *")
    $SoftwareInfo.Add("*                                                  *")
    $SoftwareInfo.Add("****************************************************")
    $SoftwareInfo.Add(""                                                    )
}
#..............................................................................

#..............................................................................
Function Write-ReportHeader
{
    $SoftwareInfo.Add("========================================"        )
    $SoftwareInfo.Add("Installed Software Report"                       )
    $SoftwareInfo.Add("========================================"        )
    $SoftwareInfo.Add(""                                                )
    $SoftwareInfo.Add("==============================="                 )
    $SoftwareInfo.Add("Report Summary"                                  )
    $SoftwareInfo.Add("-------------------------------"                 )
    $SoftwareInfo.Add("Computer Name: " + $Env:COMPUTERNAME                 )
    $SoftwareInfo.Add("Command      : Get-StartApps"                    )
    $SoftwareInfo.Add("Command      : Get-AppxPackage"                  )
    $SoftwareInfo.Add("Report Date  : " + $Today                        )
    $SoftwareInfo.Add("-------------------------------"                 )
    $SoftwareInfo.Add("Total Installed Programs: " + $Software.    Count)
    $SoftwareInfo.Add("Total Windows 10 Apps   : " + $AppxPackageCount  )
    $SoftwareInfo.Add("Total Start Screen Apps : " + $StartApps.   Count)
    $SoftwareInfo.Add("-------------------------------"                 )
    $SoftwareInfo.Add(""                                                )
}
#..............................................................................

#..............................................................................
Function Get-ProgramVersion($Program)
{
    $Result = "Unknown"
    
    if($Program.DisplayVersion.Length -gt 0)
    {
        $Result = $Program.DisplayVersion
    }
    elseif($Program.Version.Length -gt 0)
    {
        $Result = $Program.Version
    }
    elseif(($Program.VersionMajor.Length -gt 0) -and ($Program.VersionMinor.Length -gt 0))
    {
        $Result = $Program.VersionMajor + "." + $Program.VersionMinor
    }
    
    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-DisplayName($Program)
{
    $Result = "Name Not Found"

    if($Program.DisplayName.Length -gt 1)
    {
        $Result = $Program.DisplayName
    }
    elseif($Program.UninstallString.Length -gt 1)
    {
        if($Program.UninstallString -match "productName")
        {
            $Location = $Program.UninstallString.IndexOf('productName')
            
            $Result = $Program.UninstallString.Substring($Location)

            $Result = $Result.Substring(($Result.IndexOf("""") + 1))

            $Result = $Result.Substring(0, $Result.IndexOf(""""))
        }
    }
    else
    {
        $Result = $Program.PSChildName
    }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Find-Software($Path)
{
    $SoftwareFound = Get-ItemProperty $Path

    foreach($Program in $SoftwareFound)
    {
        $Software += $Program
    }
}
#..............................................................................

#..............................................................................
Function Find-AllInstalledSoftware
{
    $Path = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'

    $SoftwareFound = Get-ItemProperty $Path

    foreach($Program in $SoftwareFound)
    {
        $Software += $Program
    }
    
    $Path = 'HKLM:\SOFTWARE\microsoft\Windows\CurrentVersion\Uninstall\*'

    $SoftwareFound = Get-ItemProperty $Path

    foreach($Program in $SoftwareFound)
    {
        $Software += $Program
    }

    $Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
            
    $SoftwareFound = Get-ItemProperty $Path

    foreach($Program in $SoftwareFound)
    {
        $Software += $Program
    }
}
#..............................................................................

#..............................................................................

$ComputerName = $env:COMPUTERNAME

$DisplayName = ""

$SoftwareReport = @()

$Software  = New-Object Object

$SoftwareTemp = @{}

$Software = {$SoftwareInfoTemp}.Invoke()

$StartApps    = Get-StartApps

$AppxPackagesStore  = Get-AppxPackage | Where-Object SignatureKind -eq "Store"
$AppxPackagesSystem = Get-AppxPackage | Where-Object SignatureKind -eq "System"
$AppxPackageCount   = ($AppxPackagesStore.Count) + ($AppxPackagesSystem.Count)

$Today         = Get-Date -UFormat "%Y-%m-%d %H:%M"

$SoftwareInfo  = New-Object Object

$SoftwareInfoTemp = @{}

$SoftwareInfo = {$SoftwareInfoTemp}.Invoke()

Write-ReportHeader

Write-InstalledProgramsHeader

Write-InstalledProgramsInfo

Write-InstalledWindowsApps_System_Header

Write-InstalledWindowsAppsInfo($AppxPackagesSystem)

Write-InstalledWindowsApps_Store_Header

Write-InstalledWindowsAppsInfo($AppxPackagesStore)

Write-StartScreenMenuAppsHeader

Write-StartScreenMenuAppsInfo

$SoftwareInfo.Add("------------------------------------"        )

$SoftwareInfo | Out-File "System-Installed-Software.txt"
