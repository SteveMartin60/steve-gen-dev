CLS

$ComputerName = $Env:COMPUTERNAME

#..............................................................................

#..............................................................................

$Devices = Get-WmiObject Win32_PNPEntity

$DeviceCount = 0

foreach ($Device in $Devices)
{
    $DeviceCount++
}

$Today         = Get-Date -UFormat "%Y-%m-%d %H:%M:%S"

$DeviceInfoTemp = @{}

$DeviceInfo = {$DeviceInfoTemp}.Invoke()

$DeviceInfo.Add("========================================"              )
$DeviceInfo.Add("Bad Devices Report"                                    )
$DeviceInfo.Add("========================================"              )
$DeviceInfo.Add(""                                                      )
$DeviceInfo.Add("================================"                      )
$DeviceInfo.Add("Report Summary"                                        )
$DeviceInfo.Add("--------------------------------"                      )
$DeviceInfo.Add("Computer Name    : " + $Env:COMPUTERNAME                   )
$DeviceInfo.Add("WMI Class        : Win32_PNPEntity "                   )
$DeviceInfo.Add("Report Date      : " + $Today                          )
$DeviceInfo.Add("Total Bad Devices: " + $DeviceCount                 )
$DeviceInfo.Add("--------------------------------"                      )
$DeviceInfo.Add(""                                                      )

$DeviceCount = 0

foreach ($Device in $Devices)
{
    $DeviceCount++

    $DeviceInfo.Add(    "==================================================")
    $DeviceInfo.Add(    "Device " + [string]$DeviceCount + ": " + $Device.Name                     )
    $DeviceInfo.Add(    "--------------------------------------------------")
    $DeviceInfo.Add(    ""                                                  )
    $DeviceInfo.Add(    "Status        : " + $Device.Status              )
    $DeviceInfo.Add(    "Description   : " + $Device.Description            )
    $DeviceInfo.Add(    "Device ID     : " + $Device.DeviceID               )
    $DeviceInfo.Add(    "Manufacturer  : " + $Device.Manufacturer           )
    $DeviceInfo.Add(    "PNP Device ID : " + $Device.PNPDeviceID            )
    $DeviceInfo.Add(    "Service Name  : " + $Device.Service                )
    $DeviceInfo.Add(    "--------------------------------------------------")
    $DeviceInfo.Add(    ""                                                  )
}
#..............................................................................

#..............................................................................

$DeviceInfo | Out-File "PNP-Devices.txt"