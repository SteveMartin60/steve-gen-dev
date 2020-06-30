CLS

#..............................................................................

#..............................................................................
Function Get-SpeedTestServers
{

    $SpeedtestServersXML = Invoke-WebRequest "http://www.speedtest.net/speedtest-servers.php"

    [xml]$SpeedtestServerList = $SpeedtestServersXML.Content

    Return $SpeedtestServerList
}
#..............................................................................

#..............................................................................
Function Get-NewTimer
{
    $Timer = [Diagnostics.Stopwatch]::StartNew()

    $Timer.Reset()

    Return $Timer
}
#..............................................................................

#..............................................................................
Function Get-TimerElapsedMilliSeconds($Timer)
{
    Return $Timer.ElapsedMilliseconds
}
#..............................................................................

#..............................................................................
Function Timer-Start($Timer)
{
    $Timer.Start()
}
#..............................................................................

#..............................................................................
Function Timer-Stop($Timer)
{
    $Timer.Stop()
}
#..............................................................................

#..............................................................................
Function Timer-Reset($Timer)
{
    $Timer.Reset()
}
#..............................................................................

#..............................................................................
Function Connected-ToInternet
{
    $NetAdapters = Get-NetAdapter | Where-Object Status -eq "Up" | Where-Object HardwareInterface -eq $true

    $Adapter = $NetAdapters[0]

    $InterfaceIndex = $Adapter.InterfaceIndex

    $ConnectivityInternet = Get-NetConnectionProfile -InterfaceIndex $InterfaceIndex

    $Connected = $ConnectivityInternet.IPv4Connectivity

    if($Connected -eq "Internet")
    {
        Return $true
    }
    else
    {
        Return $false
    }
}
#..............................................................................

#..............................................................................
Function Disable-Proxy
{
    $RegKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'

    if (-Not(Test-Path "$RegKey"))
    {
        New-Item -Path "$($RegKey.TrimEnd($RegKey.Split('\')[-1]))" -Name "$($RegKey.Split('\')[-1])" -Force | Out-Null
    }

    Set-ItemProperty -Path "$RegKey" -Name ProxyEnable -Type DWORD -Value '0'
}
#..............................................................................

#..............................................................................
Function Require-ServerListUpdate($SpeedTestServersFile)
{
    if(Test-Path $SpeedTestServersFile)
    {
        Return Test-Path $SpeedTestServersFile -OlderThan (Get-Date).AddDays(-7).AddHours(-0).AddMinutes(-0)
    }
    else
    {
        Return $true
    }
}
#..............................................................................

#..............................................................................
Function Get-ClosestSpeedtestServers
{
    Write-Host "Finding Closest Servers..."

    $InCountryServers = $SpeedTestServersDetails | Where-Object Country -eq $GeoLocation.country_name

    $ClosestServers = @()

    $Count = 0

    foreach($Server in $InCountryServers)
    {
        $Count++

        $LogMessage = "Calculating Distance of Server " + $Count + ": " + $Server.country + " " + $Server.name + " " + $Server.lat  + " "  + $Server.lon
    
        # Write-Host $LogMessage

        $R = 6371;

        [float]$DistanceLatitude  = ([float]$GeoLocation.latitude  - [float]$Server.lat) * 3.14 / 180;
        [float]$DistanceLongitude = ([float]$GeoLocation.longitude - [float]$Server.lon) * 3.14 / 180;

        [float]$a = [math]::Sin([float]$DistanceLatitude/2) * [math]::Sin([float]$DistanceLatitude/2) + [math]::Cos([float]$GeoLocation.latitude * 3.14 / 180 ) * [math]::Cos([float]$Server.lat * 3.14 / 180 ) * [math]::Sin([float]$DistanceLongitude/2) * [math]::Sin([float]$DistanceLongitude/2);
    
        [float]$c = 2 * [math]::Atan2([math]::Sqrt([float]$a ), [math]::Sqrt(1 - [float]$a));
    
        [float]$d = [float]$R * [float]$c;

        $ServerInformation += @([pscustomobject]@{Distance = $d; Country = $Server.country; Sponsor = $Server.sponsor; Url = $Server.url })
    }

    $ServerInformation = $ServerInformation | Sort-Object -Property Distance

    for($i = 0; $i -lt $TestCount; $i++)
    {
        $ClosestServers += $ServerInformation[$i]
    }

    Return $ClosestServers
}
#..............................................................................

