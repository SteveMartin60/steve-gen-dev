CLS

#..............................................................................

#..............................................................................
function Get-ProductType($ProductType)
{
    $Result = "Not Found"

    if($ProductType -eq '1' ) {$result = "Work Station"     }
    if($ProductType -eq '2' ) {$result = "Domain Controller"}
    if($ProductType -eq '3' ) {$result = "Server"           }

    Return $Result
}
#..............................................................................

#..............................................................................
function Get-OSType($OSType)
{
    $Result = $null

    if($OSType -eq '0' ) {$result = "Unknown"        }
    if($OSType -eq '1' ) {$result = "Other"          }
    if($OSType -eq '2' ) {$result = "MACOS"          }
    if($OSType -eq '3' ) {$result = "ATTUNIX"        }
    if($OSType -eq '4' ) {$result = "DGUX"           }
    if($OSType -eq '5' ) {$result = "DECNT"          }
    if($OSType -eq '6' ) {$result = "DigitalUnix"    }
    if($OSType -eq '7' ) {$result = "OpenVMS"        }
    if($OSType -eq '8' ) {$result = "HPUX"           }
    if($OSType -eq '9' ) {$result = "AIX"            }
    if($OSType -eq '10') {$result = "MVS"            }
    if($OSType -eq '11') {$result = "OS400"          }
    if($OSType -eq '12') {$result = "OS/2"           }
    if($OSType -eq '13') {$result = "JavaVM"         }
    if($OSType -eq '14') {$result = "MSDOS"          }
    if($OSType -eq '15') {$result = "WIN3x"          }
    if($OSType -eq '16') {$result = "WIN95"          }
    if($OSType -eq '17') {$result = "WIN98"          }
    if($OSType -eq '18') {$result = "WINNT"          }
    if($OSType -eq '19') {$result = "WINCE"          }
    if($OSType -eq '20') {$result = "NCR3000"        }
    if($OSType -eq '21') {$result = "NetWare"        }
    if($OSType -eq '22') {$result = "OSF"            }
    if($OSType -eq '23') {$result = "DC/OS"          }
    if($OSType -eq '24') {$result = "ReliantUNIX"    }
    if($OSType -eq '25') {$result = "SCOUnixWare"    }
    if($OSType -eq '26') {$result = "SCOOpenServer"  }
    if($OSType -eq '27') {$result = "Sequent"        }
    if($OSType -eq '28') {$result = "IRIX"           }
    if($OSType -eq '29') {$result = "Solaris"        }
    if($OSType -eq '30') {$result = "SunOS"          }
    if($OSType -eq '31') {$result = "U6000"          }
    if($OSType -eq '32') {$result = "ASERIES"        }
    if($OSType -eq '33') {$result = "TandemNSK"      }
    if($OSType -eq '34') {$result = "TandemNT"       }
    if($OSType -eq '35') {$result = "BS2000"         }
    if($OSType -eq '36') {$result = "LINUX"          }
    if($OSType -eq '37') {$result = "Lynx"           }
    if($OSType -eq '38') {$result = "XENIX"          }
    if($OSType -eq '39') {$result = "VM/ESA"         }
    if($OSType -eq '40') {$result = "InteractiveUNIX"}
    if($OSType -eq '41') {$result = "BSDUNIX"        }
    if($OSType -eq '42') {$result = "FreeBSD"        }
    if($OSType -eq '43') {$result = "NetBSD"         }
    if($OSType -eq '44') {$result = "GNUHurd"        }
    if($OSType -eq '45') {$result = "OS9"            }
    if($OSType -eq '46') {$result = "MACHKernel"     }
    if($OSType -eq '47') {$result = "Inferno"        }
    if($OSType -eq '48') {$result = "QNX"            }
    if($OSType -eq '49') {$result = "EPOC"           }
    if($OSType -eq '50') {$result = "IxWorks"        }
    if($OSType -eq '51') {$result = "VxWorks"        }
    if($OSType -eq '52') {$result = "MiNT"           }
    if($OSType -eq '53') {$result = "BeOS"           }
    if($OSType -eq '54') {$result = "HPMPE"          }
    if($OSType -eq '55') {$result = "NextStep"       }
    if($OSType -eq '56') {$result = "PalmPilot"      }
    if($OSType -eq '57') {$result = "Rhapsody"       }
    if($OSType -eq '58') {$result = "Windows2000"    }
    if($OSType -eq '59') {$result = "Dedicated"      }
    if($OSType -eq '60') {$result = "OS/390"         }
    if($OSType -eq '61') {$result = "VSE"            }
    if($OSType -eq '62') {$result = "TPF"            }
                                                           
    return $Result
}
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
function get-OSProductType($ProductType)
{
    $result = "Not Found"

    if($ProductType -eq '0') {$result = "Work Station"     }
    if($ProductType -eq '1') {$result = "Domain Controller"}
    if($ProductType -eq '2') {$result = "Server"           }

    return $result
}
#..............................................................................

