CLS

$ComputerName = $Env:COMPUTERNAME

#..............................................................................

#..............................................................................
Function Get-SMBIOSMemoryType($SMBIOSMemoryType)
{
    $Result = "Undefined Value"
    
    if ($SMBIOSMemoryType -eq 01  ) {$Result = "Other"       }
    if ($SMBIOSMemoryType -eq 02  ) {$Result = "Unknown"     }
    if ($SMBIOSMemoryType -eq 03  ) {$Result = "DRAM"        }
    if ($SMBIOSMemoryType -eq 04  ) {$Result = "EDRAM"       }
    if ($SMBIOSMemoryType -eq 05  ) {$Result = "VRAM"        }
    if ($SMBIOSMemoryType -eq 06  ) {$Result = "SRAM"        }
    if ($SMBIOSMemoryType -eq 07  ) {$Result = "RAM"         }
    if ($SMBIOSMemoryType -eq 08  ) {$Result = "ROM"         }
    if ($SMBIOSMemoryType -eq 09  ) {$Result = "FLASH"       }
    if ($SMBIOSMemoryType -eq 10  ) {$Result = "EEPROM"      }
    if ($SMBIOSMemoryType -eq 11  ) {$Result = "FEPROM"      }
    if ($SMBIOSMemoryType -eq 12  ) {$Result = "EPROM"       }
    if ($SMBIOSMemoryType -eq 13  ) {$Result = "CDRAM"       }
    if ($SMBIOSMemoryType -eq 14  ) {$Result = "3DRAM"       }
    if ($SMBIOSMemoryType -eq 15  ) {$Result = "SDRAM"       }
    if ($SMBIOSMemoryType -eq 16  ) {$Result = "SGRAM"       }
    if ($SMBIOSMemoryType -eq 17  ) {$Result = "RDRAM"       }
    if ($SMBIOSMemoryType -eq 18  ) {$Result = "DDR"         }
    if ($SMBIOSMemoryType -eq 19  ) {$Result = "DDR2"        }
    if ($SMBIOSMemoryType -eq 20  ) {$Result = "DDR2 FB-DIMM"}
    if ($SMBIOSMemoryType -eq 24  ) {$Result = "DDR3"        }
    if ($SMBIOSMemoryType -eq 25  ) {$Result = "FBD2"        }

    Return $Result
}                       
#..............................................................................

#..............................................................................
Function Get-MemoryTypeDetail($TypeDetail)
{
    $Result = "Undefined Value"
    
    if ($TypeDetail -eq 1   ) {$Result = "Reserved"     }
    if ($TypeDetail -eq 2   ) {$Result = "Other"        }
    if ($TypeDetail -eq 4   ) {$Result = "Unknown"      }
    if ($TypeDetail -eq 8   ) {$Result = "Fast-paged"   }
    if ($TypeDetail -eq 16  ) {$Result = "Static column"}
    if ($TypeDetail -eq 32  ) {$Result = "Pseudo-static"}
    if ($TypeDetail -eq 64  ) {$Result = "RAMBUS"       }
    if ($TypeDetail -eq 128 ) {$Result = "Synchronous"  }
    if ($TypeDetail -eq 256 ) {$Result = "CMOS"         }
    if ($TypeDetail -eq 512 ) {$Result = "EDO"          }
    if ($TypeDetail -eq 1024) {$Result = "Window DRAM"  }
    if ($TypeDetail -eq 2048) {$Result = "Cache DRAM"   }
    if ($TypeDetail -eq 4096) {$Result = "Non-volatile" }
                        
    Return $Result
}                       
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
Function Get-MemoryFormFactor
{
    param ([uint16] $char)

    If ($char -ge 0 -and  $char -le 22)
    {
        switch ($char)
        {
            0  {"Unknown"    }
            1  {"Other"      }
            2  {"SiP"        }
            3  {"DIP"        }
            4  {"ZIP"        }
            5  {"SOJ"        }
            6  {"Proprietary"}
            7  {"SIMM"       }
            8  {"DIMM"       }
            9  {"TSOPO"      }
            10 {"PGA"        }
            11 {"RIM"        }
            12 {"SODIMM"     }
            13 {"SRIMM"      }
            14 {"SMD"        }
            15 {"SSMP"       }
            16 {"QFP"        }
            17 {"TQFP"       }
            18 {"SOIC"       }
            19 {"LCC"        }
            20 {"PLCC"       }
            21 {"FPGA"       }
            22 {"LGA"        }
        }
    }
    else
    {
        "{0} - undefined value" -f $char
    }

    Return
}
#..............................................................................

