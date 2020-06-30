CLS

# Set-ExecutionPolicy Unrestricted

$State = "Enabled"

Get-WindowsOptionalFeature -Online | Where-Object State -eq $State

Set-ExecutionPolicy Restricted
