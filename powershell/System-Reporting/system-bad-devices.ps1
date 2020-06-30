CLS

#..............................................................................

#..............................................................................
Function Get-Availability($Availability)
{
    $Result = "Undefined Value"

    if ($Availability -eq 01) {$Result = "Other"                                                                                                                       }
    if ($Availability -eq 02) {$Result = "Unknown"                                                                                                                     }
    if ($Availability -eq 03) {$Result = "Running/Full Power"                                                                                                          }
    if ($Availability -eq 04) {$Result = "Warning"                                                                                                                     }
    if ($Availability -eq 05) {$Result = "In Test"                                                                                                                     }
    if ($Availability -eq 06) {$Result = "Not Applicable"                                                                                                              }
    if ($Availability -eq 07) {$Result = "Power Off"                                                                                                                   }
    if ($Availability -eq 08) {$Result = "Off Line"                                                                                                                    }
    if ($Availability -eq 09) {$Result = "Off Duty"                                                                                                                    }
    if ($Availability -eq 10) {$Result = "Degraded"                                                                                                                    }
    if ($Availability -eq 11) {$Result = "Not Installed"                                                                                                               }
    if ($Availability -eq 12) {$Result = "Install Error"                                                                                                               }
    if ($Availability -eq 13) {$Result = "Power Save - Unknown: The device is known to be in a power save mode, but its exact status is unknown"                       }
    if ($Availability -eq 14) {$Result = "Power Save - Low Power Mode: The device is in a power save state but still functioning, and may exhibit degraded performance"}
    if ($Availability -eq 15) {$Result = "Power Save - Standby: The device is not functioning but could be brought to full power quickly"                              }
    if ($Availability -eq 16) {$Result = "Power Cycle"                                                                                                                 }
    if ($Availability -eq 17) {$Result = "Power Save - Warning: The device is in a warning state, though also in a power save mode"                                    }
    if ($Availability -eq 18) {$Result = "Paused: The device is paused"                                                                                                }
    if ($Availability -eq 19) {$Result = "Not Ready: The device is not ready"                                                                                          }
    if ($Availability -eq 20) {$Result = "Not Configured: The device is not configured"                                                                                }
    if ($Availability -eq 21) {$Result = "Quiesced: The device is quiet"                                                                                               }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-ConfigManagerErrorCode($ConfigManagerErrorCode)
{
    $Result = "Undefined Value"

    if ($ConfigManagerErrorCode -eq 00) {$Result = "This device is working properly"                                                                                                                 }
    if ($ConfigManagerErrorCode -eq 01) {$Result = "This device is not configured correctly"                                                                                                         }
    if ($ConfigManagerErrorCode -eq 02) {$Result = "Windows cannot load the driver for this device"                                                                                                  }
    if ($ConfigManagerErrorCode -eq 03) {$Result = "The driver for this device might be corrupted, or your system may be running low on memory or other resources"                                   }
    if ($ConfigManagerErrorCode -eq 04) {$Result = "This device is not working properly. One of its drivers or your registry might be corrupted"                                                     }
    if ($ConfigManagerErrorCode -eq 05) {$Result = "The driver for this device needs a resource that Windows cannot manage"                                                                          }
    if ($ConfigManagerErrorCode -eq 06) {$Result = "The boot configuration for this device conflicts with other devices"                                                                             }
    if ($ConfigManagerErrorCode -eq 07) {$Result = "Cannot filter"                                                                                                                                   }
    if ($ConfigManagerErrorCode -eq 08) {$Result = "The driver loader for the device is missing"                                                                                                     }
    if ($ConfigManagerErrorCode -eq 09) {$Result = "This device is not working properly because the controlling firmware is reporting the resources for the device incorrectly"                      }
    if ($ConfigManagerErrorCode -eq 10) {$Result = "This device cannot start"                                                                                                                        }
    if ($ConfigManagerErrorCode -eq 11) {$Result = "This device failed"                                                                                                                              }
    if ($ConfigManagerErrorCode -eq 12) {$Result = "This device cannot find enough free resources that it can use"                                                                                   }
    if ($ConfigManagerErrorCode -eq 13) {$Result = "Windows cannot verify this device's resources"                                                                                                   }
    if ($ConfigManagerErrorCode -eq 14) {$Result = "This device cannot work properly until you restart your computer"                                                                                }
    if ($ConfigManagerErrorCode -eq 15) {$Result = "This device is not working properly because there is probably a re-enumeration problem"                                                          }
    if ($ConfigManagerErrorCode -eq 16) {$Result = "Windows cannot identify all the resources this device uses"                                                                                      }
    if ($ConfigManagerErrorCode -eq 17) {$Result = "This device is asking for an unknown resource type"                                                                                              }
    if ($ConfigManagerErrorCode -eq 18) {$Result = "Reinstall the drivers for this device"                                                                                                           }
    if ($ConfigManagerErrorCode -eq 19) {$Result = "Failure using the VxD loader"                                                                                                                    }
    if ($ConfigManagerErrorCode -eq 20) {$Result = "Your registry might be corrupted"                                                                                                                }
    if ($ConfigManagerErrorCode -eq 21) {$Result = "System failure: Try changing the driver for this device. If that does not work, see your hardware documentation. Windows is removing this device"}
    if ($ConfigManagerErrorCode -eq 22) {$Result = "This device is disabled"                                                                                                                         }
    if ($ConfigManagerErrorCode -eq 23) {$Result = "System failure: Try changing the driver for this device. If that doesn't work, see your hardware documentation"                                  }
    if ($ConfigManagerErrorCode -eq 24) {$Result = "This device is not present, is not working properly, or does not have all its drivers installed"                                                 }
    if ($ConfigManagerErrorCode -eq 25) {$Result = "Windows is still setting up this device"                                                                                                         }
    if ($ConfigManagerErrorCode -eq 26) {$Result = "Windows is still setting up this device"                                                                                                         }
    if ($ConfigManagerErrorCode -eq 27) {$Result = "This device does not have valid log configuration"                                                                                               }
    if ($ConfigManagerErrorCode -eq 28) {$Result = "The drivers for this device are not installed"                                                                                                   }
    if ($ConfigManagerErrorCode -eq 29) {$Result = "This device is disabled because the firmware of the device did not give it the required resources"                                               }
    if ($ConfigManagerErrorCode -eq 30) {$Result = "This device is using an Interrupt Request (IRQ) resource that another device is using"                                                           }
    if ($ConfigManagerErrorCode -eq 31) {$Result = "This device is not working properly because Windows cannot load the drivers required for this device"                                            }

    Return $Result
}
#..............................................................................

#..............................................................................

$BadDevices = Get-WmiObject Win32_PNPEntity | Where {$_.ConfigManagerErrorcode -ne 0}

$BadDeviceCount = 0

foreach ($Device in $BadDevices)
{
    $BadDeviceCount++
}

$Today         = Get-Date -UFormat "%Y-%m-%d %H:%M:%S"

$BadDeviceInfoTemp = @{}

$BadDeviceInfo = {$BadDeviceInfoTemp}.Invoke()

$BadDeviceInfo.Add("========================================"              )
$BadDeviceInfo.Add("Bad Devices Report"                                    )
$BadDeviceInfo.Add("========================================"              )
$BadDeviceInfo.Add(""                                                      )
$BadDeviceInfo.Add("================================"                      )
$BadDeviceInfo.Add("Report Summary"                                        )
$BadDeviceInfo.Add("--------------------------------"                      )
$BadDeviceInfo.Add("Computer Name    : " + $Env:COMPUTERNAME                   )
$BadDeviceInfo.Add("WMI Class        : Win32_PNPEntity "                   )
$BadDeviceInfo.Add("Report Date      : " + $Today                          )
$BadDeviceInfo.Add("Total Bad Devices: " + $BadDeviceCount                 )
$BadDeviceInfo.Add("--------------------------------"                      )
$BadDeviceInfo.Add(""                                                      )

$BadDeviceCount = 0

foreach ($Device in $BadDevices)
{
    $BadDeviceCount++

    $Availability           = Get-Availability          ($Device.Availability          )
    $ConfigManagerErrorCode = Get-ConfigManagerErrorCode($Device.ConfigManagerErrorCode)

    $BadDeviceInfo.Add(    "==================================================")
    $BadDeviceInfo.Add(    "Bad Device " + [string]$BadDeviceCount + ": " + $Device.Name                     )
    $BadDeviceInfo.Add(    "--------------------------------------------------")
    $BadDeviceInfo.Add(    ""                                                  )

    $BadDeviceInfo.Add(    "Availability  : " + $Availability              )
    $BadDeviceInfo.Add(    "Caption       : " + $Device.Caption              )
    $BadDeviceInfo.Add(    "Config Manager User Config       : " + $Device.ConfigManagerUserConfig              )
    $BadDeviceInfo.Add(    "Status       : " + $Device.Status              )
    


    $BadDeviceInfo.Add(    "Class Guid    : " + $Device.ClassGuid              )
    $BadDeviceInfo.Add(    "Description   : " + $Device.Description            )
    $BadDeviceInfo.Add(    "Device ID     : " + $Device.DeviceID               )
    $BadDeviceInfo.Add(    "Manufacturer  : " + $Device.Manufacturer           )
    $BadDeviceInfo.Add(    "PNP Device ID : " + $Device.PNPDeviceID            )
    $BadDeviceInfo.Add(    "Service Name  : " + $Device.Service                )
    $BadDeviceInfo.Add(    "Error Code    : " + $ConfigManagerErrorCode )
    $BadDeviceInfo.Add(    "--------------------------------------------------")
    $BadDeviceInfo.Add(    ""                                                  )
}
#..............................................................................

#..............................................................................

$BadDeviceInfo | Out-File "Bad-Devices.txt"