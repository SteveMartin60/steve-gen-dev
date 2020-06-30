CLS

$Class = "Win32_ComputerSystem"
$Class = "Win32_OperatingSystem"
$Class = "Win32_PerfFormattedData_PerfOS_Memory"
$Class = "Win32_StartupCommand"
$Class = "Win32_SoftwareFeature"
$Class = "Win32_Processor"
$Class = "Win32_UserAccount"
$Class = "Win32_ComputerSystem"
$Class = "Win32_BIOS"

$WMIObject = Get-WmiObject -Class $Class

$WMIObject | Format-Table 


