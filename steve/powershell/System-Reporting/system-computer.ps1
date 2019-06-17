CLS

#..............................................................................

#..............................................................................
function Get-ThermalState($ThermalState)
{
    $Result = "Not Found"

    if ($ThermalState -eq 1) {$Result = "Other"          }
    if ($ThermalState -eq 2) {$Result = "Unknown"        }
    if ($ThermalState -eq 3) {$Result = "Safe"           }
    if ($ThermalState -eq 4) {$Result = "Warning"        }
    if ($ThermalState -eq 5) {$Result = "Critical"       }
    if ($ThermalState -eq 6) {$Result = "Non-recoverable"}

    Return $Result
}                                                          
#..............................................................................

#..............................................................................
function Get-WakeupType($WakeupType)
{
    $Result = "Not Found"

    if ($WakeupType -eq 0) {$Result = "Reserved"         }
    if ($WakeupType -eq 1) {$Result = "Other"            }
    if ($WakeupType -eq 2) {$Result = "Unknown"          }
    if ($WakeupType -eq 3) {$Result = "APM Timer"        }
    if ($WakeupType -eq 4) {$Result = "Modem Ring"       }
    if ($WakeupType -eq 5) {$Result = "LAN Remote"       }
    if ($WakeupType -eq 6) {$Result = "Power Switch"     }
    if ($WakeupType -eq 7) {$Result = "PCI PME#"         }
    if ($WakeupType -eq 8) {$Result = "AC Power Restored"}

    Return $Result
}                                                          
#..............................................................................

#..............................................................................
function Get-StandardStatus  ($Status)
{
    if ($Status -eq 0) {return "Disabled"       }
    if ($Status -eq 1) {return "Enabled"        }
    if ($Status -eq 2) {return "Not Implemented"}
    if ($Status -eq 3) {return "Unknown"        }
}
#..............................................................................

#..............................................................................
function Get-PowerState($PowerState)
{
    if ($PowerState -eq 0) {return "Unknown"                    }
    if ($PowerState -eq 1) {return "Full Power"                 }
    if ($PowerState -eq 2) {return "Power Save - Low Power Mode"}
    if ($PowerState -eq 3) {return "Power Save - Standby"       }
    if ($PowerState -eq 4) {return "Power Save - Unknown"       }
    if ($PowerState -eq 5) {return "Power Cycle"                }
    if ($PowerState -eq 6) {return "Power Off"                  }
    if ($PowerState -eq 7) {return "Power Save - Warning"       }
    if ($PowerState -eq 8) {return "Power Save - Hibernate"     }
    if ($PowerState -eq 9) {return "Power Save - Soft Off"      }
}
#..............................................................................

#..............................................................................
function Get-ComputerRole($ComputerRole)
{
    if ($ComputerRole -eq 0) {return "Standalone Workstation"   }
    if ($ComputerRole -eq 1) {return "Member Workstation"       }
    if ($ComputerRole -eq 2) {return "Standalone Server"        }
    if ($ComputerRole -eq 3) {return "Member Server"            }
    if ($ComputerRole -eq 4) {return "Backup Domain Controller" }
    if ($ComputerRole -eq 5) {return "Primary Domain Controller"}
}
#..............................................................................

#..............................................................................
function Get-StandardStateEx($State)
{
    if ($State -eq 1) {return "Other"          } 
    if ($State -eq 2) {return "Unknown"        }     
    if ($State -eq 3) {return "Safe"           }      
    if ($State -eq 4) {return "Warning"        }     
    if ($State -eq 5) {return "Critical"       }    
    if ($State -eq 6) {return "Non-recoverable"}
}
#..............................................................................

#..............................................................................
function Get-PCSystemType($PCSystemType)
{
    if ($PCSystemType -eq 0) {return "Unspecified"       }
    if ($PCSystemType -eq 1) {return "Desktop"           }
    if ($PCSystemType -eq 2) {return "Mobile"            }
    if ($PCSystemType -eq 3) {return "Workstation"       }
    if ($PCSystemType -eq 4) {return "Enterprise Server" }
    if ($PCSystemType -eq 5) {return "SOHO Server"       }
    if ($PCSystemType -eq 6) {return "Appliance PC"      }
    if ($PCSystemType -eq 7) {return "Performance Server"}
    if ($PCSystemType -eq 8) {return "Maximum"           }
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
        {$Size -gt 1GB} {$NewSize = “$([math]::Round(($Size / 1GB),2))GB”; Break}
        {$Size -gt 1MB} {$NewSize = “$([math]::Round(($Size / 1MB),2))MB”; Break}
        {$Size -gt 1KB} {$NewSize = “$([math]::Round(($Size / 1KB),2))KB”; Break}
        Default         {$NewSize = “$([math]::Round($Size,2))Bytes”; Break}
    }

    Return $NewSize
}
#..............................................................................

