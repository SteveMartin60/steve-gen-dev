CLS

#..............................................................................

#..............................................................................

function Get-WindowsKey
{
    param ($targets = ".")

    $hklm = 2147483650

    $regPath = "Software\Microsoft\Windows NT\CurrentVersion"

    $regValue = "DigitalProductId"

    foreach ($target in $targets)
    {
        $productKey = $null
        $wmi        = [WMIClass]"\\$target\root\default:stdRegProv"
        $data       = $wmi.GetBinaryValue($hklm,$regPath,$regValue)
        $binArray   = ($data.uValue)[52..66]
        $charsArray = "B","C","D","F","G","H","J","K","M","P","Q","R","T","V","W","X","Y","2","3","4","6","7","8","9"

        ## decrypt base24 encoded binary data
        for ($i = 24; $i -ge 0; $i--)
        {
            $k = 0

            for ($j = 14; $j -ge 0; $j--)
            {
                $k = $k * 256 -bxor $binArray[$j]
                $binArray[$j] = [math]::truncate($k / 24)
                $k = $k % 24
            }

            $productKey = $charsArray[$k] + $productKey

            if (($i % 5 -eq 0) -and ($i -ne 0))
            {
                $productKey = "-" + $productKey
            }
        }


        $productkey
    }
}

#..............................................................................

#..............................................................................
Function Convert-BytesToSize
{
    [CmdletBinding()]
    Param([parameter(Mandatory=$False,Position=0)][int64]$Size)

    Switch ($Size)
    {
        {$Size -gt 1PB} {$NewSize = “$([math]::Round(($Size / 1PB),2))PB”; Break}
        {$Size -gt 1TB} {$NewSize = “$([math]::Round(($Size / 1TB),2))TB”; Break}
        {$Size -gt 1GB} {$NewSize = “$([math]::Round(($Size / 1GB),2))TB”; Break}
        {$Size -gt 1MB} {$NewSize = “$([math]::Round(($Size / 1MB),2))GB”; Break}
        {$Size -gt 1KB} {$NewSize = “$([math]::Round(($Size / 1KB),2))MB”; Break}
        Default         {$NewSize = “$([math]::Round($Size,2))Bytes”; Break}
    }

    Return $NewSize
}
#..............................................................................

#..............................................................................

$WindowsKey = Get-WindowsKey

$obj = New-Object Object

$OSData       = Get-WmiObject -class Win32_OperatingSystem
$ComputerName = $OSData.__SERVER
$LastReboot   = $OSData.ConvertToDateTime($OSData.LastBootUpTime)
$TimeNow      = Get-Date
$UpTime       = $TimeNow - $LastReboot

$TimeZone = Get-TimeZone

$HomeLocal = Get-WinHomeLocation

$Languages = (Get-WinUserLanguageList).LocalizedName

$OSLanguage = (GET-CULTURE).EnglishName

$FreePhysicalMemory      = Convert-BytesToSize $OSData.FreePhysicalMemory
$FreeSpaceInPagingFiles  = Convert-BytesToSize $OSData.FreeSpaceInPagingFiles
$FreeVirtualMemory       = Convert-BytesToSize $OSData.FreeVirtualMemory
$MaxProcessMemorySize    = Convert-BytesToSize $OSData.MaxProcessMemorySize
$SizeStoredInPagingFiles = Convert-BytesToSize $OSData.SizeStoredInPagingFiles
$TotalVirtualMemorySize  = Convert-BytesToSize $OSData.TotalVirtualMemorySize
$TotalVisibleMemorySize  = Convert-BytesToSize $OSData.TotalVisibleMemorySize



Write-Host "----------------------------------------"
Write-Host "Operating System Report"
Write-Host "Computer Name: $ComputerName"
Write-Host "========================================"

