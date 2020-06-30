CLS

$Stat = nbtstat -A 10.0.4.28

$ComputerName = $Stat | ?{$_ -match '\<00\>  Unique'} | %{$_.SubString(4,14)}
$WorkGroup    = $Stat | ?{$_ -match '  GROUP' } | %{$_.SubString(4,14)}
$MacAddress   = $Stat | ?{$_ -match 'MAC Address'   } | %{$_.SubString(18)}

$ComputerName
$WorkGroup 
$MacAddress

$NetAdapters = Get-NetAdapter | Where-Object Status -eq "Up" | Where-Object HardwareInterface -eq $true

$NetAdapters.MacAddress

$System = Get-WmiObject Win32_ComputerSystem

$System.Domain
$System.Name