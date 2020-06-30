#Broadcast messages, by Maxzor1908 *12/3/2013*

$Comp = "finserver"


$msg = "msg * "

Invoke-WmiMethod -Path Win32_Process -Name Create -ArgumentList $msg -ComputerName $Comp