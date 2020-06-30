CLS

# Disable Caps Lock
$Binary   = "00,00,00,00,00,00,00,00,02,00,00,00,00,00,3A,00,00,00,00,00"

# Disable Caps Lock & Insert
# $Binary   = "00,00,00,00,00,00,00,00,03,00,00,00,00,00,52,E0,00,00,3A,00,00,00,00,00"

$RegKey   = 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout'

$Name = "Scancode Map"

$hexified = $Binary.Split(',') | % { "0x$_"}

Set-ItemProperty -Path “$RegKey” -Name  $Name -Type Binary -Value ([byte[]]$hexified)

