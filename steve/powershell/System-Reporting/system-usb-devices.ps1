CLS

Get-WmiObject Win32_USBControllerDevice |%{[wmi]($_.Dependent)} | Sort Name, DeviceID | Format-Table Name, Status, DeviceID | Out-File "USB-Devices.txt"