#..............................................................................

$ComputerSystem = Get-WmiObject Win32_ComputerSystem
$SysInfo            = New-Object Object
$ComputerName   = $Env:COMPUTERNAME

$AdminPasswordStatus    = Get-StandardStatus  ($ComputerSystem.AdminPasswordStatus      )
$ComputerRole           = Get-ComputerRole    ($ComputerSystem.DomainRole               )
$KeyboardPasswordStatus = Get-StandardStatus  ($ComputerSystem.KeyboardPasswordStatus   )
$PCSystemType           = Get-PCSystemType    ($ComputerSystem.PCSystemType             )
$PCSystemTypeEx         = Get-PCSystemType    ($ComputerSystem.PCSystemTypeEx           )
$PowerOnPasswordStatus  = Get-StandardStatus  ($ComputerSystem.PowerOnPasswordStatus    )

$PowerSupplyState       = Get-StandardStateEx ($ComputerSystem.PowerSupplyState         )

$PowerState             = Get-PowerState      ($ComputerSystem.PowerState               )

$TimeZone               = Get-TimeZone

$TotalPhysicalMemory    = Convert-BytesToSize $ComputerSystem.TotalPhysicalMemory

$WakeupType             = Get-WakeupType($ComputerSystem.WakeupType)

$ThermalState           = Get-ThermalState($ComputerSystem.ThermalState)

#..............................................................................

#..............................................................................

$Today = Get-Date -UFormat "%Y-%m-%d %H:%M:%S"

$SysInfo  = New-Object Object

$SysInfoTemp = @{}

$SysInfo = {$SysInfoTemp}.Invoke()