#..............................................................................
function Get-InterleavePosition
{
    param ([uint32] $char)

    If ($char -ge 0 -and  $char -le 2)
    {
        switch ($char)
        {
            0 {"Non-Interleaved"}
            1 {"First Position" }
            2 {"Second Position"}
        }
    }
    else
    {
        "{0} - undefined value" -f $char
    }

    Return
}
#..............................................................................

#..............................................................................
function Get-MemoryType($MemoryType)
{
    $Result = "Undefined Value"
    
    if ($MemoryType -eq 0  ) {$Result = "Unknown"         }
    if ($MemoryType -eq 1  ) {$Result = "Other"           }
    if ($MemoryType -eq 2  ) {$Result = "DRAM"            }
    if ($MemoryType -eq 3  ) {$Result = "Synchronous DRAM"}
    if ($MemoryType -eq 4  ) {$Result = "Cache DRAM"      }
    if ($MemoryType -eq 5  ) {$Result = "EDO"             }
    if ($MemoryType -eq 6  ) {$Result = "EDRAM"           }
    if ($MemoryType -eq 7  ) {$Result = "VRAM"            }
    if ($MemoryType -eq 8  ) {$Result = "SRAM"            }
    if ($MemoryType -eq 9  ) {$Result = "ROM"             }
    if ($MemoryType -eq 10 ) {$Result = "ROM"             }
    if ($MemoryType -eq 11 ) {$Result = "FLASH"           }
    if ($MemoryType -eq 12 ) {$Result = "EEPROM"          }
    if ($MemoryType -eq 13 ) {$Result = "FEPROM"          }
    if ($MemoryType -eq 14 ) {$Result = "EPROM"           }
    if ($MemoryType -eq 15 ) {$Result = "CDRAM"           }
    if ($MemoryType -eq 16 ) {$Result = "3DRAM"           }
    if ($MemoryType -eq 17 ) {$Result = "SDRAM"           }
    if ($MemoryType -eq 18 ) {$Result = "SGRAM"           }
    if ($MemoryType -eq 19 ) {$Result = "RDRAM"           }
    if ($MemoryType -eq 20 ) {$Result = "DDR"             }
    if ($MemoryType -eq 21 ) {$Result = "DDR2"            }
    if ($MemoryType -eq 22 ) {$Result = "DDR2 FB-DIMM"    }
    if ($MemoryType -eq 24 ) {$Result = "DDR3"            }
    if ($MemoryType -eq 25 ) {$Result = "FBD2"            }

    Return $Result
}
#..............................................................................

#..............................................................................
$MemorySlot    = Get-WmiObject Win32_PhysicalMemoryArray -ComputerName $computername
$Memory        = Get-WMIObject Win32_PhysicalMemory      -ComputerName $computername
$MemoryMeasure = Get-WMIObject Win32_PhysicalMemory      -ComputerName $computername | Measure-Object -Property Capacity -Sum


$MaximumMemoryCapacity = Convert-BytesToSize $MemorySlot.MaxCapacity
$TotalMemoryInstalled  = Convert-BytesToSize $MemoryMeasure.Sum

$Today         = Get-Date -UFormat "%Y-%m-%d %H:%M:%S"

$MemoryInfo  = New-Object Object

$MemoryInfoTemp = @{}

$MemoryInfo = {$MemoryInfoTemp}.Invoke()

$MemoryInfo.Add("========================================"              )
$MemoryInfo.Add("System Memory Report"                                  )
$MemoryInfo.Add("========================================"              )
$MemoryInfo.Add(""                                                      )
$MemoryInfo.Add("========================================"              )
$MemoryInfo.Add("Report Summary"                                        )
$MemoryInfo.Add("----------------------------------------"              )
$MemoryInfo.Add("Computer Name: " + $Env:COMPUTERNAME                       )
$MemoryInfo.Add("WMI Class    : Win32_PhysicalMemoryArray"              )
$MemoryInfo.Add("WMI Class    : Win32_PhysicalMemory"                   )
$MemoryInfo.Add("Report Date  : " + $Today                              )
$MemoryInfo.Add("----------------------------------------"              )
$MemoryInfo.Add(""                                                      )
$MemoryInfo.Add("====================="                                 )
$MemoryInfo.Add("Memory Summary"                                        )
$MemoryInfo.Add("---------------------"                                 )
$MemoryInfo.Add("Total Memory Slots      : " + $MemorySlot.MemoryDevices)
$MemoryInfo.Add("Memory Sticks Installed : " + $MemoryMeasure.Count     )
$MemoryInfo.Add("Maximum Memory Capacity : " + $MaximumMemoryCapacity   )
$MemoryInfo.Add("Total Memory Installed  : " + $TotalMemoryInstalled    )
$MemoryInfo.Add("====================="                                 )