#..............................................................................
Function Get-SpeedtestServerDetails
{
    Write-Host "Getting Speedtest Server List..."

    if(Require-ServerListUpdate($SpeedTestServersFile))
    {
        $SpeedTestServers = Get-SpeedTestServers

        $SpeedTestServersDetails = $SpeedTestServers.settings.servers.server

        $SpeedTestServersDetails | Export-Clixml $SpeedTestServersFile
    }
    else
    {
        $SpeedTestServersDetails = Import-Clixml $SpeedTestServersFile
    }

    Return  $SpeedTestServersDetails
}
#..............................................................................

#..............................................................................
Function Astrill-Running
{
    $ProcessName = "Astrill"

    $ProcessList = Get-Process $ProcessName -ErrorAction SilentlyContinue

    if($ProcessList)
    {
        Return $true
    }
    else
    {
        Return $false
    }
}
#..............................................................................

#..............................................................................
Function Start-Astrill
{
    if(Astrill-Running)
    {
        Return
    }

    Write-Host "Starting Astrill..."

    $Path = 'HKLM:\SOFTWARE\microsoft\Windows\CurrentVersion\Uninstall\*'

    $SoftwareFound = Get-ItemProperty $Path | Where-Object DisplayName -match "Astrill" | Select-Object InstallLocation

    $AstrillPath = $SoftwareFound.InstallLocation

    $AstrillPath = $AstrillPath + "Astrill.exe"

    Start-Process $AstrillPath

    Return $AstrillPath
}
#..............................................................................

#..............................................................................
Function Stop-Astrill
{
    if(Astrill-Running)
    {
        Write-Host "Stopping Astrill..."

        $Timeout = 5
        $ProcessName = "Astrill"

        $ProcessList = Get-Process $ProcessName -ErrorAction SilentlyContinue

        if ($ProcessList)
        {
            $ProcessList.CloseMainWindow() | Out-Null

            for ($i = 0 ; $i -le $Timeout; $i ++)
            {
                $AllHaveExited = $True

                foreach($Process in $ProcessList)
                {
                    If (!$Process.HasExited)
                    {
                        $AllHaveExited = $False
                    }                    
                }
                If ($AllHaveExited)
                {
                    Return
                }

                Sleep 1
            }

            $ProcessList | Stop-Process -Force        
        }
    }
}
#..............................................................................

#..............................................................................
Function Get-GeoLocation
{
    Write-Host "Getting Geo Location..."

    $GeoIpInfo = Invoke-RestMethod https://freegeoip.app/json

    Return $GeoIpInfo
}
#..............................................................................

#..............................................................................
Function DownloadSpeed($UploadUrl)
{
    Write-Host "Running Speed Test:" $UploadUrl

    $topServerUrlSpilt = $UploadUrl -split 'upload'

    $URL = $topServerUrlSpilt[0] + 'random2000x2000.jpg'

    $Collection = New-Object System.Collections.Specialized.NameValueCollection 

    $WebClient = New-Object system.Net.WebClient

    $WebClient.QueryString = $Collection

    $DownloadElaspedTime = (Measure-Command {$WebPage1 = $WebClient.DownloadData($URL)}).totalmilliseconds

    $String = [System.Text.Encoding]::ASCII.GetString($WebPage1)

    $DownSize = ($WebPage1.length + $WebPage2.length) / 1Mb

    $DownloadSize = [Math]::Round($DownSize, 2)

    $DownloadTimeSec = $DownloadElaspedTime * 0.001

    $DownSpeed = ($DownloadSize / $DownloadTimeSec) * 8

    $DownloadSpeed = [Math]::Round($DownSpeed, 2)

    Return $DownloadSpeed
}
#..............................................................................