$SysInfo.Add("========================================"                                     )
$SysInfo.Add("Computer System Report"                                                       )
$SysInfo.Add("========================================"                                     )
$SysInfo.Add(""                                                                             )
$SysInfo.Add("========================================"                                     )
$SysInfo.Add("Report Summary"                                                               )
$SysInfo.Add("----------------------------------------"                                     )
$SysInfo.Add("Computer Name: " + $Env:COMPUTERNAME                                              )
$SysInfo.Add("WMI Class    : Win32_ComputerSystem"                                          )
$SysInfo.Add("Report Date  : " + $Today                                                     )
$SysInfo.Add("----------------------------------------"                                     )
$SysInfo.Add(""                                                                             )
$SysInfo.Add("Admin Password Status        : " + $AdminPasswordStatus                       )
$SysInfo.Add("Automatic Managed Pagefile   : " + $ComputerSystem.AutomaticManagedPagefile   )
$SysInfo.Add("Automatic Reset Boot Option  : " + $ComputerSystem.AutomaticResetBootOption   )
$SysInfo.Add("Automatic Reset Capability   : " + $ComputerSystem.AutomaticResetCapability   )
$SysInfo.Add("Boot Option On Limit         : " + $ComputerSystem.BootOptionOnLimit          )
$SysInfo.Add("Boot Option On WatchDog      : " + $ComputerSystem.BootOptionOnWatchDog       )
$SysInfo.Add("Boot ROM Supported           : " + $ComputerSystem.BootROMSupported           )
$SysInfo.Add("Bootup State                 : " + $ComputerSystem.BootupState                )
$SysInfo.Add("Boot Status                  : " + $ComputerSystem.BootStatus                 )
$SysInfo.Add("Caption                      : " + $ComputerSystem.Caption                    )
$SysInfo.Add("Chassis Bootup State         : " + $ChassisBootupState                        )
$SysInfo.Add("Chassis SKU Number           : " + $ComputerSystem.ChassisSKUNumber           )
$SysInfo.Add("Computer Role                : " + $ComputerRole                              )
$SysInfo.Add("Creation Class Name          : " + $ComputerSystem.CreationClassName          )
$SysInfo.Add("Current Time Zone            : " + $TimeZone                                  )
$SysInfo.Add("Daylight Savings in Effect   : " + $ComputerSystem.DaylightInEffect           )
$SysInfo.Add("Description                  : " + $ComputerSystem.Description                )
$SysInfo.Add("DNS Host Name                : " + $ComputerSystem.DNSHostName                )
if($ComputerSystem.PartOfDomain -eq $true)
{
    $SysInfo.Add("Domain                       : " + $ComputerSystem.Domain                 )
}
$SysInfo.Add("Enable Daylight Savings Time : " + $ComputerSystem.EnableDaylightSavingsTime  )
$SysInfo.Add("Front Panel Reset Status     : " + $ComputerSystem.FrontPanelResetStatus      )
$SysInfo.Add("Hypervisor Present           : " + $ComputerSystem.HypervisorPresent          )
$SysInfo.Add("Infrared Supported           : " + $ComputerSystem.InfraredSupported          )
$SysInfo.Add("Initial Load Info            : " + $ComputerSystem.InitialLoadInfo            )
$SysInfo.Add("Install Date                 : " + $ComputerSystem.InstallDate                )
$SysInfo.Add("Keyboard Password Status     : " + $KeyboardPasswordStatus                    )
$SysInfo.Add("Last Load Info               : " + $ComputerSystem.LastLoadInfo               )
$SysInfo.Add("Manufacturer                 : " + $ComputerSystem.Manufacturer               )
$SysInfo.Add("Model                        : " + $ComputerSystem.Model                      )
$SysInfo.Add("Name                         : " + $ComputerSystem.Name                       )
$SysInfo.Add("Name Format                  : " + $ComputerSystem.NameFormat                 )
$SysInfo.Add("NetworkServer Mode Enabled   : " + $ComputerSystem.NetworkServerModeEnabled   )
$SysInfo.Add("Number of Logical Processors : " + $ComputerSystem.NumberOfLogicalProcessors  )
$SysInfo.Add("Number of Processors         : " + $ComputerSystem.NumberOfProcessors         )
$SysInfo.Add("OEM Logo Bitmap              : " + $ComputerSystem.OEMLogoBitmap              )
$SysInfo.Add("OEM String Array             : " + $ComputerSystem.OEMStringArray             )
$SysInfo.Add("Part of Domain               : " + $ComputerSystem.PartOfDomain               )
$SysInfo.Add("Pause After Reset            : " + $ComputerSystem.PauseAfterReset            )
$SysInfo.Add("PC System Type               : " + $PCSystemType                              )
$SysInfo.Add("PC System Type Ex            : " + $PCSystemTypeEx                            )
$SysInfo.Add("Power Management Capabilities: " + $ComputerSystem.PowerManagementCapabilities) 
$SysInfo.Add("Power Management Supported   : " + $ComputerSystem.PowerManagementSupported   )
$SysInfo.Add("Power On Password Status     : " + $PowerOnPasswordStatus                     )
$SysInfo.Add("Power State                  : " + $PowerState                                )
$SysInfo.Add("Power Supply State           : " + $PowerSupplyState                          )
$SysInfo.Add("Primary Owner Contact        : " + $ComputerSystem.PrimaryOwnerContact        )
$SysInfo.Add("PrimaryOwnerName             : " + $ComputerSystem.PrimaryOwnerName           )
$SysInfo.Add("Reset Capability             : " + $ComputerSystem.ResetCapability            )
$SysInfo.Add("Reset Count                  : " + $ComputerSystem.ResetCount                 )
$SysInfo.Add("Reset Limit                  : " + $ComputerSystem.ResetLimit                 )
$SysInfo.Add("Roles                        : " + $ComputerSystem.Roles                      )
$SysInfo.Add("Status                       : " + $ComputerSystem.Status                     )
$SysInfo.Add("Support Contact Description  : " + $ComputerSystem.SupportContactDescription  )
$SysInfo.Add("System Family                : " + $ComputerSystem.SystemFamily               )
$SysInfo.Add("System SKU Number            : " + $ComputerSystem.SystemSKUNumber            )
$SysInfo.Add("System Startup Delay         : " + $ComputerSystem.SystemStartupDelay         )
$SysInfo.Add("System Startup Options       : " + $ComputerSystem.SystemStartupOptions       )
$SysInfo.Add("System Startup Setting       : " + $ComputerSystem.SystemStartupSetting       )
$SysInfo.Add("System Type                  : " + $ComputerSystem.SystemType                 )
$SysInfo.Add("Thermal State                : " + $ThermalState                              )
$SysInfo.Add("Total Physical Memory        : " + $TotalPhysicalMemory                       )
$SysInfo.Add("User Name                    : " + $ComputerSystem.UserName                   )
$SysInfo.Add("Wake Up Type                 : " + $WakeUpType                                )

if($ComputerSystem.PartOfDomain -eq $false)
{
    $SysInfo.Add("Workgroup                    : " + $ComputerSystem.Workgroup              )
}

$SysInfo | Out-File "System-Computer.txt"