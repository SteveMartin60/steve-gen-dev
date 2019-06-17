CLS

$ComputerName = $Env:COMPUTERNAME

#..............................................................................

#..............................................................................
Function Get-NetConnectionStatus($NetConnectionStatus)
{
    $Result = "Unknown Value"

    if ($NetConnectionStatus -eq 00) {$Result = 'Disconnected'            }
    if ($NetConnectionStatus -eq 01) {$Result = 'Connecting'              }
    if ($NetConnectionStatus -eq 02) {$Result = 'Connected'               }
    if ($NetConnectionStatus -eq 03) {$Result = 'Disconnecting'           }
    if ($NetConnectionStatus -eq 04) {$Result = 'Hardware Not Present'    }
    if ($NetConnectionStatus -eq 05) {$Result = 'Hardware Disabled'       }
    if ($NetConnectionStatus -eq 06) {$Result = 'Hardware Malfunction'    }
    if ($NetConnectionStatus -eq 07) {$Result = 'Media Disconnected'      }
    if ($NetConnectionStatus -eq 08) {$Result = 'Authenticating'          }
    if ($NetConnectionStatus -eq 09) {$Result = 'Authentication Succeeded'}
    if ($NetConnectionStatus -eq 10) {$Result = 'Authentication Failed'   }
    if ($NetConnectionStatus -eq 11) {$Result = 'Invalid Address'         }
    if ($NetConnectionStatus -eq 12) {$Result = 'Credentials Required'    }

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
Function Get-Availability($Availability)
{
    $Result = "Undefined Value"
    
    if ($Availability -eq 01  ) {$Result = 'Other'                      }
    if ($Availability -eq 02  ) {$Result = 'Unknown'                    }
    if ($Availability -eq 03  ) {$Result = 'Running/Full Power'         }
    if ($Availability -eq 04  ) {$Result = 'Warning'                    }
    if ($Availability -eq 05  ) {$Result = 'In Test'                    }
    if ($Availability -eq 06  ) {$Result = 'Not Applicable'             }
    if ($Availability -eq 07  ) {$Result = 'Power Off'                  }
    if ($Availability -eq 08  ) {$Result = 'Off Line'                   }
    if ($Availability -eq 09  ) {$Result = 'Off Duty'                   }
    if ($Availability -eq 10  ) {$Result = 'Degraded'                   }
    if ($Availability -eq 11  ) {$Result = 'Not Installed'              }
    if ($Availability -eq 12  ) {$Result = 'Install Error'              }
    if ($Availability -eq 13  ) {$Result = 'Power Save - Unknown'       }
    if ($Availability -eq 14  ) {$Result = 'Power Save - Low Power Mode'}
    if ($Availability -eq 15  ) {$Result = 'Power Save - Standby'       }
    if ($Availability -eq 16  ) {$Result = 'Power Cycle'                }
    if ($Availability -eq 17  ) {$Result = 'Power Save - Warning'       }
    if ($Availability -eq 18  ) {$Result = 'Paused'                     }
    if ($Availability -eq 19  ) {$Result = 'Not Ready'                  }
    if ($Availability -eq 20  ) {$Result = 'Not Configured'             }
    if ($Availability -eq 21  ) {$Result = 'Quiesced'                   }

    Return $Result
}                       
#..............................................................................

#..............................................................................
Function Get-TotalVPNAdapters($NetworkAdapters)
{
    $TotalVPNAdapters = 0

    foreach($NetworkAdapter in $NetworkAdapters)
    {
        if(
            ($NetworkAdapter.Caption     -match 'VPN') -or
            ($NetworkAdapter.Description -match 'VPN') -or
            ($NetworkAdapter.Name        -match 'VPN') -or
            ($NetworkAdapter.ProductName -match 'VPN')
          ) {$TotalVPNAdapters++     }
    }

    Return $TotalVPNAdapters
}
#..............................................................................

#..............................................................................
Function Get-TotalPhysicalAdapters($NetworkAdapters)
{
    $TotalPhysicalAdapters = 0

    foreach($NetworkAdapter in $NetworkAdapters)
    {
        if(($NetworkAdapter.PhysicalAdapter -eq $true) -and ($NetworkAdapter.PNPDeviceID -match 'PCI'))
        {
            $TotalPhysicalAdapters++     
        }
        if(($NetworkAdapter.PhysicalAdapter -eq $true) -and ($NetworkAdapter.PNPDeviceID -match 'BTH'))
        {
            $TotalPhysicalAdapters++     
        }
        if(($NetworkAdapter.PhysicalAdapter -eq $true) -and ($NetworkAdapter.PNPDeviceID -match 'USB'))
        {
            $TotalPhysicalAdapters++     
        }
    }

    Return $TotalPhysicalAdapters
}
#..............................................................................

#..............................................................................
Function Get-TotalSoftwareAdapters($NetworkAdapters)
{
    $TotalSoftwareAdapters = 0

    foreach($NetworkAdapter in $NetworkAdapters)
    {
        if($NetworkAdapter.PhysicalAdapter -eq $false)
        {
            $TotalSoftwareAdapters++     
        }
    }

    Return $TotalSoftwareAdapters
}
#..............................................................................

#..............................................................................
$NetworkAdapters = Get-WmiObject -Class Win32_NetworkAdapter | Sort-Object Name

$TotalNetworkAdapters  = 0
$TotalPhysicalAdapters = Get-TotalPhysicalAdapters($NetworkAdapters)
$TotalSoftwareAdapters = Get-TotalSoftwareAdapters($NetworkAdapters)
$TotalVPNAdapters      = Get-TotalVPNAdapters     ($NetworkAdapters)

$TotalNetworkAdapters = $NetworkAdapters.Length

$Today         = Get-Date -UFormat "%Y-%m-%d %H:%M:%S"

$NetworkAdaptersInfo  = New-Object Object

$NetworkAdaptersInfoTemp = @{}

$NetworkAdaptersInfo = {$NetworkAdaptersInfoTemp}.Invoke()

$NetworkAdaptersInfo.Add("========================================"              )
$NetworkAdaptersInfo.Add("System Network Adapters Report"                        )
$NetworkAdaptersInfo.Add("========================================"              )
$NetworkAdaptersInfo.Add(""                                                      )
$NetworkAdaptersInfo.Add("================================"                      )
$NetworkAdaptersInfo.Add("Report Summary"                                        )
$NetworkAdaptersInfo.Add("--------------------------------"                      )
$NetworkAdaptersInfo.Add("Computer Name: " + $Env:COMPUTERNAME                       )
$NetworkAdaptersInfo.Add("WMI Class    : Win32_NetworkAdapterConfiguration "     )
$NetworkAdaptersInfo.Add("Report Date  : " + $Today                              )
$NetworkAdaptersInfo.Add("--------------------------------"                      )
$NetworkAdaptersInfo.Add(""                                                      )
$NetworkAdaptersInfo.Add("======================="                               )
$NetworkAdaptersInfo.Add("Network Adapters Summary"                              )
$NetworkAdaptersInfo.Add("-----------------------"                               )
$NetworkAdaptersInfo.Add("Total Adapters   : " + $TotalNetworkAdapters           )
$NetworkAdaptersInfo.Add("Physical Adapters: " + $TotalPhysicalAdapters          )
$NetworkAdaptersInfo.Add("Software Adapters: " + $TotalSoftwareAdapters          )
$NetworkAdaptersInfo.Add("VPN Adapters     : " + $TotalVPNAdapters               )
$NetworkAdaptersInfo.Add("======================="                               )

$AdapterID = 0

Foreach ($Adapter in $NetworkAdapters)
{
    $AdapterID ++

    $Availability           = Get-Availability          ($Adapter.Availability)
    $ConfigManagerErrorCode = Get-ConfigManagerErrorCode($Adapter.ConfigManagerErrorCode)
    $LastResetTime          = $Adapter.ConvertToDateTime($Adapter.TimeOfLastReset) |Get-Date -Format "yyyy/MM/dd HH:mm"
    $NetConnectionStatus    = Get-NetConnectionStatus   ($Adapter.NetConnectionStatus)


    $NetworkAdaptersInfo.Add("")
    $NetworkAdaptersInfo.Add("===================================="                                 )
    $NetworkAdaptersInfo.Add("Adapter: " + $Adapter.Name                                            )
    $NetworkAdaptersInfo.Add("------------------------------------"                                 )

    
    if ($Adapter.AdapterType.                length -gt 0) {$NetworkAdaptersInfo.Add("Adapter Type                 : "  + $Adapter.AdapterType                )}
    if ($Adapter.AutoSense.                  length -gt 0) {$NetworkAdaptersInfo.Add("Auto Sense                   : "  + $Adapter.AutoSense                  )}
    if ($Adapter.Availability.               length -gt 0) {$NetworkAdaptersInfo.Add("Availability                 : "  + $Availability                       )}
    if ($Adapter.Caption.                    length -gt 0) {$NetworkAdaptersInfo.Add("Caption                      : "  + $Adapter.Caption                    )}
    if ($Adapter.ClassPath.                  length -gt 0) {$NetworkAdaptersInfo.Add("Class Path                   : "  + $Adapter.ClassPath                  )}
    if ($Adapter.ConfigManagerUserConfig.    length -gt 0) {$NetworkAdaptersInfo.Add("Config Manager User Config   : "  + $Adapter.ConfigManagerUserConfig    )}
    if ($Adapter.Description.                length -gt 0) {$NetworkAdaptersInfo.Add("Description                  : "  + $Adapter.Description                )}
    if ($Adapter.DeviceID.                   length -gt 0) {$NetworkAdaptersInfo.Add("Device ID                    : "  + $Adapter.DeviceID                   )}
    if ($Adapter.ErrorCleared.               length -gt 0) {$NetworkAdaptersInfo.Add("Error Cleared                : "  + $Adapter.ErrorCleared               )}
    if ($Adapter.ConfigManagerErrorCode.     length -gt 0) {$NetworkAdaptersInfo.Add("Error Code                   : "  + $ConfigManagerErrorCode             )}
    if ($Adapter.ErrorDescription.           length -gt 0) {$NetworkAdaptersInfo.Add("Error Description            : "  + $Adapter.ErrorDescription           )}
    if ($Adapter.GUID.                       length -gt 0) {$NetworkAdaptersInfo.Add("GUID                         : "  + $Adapter.GUID                       )}
    if ($Adapter.Index.                      length -gt 0) {$NetworkAdaptersInfo.Add("Index                        : "  + $Adapter.Index                      )}
    if ($Adapter.InstallDate.                length -gt 0) {$NetworkAdaptersInfo.Add("Install Date                 : "  + $Adapter.InstallDate                )}
    if ($Adapter.Installed.                  length -gt 0) {$NetworkAdaptersInfo.Add("Installed                    : "  + $Adapter.Installed                  )}
    if ($Adapter.InterfaceIndex.             length -gt 0) {$NetworkAdaptersInfo.Add("Interface Index              : "  + $Adapter.InterfaceIndex             )}
    if ($Adapter.LastErrorCode.              length -gt 0) {$NetworkAdaptersInfo.Add("Last Error Code              : "  + $Adapter.LastErrorCode              )}
    if ($Adapter.MACAddress.                 length -gt 0) {$NetworkAdaptersInfo.Add("MACAddress                   : "  + $Adapter.MACAddress                 )}
    if ($Adapter.Manufacturer.               length -gt 0) {$NetworkAdaptersInfo.Add("Manufacturer                 : "  + $Adapter.Manufacturer               )}
    if ($Adapter.MaxNumberControlled.        length -gt 0) {$NetworkAdaptersInfo.Add("Max Number Controlled        : "  + $Adapter.MaxNumberControlled        )}
    if ($Adapter.MaxSpeed.                   length -gt 0) {$NetworkAdaptersInfo.Add("Max Speed                    : "  + $Adapter.MaxSpeed                   )}
    if ($Adapter.Name.                       length -gt 0) {$NetworkAdaptersInfo.Add("Name                         : "  + $Adapter.Name                       )}
    if ($Adapter.NetConnectionID.            length -gt 0) {$NetworkAdaptersInfo.Add("Net Connection ID            : "  + $Adapter.NetConnectionID            )}
    if ($Adapter.NetConnectionStatus.        length -gt 0) {$NetworkAdaptersInfo.Add("Net Connection Status        : "  + $NetConnectionStatus                )}
    if ($Adapter.NetEnabled.                 length -gt 0) {$NetworkAdaptersInfo.Add("Net Enabled                  : "  + $Adapter.NetEnabled                 )}
    if ($Adapter.NetworkAddresses.           length -gt 0) {$NetworkAdaptersInfo.Add("Network Addresses            : "  + $Adapter.NetworkAddresses           )}
    if ($Adapter.Path.                       length -gt 0) {$NetworkAdaptersInfo.Add("Path                         : "  + $Adapter.Path                       )}
    if ($Adapter.PermanentAddress.           length -gt 0) {$NetworkAdaptersInfo.Add("Permanent Address            : "  + $Adapter.PermanentAddress           )}
    if ($Adapter.PhysicalAdapter.            length -gt 0) {$NetworkAdaptersInfo.Add("Physical Adapter             : "  + $Adapter.PhysicalAdapter            )}
    if ($Adapter.PNPDeviceID.                length -gt 0) {$NetworkAdaptersInfo.Add("PNP Device ID                : "  + $Adapter.PNPDeviceID                )}
    if ($Adapter.PowerManagementCapabilities.length -gt 0) {$NetworkAdaptersInfo.Add("Power Management Capabilities: "  + $Adapter.PowerManagementCapabilities)}
    if ($Adapter.PowerManagementSupported.   length -gt 0) {$NetworkAdaptersInfo.Add("Power Management Supported   : "  + $Adapter.PowerManagementSupported   )}
    if ($Adapter.ProductName.                length -gt 0) {$NetworkAdaptersInfo.Add("Product Name                 : "  + $Adapter.ProductName                )}
    if ($Adapter.Scope.                      length -gt 0) {$NetworkAdaptersInfo.Add("Scope                        : "  + $Adapter.Scope                      )}
    if ($Adapter.ServiceName.                length -gt 0) {$NetworkAdaptersInfo.Add("Service Name                 : "  + $Adapter.ServiceName                )}
    if ($Adapter.Site.                       length -gt 0) {$NetworkAdaptersInfo.Add("Site                         : "  + $Adapter.Site                       )}
    if ($Adapter.Speed.                      length -gt 0) {$NetworkAdaptersInfo.Add("Speed                        : "  + $Adapter.Speed                      )}
    if ($Adapter.Status.                     length -gt 0) {$NetworkAdaptersInfo.Add("Status                       : "  + $Adapter.Status                     )}
    if ($Adapter.StatusInfo.                 length -gt 0) {$NetworkAdaptersInfo.Add("Status Info                  : "  + $Adapter.StatusInfo                 )}
    if ($Adapter.AdapterType.                length -gt 0) {$NetworkAdaptersInfo.Add("Time of Last Reset           : "  + $LastResetTime                      )}
}

$NetworkAdaptersInfo | Out-File "System-Network-Adapters.txt"
