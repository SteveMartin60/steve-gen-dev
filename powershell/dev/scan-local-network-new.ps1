CLS

#..............................................................................

#..............................................................................
Function setPaths
{
    CLS

    $currentFolder = Split-Path $psISE.CurrentFile.FullPath

    Set-Location -Path $currentFolder

    Import-Module ..\Utils\vars.psm1

    $CurrentLocation = Get-Location

    CD -Path .. -PassThru
    CD -Path .. -PassThru

    $Path = $common

    $ReportsPath = Get-Location

    $ReportsPath = "$ReportsPath\reports"

    $SystemReportsPath = "$ReportsPath\System-Reports"

    if (!(Test-Path $ReportsPath))
    {
        New-Item -ItemType Directory $ReportsPath
    }

    if (!(Test-Path $SystemReportsPath))
    {
        New-Item -ItemType Directory $SystemReportsPath
    }

    Set-Location $ReportsPath
}
#..............................................................................

#..............................................................................
Function Write-ReportHeader
{
    $reportHeader.Add("========================================"    )
    $reportHeader.Add("Network Sweep Report"                        )
    $reportHeader.Add("========================================"    )
    $reportHeader.Add(""                                            )
    $reportHeader.Add("==================================="         )
    $reportHeader.Add("Report Summary"                              )
    $reportHeader.Add("-----------------------------------"         )
    $reportHeader.Add("Computer Name    : " + $ComputerName         )
    $reportHeader.Add("Command          : Get-LocalNetwork"         )
    $reportHeader.Add("Report Date      : " + $TodayDate            )
    $reportHeader.Add("Report Time      : " + $NowTime              )
    $reportHeader.Add("Total Connections: " + $NetworkSweep.Count   )
    $reportHeader.Add("-----------------------------------"         )
    $reportHeader.Add(""                                            )
}
#..............................................................................

#..............................................................................
Function Get-HostName($IPAddress)
{
    $Result = Resolve-DnsName -QuickTimeout $IPAddress

    Return $Result
}
#..............................................................................

#..............................................................................
Function Validate-Address($IPAddress)
{
    $Result = $true
    $Resolve = $null

    $Ping = New-Object System.Net.NetworkInformation.Ping

    $PingStatus = $Ping.Send($IPAddress, $TimeOut)

    if($PingStatus.Status -eq "Success")
    {
        $Resolve = Resolve-DnsName -QuickTimeout $IPAddress -ErrorAction SilentlyContinue
    }

    if($Resolve.NameHost.Length -lt 1)
    {
        $Result = $false
    }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-MacAddressVendor($MacAddress)
{
    $URI = "https://api.macvendors.com/" + $MacAddress

    Return Invoke-RestMethod $URI
}
#..............................................................................

#..............................................................................
Function Find-OpenPorts($IpAddress)
{
    $Ports     = @(21,22,23,53,69,71,80,98,110,139,111,389,443,445,1080,1433,2001,2049,3001,3128,5222,6667,6868,7777,7878,8080,1521,3306,3389,5801,5900,5555,5901)

    $OpenPorts = @()

    for($i = 1; $i -le $ports.Count; $i++)
    {
        $Port = $Ports[($i-1)]
                                  
        Write-Progress -Activity PortScan -Status "$IpAddress" -PercentComplete (($i/($Ports.Count)) * 100) -Id 2
                                  
        $Client = New-Object System.Net.Sockets.TcpClient

        try
        {
            $Client.Connect($IpAddress, $Port) 
        }
        catch
        {}

        if($Client.Connected)
        {
            $OpenPorts += $Port
        }
        else
        {
            Start-Sleep -Milli $TimeOut
  
            if($Client.Connected)
            {
                $OpenPorts += $Port
            }
        }
                              
        $Client.Close()
    }

    Return $OpenPorts -join ", "
}
#..............................................................................

#..............................................................................
Function Get-LocalNetwork
{
    if(Test-Connection -ComputerName $Env:COMPUTERNAME -Count 1 -ErrorAction SilentlyContinue)
    {
        try
        {
            $Networks = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object IPEnabled -eq $true | Where-Object Description -ne "Astrill SSL VPN Adapter"| Where-Object Description -ne "VirtualBox Host-Only Ethernet Adapter"

            $LocalNetwork = ($Networks.DefaultIPGateway)[0]

            $Separator = $LocalNetwork.LastIndexOf(".")
            
            $Separator = [int]$Separator
            
            $Separator = $Separator + 1

            $LocalNetwork = $LocalNetwork.substring(0, 9) 
        }
        catch
        {
            Write-Warning "Error occurred while querying $ComputerName."
            Continue
        }
    }

    Return  $LocalNetwork
}
#..............................................................................

#..............................................................................
Function Execute-NetworkSweep
{
    for($i = $StartAddress; $i -lt ($EndAddress + 1); $i++)
    {
        $Address = $LocalNetwork + $i

        if(Validate-Address($Address))
        {
            $connectionCount = $connectionCount + 1

            Write-Host "============================================"
            Write-Host "Scanning: $Address"

            $foundConnections.Add("============================================")
            $foundConnections.Add("Scanning: $Address"                          )

            $Stat = nbtstat -A $Address

            $RComputerName = $Stat | ?{$_ -match '\<00\>  Unique'} | %{$_.SubString(4,14)}
            $WorkGroup     = $Stat | ?{$_ -match '  GROUP'       } | %{$_.SubString(4,14)}
            $MacAddress    = $Stat | ?{$_ -match 'MAC Address'   } | %{$_.SubString(18)}

            $MacAddressVendor = Get-MacAddressVendor $MacAddress

            $HostName = Get-HostName($Address)
            
            $OpenPorts = Find-OpenPorts($Address)

            Write-Host "Computer Name:" $HostName.NameHost
            Write-Host "Open Ports   :" $OpenPorts
            Write-Host "Work Group   :" $WorkGroup
            Write-Host "Mac Address  :" $MacAddress
            Write-Host "Mac Vendor   :" $MacAddressVendor
            
            Write-Host "--------------------------------------------"
            Write-Host ""

            $foundConnections.Add("Computer Name: $HostName.NameHost")
            $foundConnections.Add("Open Ports   : $OpenPorts        ")
            $foundConnections.Add("Work Group   : $WorkGroup        ")
            $foundConnections.Add("Mac Address  : $MacAddress       ")
            $foundConnections.Add("Mac Vendor   : $MacAddressVendor ")
            
            $foundConnections.Add("--------------------------------------------")
            $foundConnections.Add(""                                            )
        }
    }
}
#..............................................................................

#..............................................................................

setPaths

$TimeOut   = 100
$TodayDate = Get-Date -UFormat "%Y-%m-%d"
$NowTime   = Get-Date -UFormat "%H:%M:%S"

$ComputerName    = $Env:COMPUTERNAME
$LocalNetwork    = Get-LocalNetwork
$StartAddress    = [int]1
$EndAddress      = [int]130
$connectionCount = 0

$foundConnections  = New-Object Object
$reportHeader      = New-Object Object

$foundConnectionsTemp = @{}
$reportHeaderTemp     = @{}

$foundConnections = {$foundConnectionsTemp}.Invoke()
$reportHeader     = {$reportHeaderTemp    }.Invoke()

$OutFile = "$ReportsPath\network-scan.txt"

Execute-NetworkSweep

Write-ReportHeader

$networkScanReport = $reportHeader

$networkScanReport += $foundConnections

$networkScanReport | Out-File $OutFile