Foreach ($Stick in $Memory)
{
    $Capacity           = Convert-BytesToSize    $Stick.capacity
    $FormFactor         = Get-MemoryFormFactor  ($Stick.FormFactor        )
    $InterleavePosition = Get-InterleavePosition($Stick.InterleavePosition)
    $MemoryType         = Get-MemoryType        ($Stick.MemoryType        )
    $TypeDetail         = Get-MemoryTypeDetail  ($Stick.TypeDetail        )
    $TypeDetail         = Get-MemoryTypeDetail  ($Stick.TypeDetail        )
    $SMBIOSMemoryType   = Get-SMBIOSMemoryType  ($Stick.SMBIOSMemoryType  )

    $MemoryInfo.Add("")
    $MemoryInfo.Add("===================================="                 )
    $MemoryInfo.Add($Stick.tag                                             )
    $MemoryInfo.Add("------------------------------------"                 )
    $MemoryInfo.Add("Capacity            : "  + $Capacity                  )
    $MemoryInfo.Add("Caption             : "  + $Stick.Caption             )
    $MemoryInfo.Add("CreationClassName   : "  + $Stick.creationclassname   )
    $MemoryInfo.Add("DataWidth           : "  + $Stick.DataWidth           )
    $MemoryInfo.Add("Description         : "  + $Stick.Description         )
    $MemoryInfo.Add("DeviceLocator       : "  + $Stick.DeviceLocator       )
    $MemoryInfo.Add("FormFactor          : "  + $FormFactor                )
    $MemoryInfo.Add("HotSwappable        : "  + $Stick.HotSwappable        )
    $MemoryInfo.Add("InstallDate         : "  + $Stick.InstallDate         )
    $MemoryInfo.Add("InterleaveDataDepth : "  + $Stick.InterleaveDataDepth )
    $MemoryInfo.Add("InterleavePosition  : "  + $InterleavePosition        )
    $MemoryInfo.Add("Manufacturer        : "  + $Stick.Manufacturer        )
    $MemoryInfo.Add("MemoryType          : "  + $MemoryType                )
    $MemoryInfo.Add("Model               : "  + $Stick.Model               )
    $MemoryInfo.Add("Name                : "  + $Stick.Name                )
    $MemoryInfo.Add("OtherIdentifyingInfo: "  + $Stick.OtherIdentifyingInfo)
    $MemoryInfo.Add("PartNumber          : "  + $Stick.PartNumber          )
    $MemoryInfo.Add("PositionInRow       : "  + $Stick.PositionInRow       )
    $MemoryInfo.Add("PoweredOn           : "  + $Stick.PoweredOn           )
    $MemoryInfo.Add("Removable           : "  + $Stick.Removable           )
    $MemoryInfo.Add("Replaceable         : "  + $Stick.Replaceable         )
    $MemoryInfo.Add("SerialNumber        : "  + $Stick.SerialNumber        )
    $MemoryInfo.Add("SKU                 : "  + $Stick.SKU                 )
    $MemoryInfo.Add("Speed               : "  + $SMBIOSMemoryType          )
    $MemoryInfo.Add("Speed               : "  + $Stick.Speed               )
    $MemoryInfo.Add("Status              : "  + $Stick.Status              )
    $MemoryInfo.Add("Tag                 : "  + $Stick.Tag                 )
    $MemoryInfo.Add("TotalWidth          : "  + $Stick.TotalWidth          )
    $MemoryInfo.Add("TypeDetail          : "  + $TypeDetail                )
    $MemoryInfo.Add("Version             : "  + $Stick.Version             )
    $MemoryInfo.Add("------------------------------------"                 )
    $MemoryInfo.Add(""                                                     )

}

$MemoryInfo | Out-File "Memory-Details.txt"