#..............................................................................
function Get-WindowsBuildName($BuildID)
{
    $BuildName = "Unknown"

    if ($BuildID -eq 10240) {$BuildName = "Original Release"    }
    if ($BuildID -eq 10586) {$BuildName = "November Update"     }
    if ($BuildID -eq 14393) {$BuildName = "Anniversary Update"  }
    if ($BuildID -eq 15063) {$BuildName = "Creators Update"     }
    if ($BuildID -eq 16299) {$BuildName = "Fall Creators Update"}

    Return $BuildName
}
#..............................................................................

#..............................................................................
function Get-DEP_SupportPolicy($DEP_SupportPolicy) # Data Execution Prevention Support Policy
{
    $Policy = "Unknown"

    if ($DEP_SupportPolicy -eq 0) {$Policy = "Always Off"}
    if ($DEP_SupportPolicy -eq 1) {$Policy = "Always On" }
    if ($DEP_SupportPolicy -eq 2) {$Policy = "Opt In"    }
    if ($DEP_SupportPolicy -eq 3) {$Policy = "Opt Out"   }

    Return $Policy
}
#..............................................................................

#..............................................................................
function Get-ForegroundAppBoost($ForegroundAppBoost)
{
    $BoostLevel = "Unknown"

    if ($ForegroundAppBoost -eq 0) {$BoostLevel = "None"    }
    if ($ForegroundAppBoost -eq 1) {$BoostLevel = "Minimum" }
    if ($ForegroundAppBoost -eq 2) {$BoostLevel = "Maximum "}
    
    Return $BoostLevel
}
#..............................................................................

#..............................................................................

$OSVersion = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" 

$ReleaseID = $OSVersion.ReleaseID

$OSData = Get-WmiObject -class Win32_OperatingSystem

$Culture = Get-Culture
$RegionInfo = New-Object System.Globalization.RegionInfo $Culture.Name

$Currency      = $RegionInfo.CurrencyEnglishName
$CurrencySymbol = $RegionInfo.CurrencySymbol

$CodePage                = $OSData.CodeSet + ": " +  [System.Text.Encoding]::Default.EncodingName
$ComputerName            = $OSData.__SERVER
$LastReboot              = $OSData.ConvertToDateTime($OSData.LastBootUpTime)

$BuildName               = Get-WindowsBuildName  ($OSData.BuildNumber)
$DEP_SupportPolicy       = Get-DEP_SupportPolicy ($OSData.DataExecutionPrevention_SupportPolicy)
$ForegroundAppBoost      = Get-ForegroundAppBoost($OSData.ForegroundApplicationBoost)
$OSType                  = Get-OSType            ($OSData.OSType)
$ProductType             = Get-ProductType       ($OSData.ProductType)

$HomeLocale              = Get-WinHomeLocation
$TimeNow                 = Get-Date
$TimeZone                = Get-TimeZone
$Today                   = Get-Date -UFormat "%Y-%m-%d %H:%M:%S"
$WindowsKey              = Get-WindowsKey

$FreePhysicalMemory      = Convert-BytesToSize $OSData.FreePhysicalMemory
$FreeSpaceInPagingFiles  = Convert-BytesToSize $OSData.FreeSpaceInPagingFiles
$FreeVirtualMemory       = Convert-BytesToSize $OSData.FreeVirtualMemory
$TotalVirtualMemorySize  = Convert-BytesToSize $OSData.TotalVirtualMemorySize
$TotalVisibleMemorySize  = Convert-BytesToSize $OSData.TotalVisibleMemorySize
$MaxProcessMemorySize    = Convert-BytesToSize $OSData.MaxProcessMemorySize
$SizeStoredInPagingFiles = Convert-BytesToSize $OSData.SizeStoredInPagingFiles