$obj | Add-Member Noteproperty BootDevice                                -value $OSData.BootDevice
$obj | Add-Member Noteproperty BuildType                                 -value $OSData.BuildType
$obj | Add-Member Noteproperty CodeSet                                   -value $OSData.CodeSet
$obj | Add-Member Noteproperty CountryCode                               -value $OSData.CountryCode
$obj | Add-Member Noteproperty CreationClassName                         -value $OSData.CreationClassName
$obj | Add-Member Noteproperty CSCreationClassName                       -value $OSData.CSCreationClassName
$obj | Add-Member Noteproperty TimeZone                                  -value $TimeZone
$obj | Add-Member Noteproperty DataExecutionPrevention_32BitApplications -value $OSData.DataExecutionPrevention_32BitApplications
$obj | Add-Member Noteproperty DataExecutionPrevention_Available         -value $OSData.DataExecutionPrevention_Available
$obj | Add-Member Noteproperty DataExecutionPrevention_Drivers           -value $OSData.DataExecutionPrevention_Drivers
$obj | Add-Member Noteproperty DataExecutionPrevention_SupportPolicy     -value $OSData.DataExecutionPrevention_SupportPolicy
$obj | Add-Member Noteproperty Debug                                     -value $OSData.Debug
$obj | Add-Member Noteproperty Description                               -value $OSData.Description
$obj | Add-Member Noteproperty Distributed                               -value $OSData.Distributed
$obj | Add-Member Noteproperty EncryptionLevel                           -value $OSData.EncryptionLevel
$obj | Add-Member Noteproperty ForegroundApplicationBoost                -value $OSData.ForegroundApplicationBoost
$obj | Add-Member Noteproperty FreePhysicalMemory                        -value $FreePhysicalMemory
$obj | Add-Member Noteproperty FreeSpaceInPagingFiles                    -value $FreeSpaceInPagingFiles
$obj | Add-Member Noteproperty FreeVirtualMemory                         -value $FreeVirtualMemory
$obj | Add-Member Noteproperty InstallDate                               -value $OSData.ConvertToDateTime($OSData.InstallDate)
$obj | Add-Member Noteproperty LastBootUpTime                            -value $OSData.ConvertToDateTime($OSData.LastBootUpTime)
$obj | Add-Member Noteproperty LocalDateTime                             -value $OSData.ConvertToDateTime($OSData.LocalDateTime)
$obj | Add-Member Noteproperty Locale                                    -value $HomeLocal.HomeLocation
$obj | Add-Member Noteproperty Manufacturer                              -value $OSData.Manufacturer                                  
$obj | Add-Member Noteproperty MaxNumberOfProcesses                      -value $OSData.MaxNumberOfProcesses                          
$obj | Add-Member Noteproperty MaxProcessMemorySize                      -value $MaxProcessMemorySize
$obj | Add-Member Noteproperty MUILanguages                              -value $OSData.MUILanguages                                  
$obj | Add-Member Noteproperty Name                                      -value $OSData.Name                                          
$obj | Add-Member Noteproperty NumberOfLicensedUsers                     -value $OSData.NumberOfLicensedUsers                         
$obj | Add-Member Noteproperty NumberOfProcesses                         -value $OSData.NumberOfProcesses                             
$obj | Add-Member Noteproperty NumberOfUsers                             -value $OSData.NumberOfUsers                                 
$obj | Add-Member Noteproperty OperatingSystemSKU                        -value $OSData.OperatingSystemSKU                            
$obj | Add-Member Noteproperty Organization                              -value $OSData.Organization                                  
$obj | Add-Member Noteproperty OSArchitecture                            -value $OSData.OSArchitecture                                
$obj | Add-Member Noteproperty OSLanguage                                -value $OSLanguage                                    
$obj | Add-Member Noteproperty OSProductSuite                            -value $OSData.OSProductSuite                                
$obj | Add-Member Noteproperty OSType                                    -value $OSData.OSType                                        
$obj | Add-Member Noteproperty PortableOperatingSystem                   -value $OSData.PortableOperatingSystem
$obj | Add-Member Noteproperty Primary                                   -value $OSData.Primary
$obj | Add-Member Noteproperty ProductType                               -value $OSData.ProductType
$obj | Add-Member Noteproperty RegisteredUser                            -value $OSData.RegisteredUser
$obj | Add-Member Noteproperty SerialNumber                              -value $OSData.SerialNumber
$obj | Add-Member Noteproperty ServicePackMajorVersion                   -value $OSData.ServicePackMajorVersion
$obj | Add-Member Noteproperty ServicePackMinorVersion                   -value $OSData.ServicePackMinorVersion
$obj | Add-Member Noteproperty SizeStoredInPagingFiles                   -value $SizeStoredInPagingFiles
$obj | Add-Member Noteproperty Status                                    -value $OSData.Status                                        
$obj | Add-Member Noteproperty SuiteMask                                 -value $OSData.SuiteMask                                     
$obj | Add-Member Noteproperty SystemDevice                              -value $OSData.SystemDevice                                  
$obj | Add-Member Noteproperty SystemDirectory                           -value $OSData.SystemDirectory                               
$obj | Add-Member Noteproperty SystemDrive                               -value $OSData.SystemDrive                                   
$obj | Add-Member Noteproperty TotalVirtualMemorySize                    -value $TotalVirtualMemorySize
$obj | Add-Member Noteproperty TotalVisibleMemorySize                    -value $TotalVisibleMemorySize
$obj | Add-Member Noteproperty Version                                   -value $OSData.Version
$obj | Add-Member Noteproperty WindowsDirectory                          -value $OSData.WindowsDirectory
$obj | Add-Member Noteproperty CLASS                                     -value $OSData.__CLASS
$obj | Add-Member Noteproperty DERIVATION                                -value $OSData.__DERIVATION                                  
$obj | Add-Member Noteproperty DYNASTY                                   -value $OSData.__DYNASTY                                     
$obj | Add-Member Noteproperty GENUS                                     -value $OSData.__GENUS                                       
$obj | Add-Member Noteproperty NAMESPACE                                 -value $OSData.__NAMESPACE                                   
$obj | Add-Member Noteproperty PATH                                      -value $OSData.__PATH                                        
$obj | Add-Member Noteproperty PROPERTY_COUNT                            -value $OSData.__PROPERTY_COUNT                              
$obj | Add-Member Noteproperty RELPATH                                   -value $OSData.__RELPATH                                     
$obj | Add-Member Noteproperty SUPERCLASS                                -value $OSData.__SUPERCLASS                                  
$obj | Add-Member Noteproperty Computer                                  -value $OSData.PSComputerName
$obj | Add-Member Noteproperty Caption                                   -value $OSData.Caption
$obj | Add-Member Noteproperty Architecture                              -value $OSData.OSArchitecture
$obj | Add-Member Noteproperty BuildNumber                               -value $OSData.BuildNumber
$obj | Add-Member Noteproperty RegisteredTo                              -value $OSData.RegisteredUser
$obj | Add-Member Noteproperty ProductID                                 -value $OSData.SerialNumber
$obj | Add-Member Noteproperty ProductKey                                -value $WindowsKey
$obj | Add-Member Noteproperty InstalDate                                -value $OSData.ConvertToDateTime($OSData.InstallDate)
$obj | Add-Member Noteproperty Languages                                 -value $Languages


$obj
