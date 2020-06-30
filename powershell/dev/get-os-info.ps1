CLS

Get-WmiObject Win32_OperatingSystem |



Select-Object `
@{
     label     ='Computer Name';
     expression={$_.__SERVER}
 },
@{
     label     ='Last Reboot';
     expression={$_.ConvertToDateTime($_.LastBootUpTime)}
 }