$Languages               = (Get-WinUserLanguageList).LocalizedName
$OSLanguage              = (GET-CULTURE).EnglishName

$UpTime                  = $TimeNow - $LastReboot

$OsInfo  = New-Object Object

$OsInfoTemp = @{}

$OsInfo = {$OsInfoTemp}.Invoke()

$OsInfo.Add("========================================"                                                      )
$OsInfo.Add("Operating System Report"                                                                       )
$OsInfo.Add("========================================"                                                      )
$OsInfo.Add(""                                                                                              )
$OsInfo.Add("========================================"                                                      )
$OsInfo.Add("Report Summary"                                                                                )
$OsInfo.Add("----------------------------------------"                                                      )
$OsInfo.Add("Computer Name: " + $Env:COMPUTERNAME                                                               )
$OsInfo.Add("WMI Class    : Win32_OperatingSystem"                                                          )
$OsInfo.Add("Report Date  : " + $Today                                                                      )
$OsInfo.Add("----------------------------------------"                                                      )
$OsInfo.Add(""                                                                                              )
$OsInfo.Add("====================="                                                                         )
$OsInfo.Add("OS Information"                                                                                )
$OsInfo.Add("====================="                                                                         )
$OsInfo.Add("Architecture                            : " + $OSData.OSArchitecture                           )
$OsInfo.Add("Boot Device                             : " + $OSData.BootDevice                               )
$OsInfo.Add("Build Name                              : " + $BuildName                                       )
$OsInfo.Add("Build Number                            : " + $OSData.BuildNumber                              )
$OsInfo.Add("Build Release ID                        : " + $OSVersion.ReleaseID                             )
$OsInfo.Add("Calendar                                : " + $Culture.DateTimeFormat.NativeCalendarName       )
$OsInfo.Add("Caption                                 : " + $OSData.Caption                                  )
$OsInfo.Add("Code Page                               : " + $CodePage                                        )
$OsInfo.Add("Computer                                : " + $OSData.PSComputerName                           )
$OsInfo.Add("Currency                                : " + $Currency                                        )
$OsInfo.Add("Currency Symbol                         : " + $CurrencySymbol                                  )
$OsInfo.Add("Data Execution Prevention (32Bit)       : " + $OSData.DataExecutionPrevention_32BitApplications)
$OsInfo.Add("Data Execution Prevention Available     : " + $OSData.DataExecutionPrevention_Available        )
$OsInfo.Add("Data Execution Prevention Drivers       : " + $OSData.DataExecutionPrevention_Drivers          )
$OsInfo.Add("Data Execution Prevention Support Policy: " + $DEP_SupportPolicy                               )
$OsInfo.Add("Debug                                   : " + $OSData.Debug                                    )
$OsInfo.Add("Distributed                             : " + $OSData.Distributed                              )
$OsInfo.Add("Encryption Level                        : " + $OSData.EncryptionLevel                          )
$OsInfo.Add("Foreground Application Boost            : " + $ForegroundAppBoost                              )
$OsInfo.Add("Free Physical Memor                     : " + $FreePhysicalMemory                              )
$OsInfo.Add("Free Space in Paging Files              : " + $FreeSpaceInPagingFiles                          )
$OsInfo.Add("Free Virtual Memory                     : " + $FreeVirtualMemory                               )
$OsInfo.Add("Install Date                            : " + $OSData.ConvertToDateTime($OSData.InstallDate)   )
$OsInfo.Add("Languages                               : " + $Languages                                       )
$OsInfo.Add("Last Boot Time                          : " + $OSData.ConvertToDateTime($OSData.LastBootUpTime))
$OsInfo.Add("Locale                                  : " + $HomeLocale.HomeLocation                         )
$OsInfo.Add("MUI Languages                           : " + $OSData.MUILanguages                             )
$OsInfo.Add("Manufacturer                            : " + $OSData.Manufacturer                             )
$OsInfo.Add("Max Number of Processes                 : " + $OSData.MaxNumberOfProcesses                     )
$OsInfo.Add("Max Process Memory Size                 : " + $MaxProcessMemorySize                            )
$OsInfo.Add("Number of Licensed Users                : " + $OSData.NumberOfLicensedUsers                    )
$OsInfo.Add("Number of Processes                     : " + $OSData.NumberOfProcesses                        )
$OsInfo.Add("Number of User                          : " + $OSData.NumberOfUsers                            )
$OsInfo.Add("OS Architecture                         : " + $OSData.OSArchitecture                           )
$OsInfo.Add("OS Language                             : " + $OSLanguage                                      )
$OsInfo.Add("OS Name                                 : " + $OSVersion.ProductName                           )
$OsInfo.Add("OS ProductSuite                         : " + $OSData.OSProductSuite                           )
$OsInfo.Add("OS Type                                 : " + $OSType                                          )
$OsInfo.Add("Operating System SKU                    : " + $OSData.OperatingSystemSKU                       )
$OsInfo.Add("Organization                            : " + $OSData.Organization                             )
$OsInfo.Add("PortableOperatingSystem                 : " + $OSData.PortableOperatingSystem                  )
$OsInfo.Add("Primary                                 : " + $OSData.Primary                                  )
$OsInfo.Add("Product ID                              : " + $OSData.SerialNumber                             )
$OsInfo.Add("Product Key                             : " + $WindowsKey                                      )
$OsInfo.Add("Product Type                            : " + $ProductType                                     )
$OsInfo.Add("Registered To                           : " + $OSData.RegisteredUser                           )
$OsInfo.Add("Registered User                         : " + $OSData.RegisteredUser                           )
$OsInfo.Add("Serial Number                           : " + $OSData.SerialNumber                             )
$OsInfo.Add("ServicePack Major Version               : " + $OSData.ServicePackMajorVersion                  )
$OsInfo.Add("ServicePack Minor Version               : " + $OSData.ServicePackMinorVersion                  )
$OsInfo.Add("Size Stored in Paging Files             : " + $SizeStoredInPagingFiles                         )
$OsInfo.Add("Status                                  : " + $OSData.Status                                   )
$OsInfo.Add("Suite Mask                              : " + $OSData.SuiteMask                                )
$OsInfo.Add("System Descrition                       : " + $OSData.Description                              )
$OsInfo.Add("System Device                           : " + $OSData.SystemDevice                             )
$OsInfo.Add("System Directory                        : " + $OSData.SystemDirectory                          )
$OsInfo.Add("System Drive                            : " + $OSData.SystemDrive                              )
$OsInfo.Add("Time Zone                               : " + $TimeZone                                        )
$OsInfo.Add("Total Virtual Memory Size               : " + $TotalVirtualMemorySize                          )
$OsInfo.Add("Total Visible Memory Size               : " + $TotalVisibleMemorySize                          )
$OsInfo.Add("Version                                 : " + $OSData.Version                                  )
$OsInfo.Add("Windows Directory                       : " + $OSData.WindowsDirectory                         )
$OsInfo.Add(""                                                                                              )
$OsInfo.Add("====================="                                                                         )
$OsInfo.Add("WMI Class Information"                                                                         )
$OsInfo.Add("---------------------"                                                                         )
$OsInfo.Add(""                                                                                              )
$OsInfo.Add("CLASS              : " + $OSData.__CLASS                                                       )
$OsInfo.Add("CLASS              : " + $OSData.__CLASS                                                       )
$OsInfo.Add("CSCreationClassName: " + $OSData.CSCreationClassName                                           )
$OsInfo.Add("CreationClassName  : " + $OSData.CreationClassName                                             )
$OsInfo.Add("DERIVATION         : " + $OSData.__DERIVATION                                                  )
$OsInfo.Add("DYNASTY            : " + $OSData.__DYNASTY                                                     )
$OsInfo.Add("GENUS              : " + $OSData.__GENUS                                                       )
$OsInfo.Add("NAMESPACE          : " + $OSData.__NAMESPACE                                                   )
$OsInfo.Add("PATH               : " + $OSData.__PATH                                                        )
$OsInfo.Add("PROPERTY_COUNT     : " + $OSData.__PROPERTY_COUNT                                              )
$OsInfo.Add("RELPATH            : " + $OSData.__RELPATH                                                     )
$OsInfo.Add("SUPERCLASS         : " + $OSData.__SUPERCLASS                                                  )

$OsInfo | Out-File "OS-Details.txt"

