CLS

# "password1!" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\Users\steve.martin\Downloads\Dropbox (Mesheven)\Titan\IT Management\Powershell\Powershell Scripts\Reporting\secure-password.txt"

$ReportPath = "\\192.168.1.169\IT Management\Reports\Systems"
$SourcePath = "\\192.168.1.169\IT Management\Powershell\Powershell Scripts\Reporting"

$ReportPath      = 'C:\Users\steve.martin\Downloads\Dropbox (Mesheven)\Titan\IT Management\Reports\Systems'
$SourcePath      = 'C:\Users\steve.martin\Downloads\Dropbox (Mesheven)\Titan\IT Management\Powershell\Powershell Scripts\Reporting'
$PasswordFile    = 'secure-password.pwd'
$ComputerName    = $env:COMPUTERNAME
$CurrentDateTime = $((Get-Date).ToString('yyyy-MM-dd HH.mm.ss'))
$CurrentLocation = Get-Location

$PasswordFile    = 'secure-password.pwd'
$ComputerName    = $env:COMPUTERNAME
$CurrentDateTime = $((Get-Date).ToString('yyyy-MM-dd HH.mm.ss'))
$CurrentLocation = Get-Location
                    
$Encoding   = 'UTF8'
$SmtpServer = 'smtp-mail.outlook.com'
$Port       = '587'
$Subject    = "Test using $SmtpServer"
$SmtpUser   = 'mesheven.system.reports@outlook.com'

$FromAddress = 'mesheven.system.reports@outlook.com'
$ToAddress   = 'steve.martin@mesheven.com'
$Password    = Get-Content "$SourcePath\$PasswordFile" | ConvertTo-SecureString

$Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $SmtpUser, $Password

$User = "MyUserName"
$File = "C:\Temp 2\Password.txt"
$MyCredential=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, (Get-Content $File | ConvertTo-SecureString)

Send-MailMessage -To $ToAddress -from $ToAddress -Subject $Subject -SmtpServer $SmtpServer -UseSsl -Credential $Credentials -Encoding $Encoding
