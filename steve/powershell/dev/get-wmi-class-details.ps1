CLS

$Class = "Win32_ComputerSystem"
$Class = "Win32_BIOS"
# $Class = "Win32_LocalTime"

$Object = Get-WmiObject -Class $Class | Get-Member

$Object