#..............................................................................
Function Execute-SpeedTests
{
    $SpeedResults = @()

    for($i = 0; $i -lt $TestCount; $i++)
    {
        $SpeedResults += @(DownloadSpeed($ClosestServers[$i].url))
    }

    Return $SpeedResults
}
#..............................................................................

#..............................................................................
Function Write-ReportToHost
{
    Write-Host "----------------------------"
    Write-Host "Internet Speed Test Results"
    Write-Host "----------------------------"
    Write-Host "Test Location"
    Write-Host "-------------"
    Write-Host "Country         :" $GeoLocation.country_name
    Write-Host "City            :" $GeoLocation.city
    Write-Host "Origin Latitude :" $GeoLocation.latitude
    Write-Host "Origin Longitude:" $GeoLocation.longitude
    Write-Host "IP Address      :" $GeoLocation.ip
    Write-Host "Date            :" $TodayDate
    Write-Host "Time            :" $NowTime  
    Write-Host "-------------"
    Write-Host "Test Results"
    Write-Host "-------------"
    Write-Host "Peak Speed   : $PeakSpeed$SpeedUnits"
    Write-Host "Average Speed: $AverageSpeed$SpeedUnits"
    Write-Host "----------------------------"
}
#..............................................................................

#..............................................................................

$Timer          = Get-NewTimer
$TodayDate      = Get-Date -UFormat "%Y-%m-%d"
$NowTime        = Get-Date -UFormat "%H:%M:%S"
$RestartAstrill = Astrill-Running

$SpeedTestServersFile = "\\192.168.1.169\IT Management\Powershell\Powershell Scripts\Management\speedtest-servers.xml"
$CsvReportFile        = "\\192.168.1.169\IT Management\Reports\Management\Internet-Connection.csv"
$TestCount            = 6

if(Connected-ToInternet)
{
    Timer-Start($Timer)

    Stop-Astrill
    Disable-Proxy

    $GeoLocation             = Get-GeoLocation

    $SpeedTestServersDetails = Get-SpeedtestServerDetails

    $ClosestServers          = Get-ClosestSpeedtestServers

    $SpeedResults            = Execute-SpeedTests

    $MeasuredResults         = $SpeedResults | Measure-Object -Average -Maximum

    $PeakSpeed    = [Math]::Round($MeasuredResults.Maximum, 2) 
    $AverageSpeed = [Math]::Round($MeasuredResults.Average, 2) 
    $SpeedUnits   = "Mbit/Sec"

    if($RestartAstrill)
    {
        Start-Astrill
    }

    Timer-Stop($Timer)

    $ElapsedTime = Get-TimerElapsedMilliSeconds($Timer)

    $CsvReport  = @()
    $AppendData = $false

    Write-ReportToHost

    if(Test-Path $CsvReportFile)
    {
        $CsvReport = Get-Content $CsvReportFile
        $AppendData = $true
    }

    $CsvHeader = "Time`tPeakSpeed`tAverageSpeed`Country`tCity`tOriginLatitude`tOriginLongitude`tIPAddress`tDate`tElapsedTime(ms)"

    $Country         = $GeoLocation.country_name
    $City            = $GeoLocation.city
    $OriginLatitude  = $GeoLocation.latitude
    $OriginLongitude = $GeoLocation.longitude
    $IPAddress       = $GeoLocation.ip

    $TestData  = "$NowTime`t$PeakSpeed`t$AverageSpeed`t$Country`t$City`t$OriginLatitude`t$OriginLongitude`t$IPAddress`t$TodayDate`t$ElapsedTime"

    if(!($AppendData))
    {
        $CsvReport += $CsvHeader
    }

    $CsvReport += $TestData

    $CsvReport | Out-File $CsvReportFile
}
