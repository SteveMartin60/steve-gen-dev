$TaskName = "GenerateSystemReports"

$Script   = "\\192.168.1.169\IT Management\Powershell\Powershell Scripts\Reporting\generate-report.ps1"

$Action   = New-ScheduledTaskAction –Execute "powershell.exe" -Argument  "$Script"

$Trigger  = New-ScheduledTaskTrigger -daily -At 7am

$Description ="Generate System Reports"

$msg = "Enter the username and password that will run the task"; 

$Credential = $Host.UI.PromptForCredential("Task username and password",$msg,"$env:userdomain\$env:username",$env:userdomain)

$Username = $Credential.UserName

$Password = $Credential.GetNetworkCredential().Password

$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd

Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -RunLevel Highest -User $Username -Password $Password -Settings $settings -Description $Description