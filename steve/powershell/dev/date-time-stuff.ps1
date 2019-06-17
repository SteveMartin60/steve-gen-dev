CLS

# Get-WmiObject -class Win32_OperatingSystem | Select-Object __SERVER,@{label='LastRestart';expression={$_.ConvertToDateTime($_.LastBootUpTime)}}


$OSData       = Get-WmiObject -class Win32_OperatingSystem
$ComputerName = $OSData.__SERVER
$LastReboot   = $OSData.ConvertToDateTime($OSData.LastBootUpTime)
$TimeNow      = Get-Date
$UpTime       = $TimeNow - $LastReboot

$Days    =  $UpTime.Days
$Hours   =  $UpTime.Hours 
$Minutes =  $UpTime.Minutes
$Seconds =  $UpTime.Seconds

$TimeString = "System Uptime: "

if ($Days    -gt 0){$TimeString = $TimeString + $Days    + " Days, "}

if ($Hours   -gt 0){$TimeString = $TimeString + $Hours   + " Hrs, " } else {$TimeString = $TimeString + "00 Hrs, "}
if ($Minutes -gt 0){$TimeString = $TimeString + $Minutes + " Mins, "} else {$TimeString = $TimeString + "00 Mins, "}
if ($Seconds -gt 0){$TimeString = $TimeString + $Seconds + " Seconds"     }

$TimeString

<#

CLS

Get-WmiObject -class Win32_OperatingSystem |

Select-Object @{
                    label     ='Computer Name';
                    expression={$_.__SERVER}
               },
              @{
                    label     ='Last Reboot';
                    expression={$_.ConvertToDateTime($_.LastBootUpTime)}
               }

#>