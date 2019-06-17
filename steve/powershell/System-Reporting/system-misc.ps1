CLS

#..............................................................................
# Startup Commands"
#..............................................................................

$Class = "Win32_StartupCommand"

Get-WmiObject -Class $Class | Sort-Object "Command" | Format-Table -AutoSize | Out-String -Width 250 | Out-File "Startup-Commands.txt" 

#..............................................................................
# Motherboard Details
#..............................................................................

$Class = "Win32_BaseBoard"

$WMIObject = Get-WmiObject -Class $Class | Format-List | Out-File "Motherboard-Details.txt" 

#..............................................................................
# User Accounts
#..............................................................................

$Class = "Win32_UserAccount"

$WMIObject = Get-WmiObject -Class $Class | Select-Object Name, Caption, Domain, SID | Out-File "User-Accounts.txt" 

#..............................................................................

#..............................................................................
