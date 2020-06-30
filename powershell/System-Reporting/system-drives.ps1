CLS

$ComputerName = $Env:COMPUTERNAME

$Drives = Get-WmiObject Win32_Volume | Select-Object -Property * | Sort-Object Caption

#..............................................................................

#..............................................................................
Function Convert-BytesToSize
{
    [CmdletBinding()]
    Param([parameter(Mandatory=$False,Position=0)][int64]$Size)
    
    $Result = $null

    if(($Size -gt 1PB)                     ) {$NewSize = $([math]::Round(($Size / 1PB),2)); $Result = $NewSize.ToString() + "PB"}
    if(($Size -gt 1TB) -and ($Size -lt 1PB)) {$NewSize = $([math]::Round(($Size / 1TB),2)); $Result = $NewSize.ToString() + "TB"}
    if(($Size -gt 1GB) -and ($Size -lt 1TB)) {$NewSize = $([math]::Round(($Size / 1GB),2)); $Result = $NewSize.ToString() + "GB"}
    if(($Size -gt 1MB) -and ($Size -lt 1GB)) {$NewSize = $([math]::Round(($Size / 1MB),2)); $Result = $NewSize.ToString() + "MB"}
    if(($Size -gt 1KB) -and ($Size -lt 1MB)) {$NewSize = $([math]::Round(($Size / 1KB),2)); $Result = $NewSize.ToString() + "KB"}

    if ($Result-eq $null)
    {
        $NewSize = $([math]::Round($Size,2))
        $Result = $NewSize.ToString() + " Bytes"
    }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-DriveType($DriveType)
{
    $Result = "Undefined Value"
    
    if ($DriveType -eq 0) {$Result = "Unknown"          }
    if ($DriveType -eq 1) {$Result = "No Root Directory"}
    if ($DriveType -eq 2) {$Result = "Removable Disk"   }
    if ($DriveType -eq 3) {$Result = "Local Disk"       }
    if ($DriveType -eq 4) {$Result = "Network Drive"    }
    if ($DriveType -eq 5) {$Result = "Compact Disk"     }
    if ($DriveType -eq 6) {$Result = "RAM Disk"         }
                        
    Return $Result

    Return
}
#..............................................................................

#..............................................................................
Function Get-DriveLetter($DriveLetter)
{
    $Result = $null

    if($DriveLetter.Length -lt 1)
    {
        $Result = "No Drive Letter Assigned"
    }
    else
    {
        $Result = $DriveLetter
    }

    Return $Result
}
#..............................................................................

#..............................................................................

$TotalDisksInstalled = $Disks.Length
$Today               = Get-Date -UFormat "%Y-%m-%d %H:%M:%S"
$DriveInfo           = New-Object Object
$DriveInfoTemp       = @{}
$DriveInfo           = {$DriveInfoTemp}.Invoke()

$DriveInfo.Add("========================================"              )
$DriveInfo.Add("System Disk Report"                                    )
$DriveInfo.Add("========================================"              )
$DriveInfo.Add(""                                                      )
$DriveInfo.Add("========================================"              )
$DriveInfo.Add("Report Summary"                                        )
$DriveInfo.Add("----------------------------------------"              )
$DriveInfo.Add("Computer Name: " + $Env:COMPUTERNAME                       )
$DriveInfo.Add("WMI Class    : Win32_Volume"                           )
$DriveInfo.Add("Report Date  : " + $Today                              )
$DriveInfo.Add("Total Disks  : " + $TotalDisksInstalled                )
$DriveInfo.Add("====================="                                 )
$DriveInfo.Add(""                                                      )


Foreach ($Drive in $Drives)
{
    $Capacity    = Convert-BytesToSize $Drive.Capacity
    $FreeSpace   = Convert-BytesToSize $Drive.FreeSpace
    $UsedSpace   = Convert-BytesToSize ($Drive.Capacity - $Drive.FreeSpace)

    $DriveType   = Get-DriveType  ($Drive.FormFactor               )
    $DriveLetter = Get-DriveLetter($Drive.DriveLetter              )

    $DriveInfo.Add("")
    $DriveInfo.Add("===================================="                                 )
    $DriveInfo.Add("Drive: " + $Drive.Caption                                             )
    $DriveInfo.Add("------------------------------------"                                 )
    $DriveInfo.Add("Capacity                    : "  + $Capacity                          )
    $DriveInfo.Add("Free Space                  : "  + $FreeSpace                         )
    $DriveInfo.Add("Used Space                  : "  + $UsedSpace                         )
    $DriveInfo.Add("Access                      : "  + $Drive.Access                      )
    $DriveInfo.Add("Automount                   : "  + $Drive.Automount                   )
    $DriveInfo.Add("Availability                : "  + $Drive.Availability                )
    $DriveInfo.Add("BlockSize                   : "  + $Drive.BlockSize                   )
    $DriveInfo.Add("BootVolume                  : "  + $Drive.BootVolume                  )
    $DriveInfo.Add("Capacity                    : "  + $Drive.Capacity                    )
    $DriveInfo.Add("Caption                     : "  + $Drive.Caption                     )
    $DriveInfo.Add("ClassPath                   : "  + $Drive.ClassPath                   )
    $DriveInfo.Add("Compressed                  : "  + $Drive.Compressed                  )
    $DriveInfo.Add("ConfigManagerErrorCode      : "  + $Drive.ConfigManagerErrorCode      )
    $DriveInfo.Add("ConfigManagerUserConfig     : "  + $Drive.ConfigManagerUserConfig     )
    $DriveInfo.Add("CreationClassName           : "  + $Drive.CreationClassName           )
    $DriveInfo.Add("Description                 : "  + $Drive.Description                 )
    $DriveInfo.Add("DeviceID                    : "  + $Drive.DeviceID                    )
    $DriveInfo.Add("DirtyBitSet                 : "  + $Drive.DirtyBitSet                 )
    $DriveInfo.Add("DriveLetter                 : "  + $DriveLetter                       )
    $DriveInfo.Add("DriveType                   : "  + $Drive.DriveType                   )
    $DriveInfo.Add("ErrorCleared                : "  + $Drive.ErrorCleared                )
    $DriveInfo.Add("ErrorDescription            : "  + $Drive.ErrorDescription            )
    $DriveInfo.Add("ErrorMethodology            : "  + $Drive.ErrorMethodology            )
    $DriveInfo.Add("FileSystem                  : "  + $Drive.FileSystem                  )
    $DriveInfo.Add("FreeSpace                   : "  + $Drive.FreeSpace                   )
    $DriveInfo.Add("IndexingEnabled             : "  + $Drive.IndexingEnabled             )
    $DriveInfo.Add("InstallDate                 : "  + $Drive.InstallDate                 )
    $DriveInfo.Add("Is Connected                : "  + $Drive.Scope.IsConnected           )
    $DriveInfo.Add("Label                       : "  + $Drive.Label                       )
    $DriveInfo.Add("LastErrorCode               : "  + $Drive.LastErrorCode               )
    $DriveInfo.Add("MaximumFileNameLength       : "  + $Drive.MaximumFileNameLength       )
    $DriveInfo.Add("Name                        : "  + $Drive.Name                        )
    $DriveInfo.Add("NumberOfBlocks              : "  + $Drive.NumberOfBlocks              )
    $DriveInfo.Add("PageFilePresent             : "  + $Drive.PageFilePresent             )
    $DriveInfo.Add("Path                        : "  + $Drive.Path                        )
    $DriveInfo.Add("PNPDeviceID                 : "  + $Drive.PNPDeviceID                 )
    $DriveInfo.Add("PowerManagementCapabilities : "  + $Drive.PowerManagementCapabilities )
    $DriveInfo.Add("PowerManagementSupported    : "  + $Drive.PowerManagementSupported    )
    $DriveInfo.Add("Purpose                     : "  + $Drive.Purpose                     )
    $DriveInfo.Add("QuotasEnabled               : "  + $Drive.QuotasEnabled               )
    $DriveInfo.Add("QuotasIncomplete            : "  + $Drive.QuotasIncomplete            )
    $DriveInfo.Add("QuotasRebuilding            : "  + $Drive.QuotasRebuilding            )
    $DriveInfo.Add("SerialNumber                : "  + $Drive.SerialNumber                )
    $DriveInfo.Add("Status                      : "  + $Drive.Status                      )
    $DriveInfo.Add("StatusInfo                  : "  + $Drive.StatusInfo                  )
    $DriveInfo.Add("SupportsDiskQuotas          : "  + $Drive.SupportsDiskQuotas          )
    $DriveInfo.Add("SupportsFileBasedCompression: "  + $Drive.SupportsFileBasedCompression)
    $DriveInfo.Add("SystemCreationClassName     : "  + $Drive.SystemCreationClassName     )
    $DriveInfo.Add("SystemName                  : "  + $Drive.SystemName                  )
    $DriveInfo.Add("SystemVolume                : "  + $Drive.SystemVolume                )
    $DriveInfo.Add("------------------------------------"                                 )
    $DriveInfo.Add(""                                                                     )

}

$DriveInfo | Out-File "Drive-Details.txt"

#$DriveInfo
