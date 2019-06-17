CLS

$BIOSCharacteristics = DATA {ConvertFrom-StringData -StringData @’

2  = Unknown.
3  = BIOS Characteristics are not supported.
4  = ISA is supported.
5  = MCA is supported.
6  = EISA is supported.
7  = PCI is supported.
8  = PC card (PCMCIA) is supported.
9  = Plug and Play is supported.
10 = APM is supported.
11 = BIOS is upgradeable (Flash).
12 = BIOS shadowing is allowed.
13 = VL-VESA is supported.
14 = ESCD support is available.
15 = Boot from CD is supported.
16 = Selectable boot is supported.
17 = BIOS ROM is socketed.
18 = Boot from PC card (PCMCIA) is supported.
19 = EDD specification is supported.
20 = Int 13h — Japanese floppy for NEC 9800 1.2 MB (3.5”, 1K bytes/sector, 360 RPM) is supported.
21 = Int 13h — Japanese floppy for Toshiba 1.2 MB (3.5”, 360 RPM) is supported.
22 = Int 13h — 5.25” / 360 KB floppy services are supported.
23 = Int 13h — 5.25” /1.2 MB floppy services are supported.
24 = Int 13h — 3.5” / 720 KB floppy services are supported.
25 = Int 13h — 3.5” / 2.88 MB floppy services are supported.
26 = Int 5h, print screen Service is supported.
27 = Int 9h, 8042 keyboard services are supported.
28 = Int 14h, serial services are supported.
29 = Int 17h, printer services are supported.
30 = Int 10h, CGA/Mono Video Services are supported.
31 = NEC PC-98.
‘@}

#..............................................................................

#..............................................................................
Function Get-SoftwareElementState($SoftwareElementState)
{
    $Result = "Undefined Value"

    if ($SoftwareElementState -eq 0) {$Result = 'Deployable' }
    if ($SoftwareElementState -eq 1) {$Result = 'Installable'}
    if ($SoftwareElementState -eq 2) {$Result = 'Executable' }
    if ($SoftwareElementState -eq 3) {$Result = 'Running'    }

    Return $Result
}
#..............................................................................

#..............................................................................
$BIOS = Get-WMIObject Win32_BIOS

$Computer = $Env:COMPUTERNAME

$Today    = Get-Date -UFormat "%Y-%m-%d %H:%M:%S"

$BIOSInfo = New-Object Object

$BIOSInfoTemp = @{}

$BIOSInfo = {$BIOSInfoTemp}.Invoke()

$Characteristics      = $BIOS | Select -ExpandProperty BIOSCharacteristics | foreach {$BIOSCharacteristics["$($_)"]}
$ReleaseDate          = $BIOS.ConvertToDateTime($BIOS.ReleaseDate) |Get-Date -Format "yyyy/MM/dd HH:mm"
$SoftwareElementState = Get-SoftwareElementState($BIOS.SoftwareElementState)

$BIOSInfo.Add("========================================")
$BIOSInfo.Add("System BIOS Report"                      )
$BIOSInfo.Add("========================================")
$BIOSInfo.Add(""                                        )
$BIOSInfo.Add("================================"        )
$BIOSInfo.Add("Report Summary"                          )
$BIOSInfo.Add("--------------------------------"        )
$BIOSInfo.Add("Computer Name: " + $Env:COMPUTERNAME         )
$BIOSInfo.Add("WMI Class    : Win32_BIOS"               )
$BIOSInfo.Add("Report Date  : " + $Today                )
$BIOSInfo.Add("--------------------------------"        )
$BIOSInfo.Add(""                                        )
$BIOSInfo.Add("===================================="    )
$BIOSInfo.Add("BIOS :" + $BIOS.BIOSVersion              )
$BIOSInfo.Add("------------------------------------"    )

$BIOSInfo.Add("BuildNumber                     :" + $BIOS.BuildNumber                   )
$BIOSInfo.Add("Caption                         :" + $BIOS.Caption                       )
$BIOSInfo.Add("CodeSet                         :" + $BIOS.CodeSet                       )
$BIOSInfo.Add("CurrentLanguage                 :" + $BIOS.CurrentLanguage               )
$BIOSInfo.Add("Description                     :" + $BIOS.Description                   )
$BIOSInfo.Add("EmbeddedControllerMajorVersion  :" + $BIOS.EmbeddedControllerMajorVersion)
$BIOSInfo.Add("EmbeddedControllerMinorVersion  :" + $BIOS.EmbeddedControllerMinorVersion)
$BIOSInfo.Add("IdentificationCode              :" + $BIOS.IdentificationCode            )
$BIOSInfo.Add("InstallableLanguages            :" + $BIOS.InstallableLanguages          )
$BIOSInfo.Add("InstallDate                     :" + $BIOS.InstallDate                   )
$BIOSInfo.Add("LanguageEdition                 :" + $BIOS.LanguageEdition               )
$BIOSInfo.Add("ListOfLanguages                 :" + $BIOS.ListOfLanguages               )
$BIOSInfo.Add("Manufacturer                    :" + $BIOS.Manufacturer                  )
$BIOSInfo.Add("Name                            :" + $BIOS.Name                          )
$BIOSInfo.Add("OtherTargetOS                   :" + $BIOS.OtherTargetOS                 )
$BIOSInfo.Add("PrimaryBIOS                     :" + $BIOS.PrimaryBIOS                   )
$BIOSInfo.Add("ReleaseDate                     :" + $ReleaseDate                        )
$BIOSInfo.Add("SerialNumber                    :" + $BIOS.SerialNumber                  )
$BIOSInfo.Add("SMBIOSBIOSVersion               :" + $BIOS.SMBIOSBIOSVersion             )
$BIOSInfo.Add("SMBIOSMajorVersion              :" + $BIOS.SMBIOSMajorVersion            )
$BIOSInfo.Add("SMBIOSMinorVersion              :" + $BIOS.SMBIOSMinorVersion            )
$BIOSInfo.Add("SMBIOSPresent                   :" + $BIOS.SMBIOSPresent                 )
$BIOSInfo.Add("SoftwareElementID               :" + $BIOS.SoftwareElementID             )
$BIOSInfo.Add("SoftwareElementState            :" + $SoftwareElementState               )
$BIOSInfo.Add("Status                          :" + $BIOS.Status                        )
$BIOSInfo.Add("SystemBiosMajorVersion          :" + $BIOS.SystemBiosMajorVersion        )
$BIOSInfo.Add("SystemBiosMinorVersion          :" + $BIOS.SystemBiosMinorVersion        )
$BIOSInfo.Add("TargetOperatingSystem           :" + $BIOS.TargetOperatingSystem         )
$BIOSInfo.Add("Version                         :" + $BIOS.Version                       )

$BIOSInfo.Add(""                                                                        )
$BIOSInfo.Add("===================================="                                    )
$BIOSInfo.Add("BIOS Characteristics:"                                                   )
$BIOSInfo.Add("------------------------------------"                                    )
$BIOSInfo.Add($Characteristics                                                          )
$BIOSInfo.Add("------------------------------------"                                    )

$BIOSInfo | Out-File "BIOS-Details.txt"