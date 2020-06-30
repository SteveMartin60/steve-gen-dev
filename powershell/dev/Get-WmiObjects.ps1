Clear-Host

$OutputPath = "C:\Users\steve.martin\Downloads\Dropbox (Mesheven)\Asset Management\Powershell Scripts\Powershell Outputs"

Get-WmiObject -List | Export-Csv "$OutputPath\WmiObject.csv"
Get-WmiObject -List | Out-File   "$OutputPath\WmiObject.txt"

Get-CimClass        | Export-Csv "$OutputPath\CimClass.csv"
Get-CimClass        | Out-File   "$OutputPath\CimClass.txt"

$WimClass   = "Win32_MappedLogicalDisk"
$WimClass   = "Win32_ComputerSystem"
$WimClass   = "Win32_OperatingSystem"
$WimClass   = "Win32_BIOS"
$WimClass   = "Win32_Processor"
$WimClass   = "Win32_VoltageProbe"
$WimClass   = "Win32_MotherboardDevice"
$WimClass   = "Win32_BaseBoard"
$WimClass   = "Win32_Battery"
$WimClass   = "Win32_PortableBattery"
$WimClass   = "Win32_StartupCommand"
$WimClass   = "Win32_ProcessStartup"
$WimClass   = "Win32_SystemBIOS"
$WimClass   = "Win32_SystemBootConfiguration"
$WimClass   = "Win32_SystemDevices"
$WimClass   = "Win32_SystemOperatingSystem"
$WimClass   = "Win32_SoftwareFeature"
$WimClass   = "Win32reg_AddRemovePrograms"

# $WimClass   = "Win32_Product"

Get-WmiObject -class $WimClass   | fl * | Out-File "$OutputPath\$WimClass.txt"

<#

Win32_ComputerSystem   | fl * | Out-File "$OutputPath\ComputerSystem.txt"

Win32_OperatingSystem  | fl * | Out-File "$OutputPath\OperatingSystem.txt"

Win32_BIOS             | fl * | Out-File "$OutputPath\BIOS.txt" 

Win32_Processor        | fl * | Out-File "$OutputPath\Processor.txt" 

Win32_VoltageProbe     | fl * | Out-File "$OutputPath\Voltage.txt" 

Win32_MappedLogicalDisk

$ComputerSystem  = Get-WmiObject -class Win32_ComputerSystem  | fl *

Set-Clipboard $ComputerSystem

$OperatingSystem = Get-WmiObject -class Win32_OperatingSystem | fl *

Get-WmiObject -List

Get-CimClass

Get-CimInstance -List

Get-WmiObject -class Win32_OperatingSystem | Select PSComputerName, caption, OSArchitecture, Version, BuildNumber


[Environment]::OSVersion.VersionString

 (Get-WmiObject Win32_OperatingSystem).OSArchitecture

Get-Member -memberType property [a-z]*

$InstallDate = (Get-WmiObject -class Win32_OperatingSystem).InstallDate

$InstallDate.ToString('MM-dd-yyyy')

(gwmi win32_operatingsystem).caption

Get-WmiObject -class win32_operatingsystem | select PSComputerName, caption, OSArchitecture, Version, BuildNumber | fl

gwmi win32_operatingsystem | fl *

#>
