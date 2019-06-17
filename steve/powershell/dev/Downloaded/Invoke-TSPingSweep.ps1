CLS

#..............................................................................

#..............................................................................
Function Invoke-TSPingSweep
{
    Param
    (
        [parameter(Mandatory = $true, Position = 0)][ValidatePattern("\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b")][string]$StartAddress,
        [parameter(Mandatory = $true, Position = 1)][ValidatePattern("\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b")][string]$EndAddress,
        [switch]$ResolveHost,
        [switch]$ScanPort,
        [int[]]$Ports = @(21,22,23,53,69,71,80,98,110,139,111,389,443,445,1080,1433,2001,2049,3001,3128,5222,6667,6868,7777,7878,8080,1521,3306,3389,5801,5900,5555,5901),
        [int]$TimeOut = 100
    )

    Begin
    {
        $ping = New-Object System.Net.NetworkInformation.Ping
    }

    Process
    {
        foreach($a in ($StartAddress.Split(".")[0]..$EndAddress.Split(".")[0]))
        {
            foreach($b in ($StartAddress.Split(".")[1]..$EndAddress.Split(".")[1]))
            {
                foreach($c in ($StartAddress.Split(".")[2]..$EndAddress.Split(".")[2]))
                {
                  foreach($d in ($StartAddress.Split(".")[3]..$EndAddress.Split(".")[3]))
                  {
                      Write-Progress -Activity PingSweep -status "$a.$b.$c.$d" -PercentComplete (($d/($EndAddress.Split(".")[3])) * 100)
                      $PingStatus = $ping.Send("$a.$b.$c.$d",$TimeOut)
                      
                      if($PingStatus.Status -eq "Success")
                      {
                          if($ResolveHost)
                          {
                              Write-Progress -activity ResolveHost -Status "$a.$b.$c.$d" -PercentComplete (($d/($EndAddress.Split(".")[3])) * 100) -Id 1

                              $GetHostEntry = [Net.DNS]::BeginGetHostEntry($PingStatus.Address, $null, $null)
                          }
                      
                          if($ScanPort)
                          {
                              $OpenPorts = @()

                              for($i = 1; $i -le $ports.Count; $i++)
                              {
                                  $port = $Ports[($i-1)]
                                  
                                  Write-Progress -Activity PortScan -Status "$a.$b.$c.$d" -PercentComplete (($i/($Ports.Count)) * 100) -Id 2
                                  
                                  $Client = New-Object System.Net.Sockets.TcpClient
                                  
                                  $BeginConnect = $Client.BeginConnect($PingStatus.Address,$port,$null,$null)
                                  
                                  if($Client.Connected)
                                  {
                                      $OpenPorts += $port
                                  }
                                  else
                                  {
                                      # Wait
                                      Start-Sleep -Milli $TimeOut
  
                                      if($Client.Connected)
                                      {
                                          $OpenPorts += $port
                                      }
                                  }
                              
                                  $Client.Close()
                              }
                          }
                      
                          if($ResolveHost)
                          {
                              $HostName = ([Net.DNS]::EndGetHostEntry([IAsyncResult]$GetHostEntry)).HostName
                          }

                          # Return Object
                          New-Object PSObject -Property @{IPAddress = "$a.$b.$c.$d"; HostName = $HostName; Ports = $OpenPorts} | Select-Object IPAddress, HostName, Ports
                      }
                  }
                }
            }
        }
    }

    End{}
}
#..............................................................................

#..............................................................................
Function Get-LocalNetworkConnections
{
    if(Test-Connection -ComputerName $Computer -Count 1 -ErrorAction SilentlyContinue)
    {
        try
        {
            $Networks = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $Computer -ErrorAction Stop | ? {$_.IPEnabled}
        }
        catch
        {
            Write-Warning "Error occurred while querying $Computer."
            Continue
        }
    
        foreach ($Network in $Networks)
        {
            $IPAddress      =  $Network.IpAddress[0]
            $SubnetMask     =  $Network.IPSubnet[0]
            $DefaultGateway = ($Network.DefaultIPGateway     -join ",")
            $DNSServers     = ($Network.DNSServerSearchOrder -join ",")
            $IsDHCPEnabled  =  $false

            if($network.DHCPEnabled)
            {
                $IsDHCPEnabled = $true
            }

            $MACAddress  = $Network.MACAddress

            $NetworkConnections  = New-Object -Type PSObject

            $NetworkConnections | Add-Member -MemberType NoteProperty -Name ComputerName   -Value $Computer
            $NetworkConnections | Add-Member -MemberType NoteProperty -Name IPAddress      -Value $IPAddress
            $NetworkConnections | Add-Member -MemberType NoteProperty -Name SubnetMask     -Value $SubnetMask
            $NetworkConnections | Add-Member -MemberType NoteProperty -Name DefaultGateway -Value $DefaultGateway
            $NetworkConnections | Add-Member -MemberType NoteProperty -Name DHCPEnabled    -Value $IsDHCPEnabled
            $NetworkConnections | Add-Member -MemberType NoteProperty -Name DNSServer      -Value $DNSServers
            $NetworkConnections | Add-Member -MemberType NoteProperty -Name MACAddress     -Value $MACAddress
        }
    }

    Return  $NetworkConnections
}
#..............................................................................

#..............................................................................
Function Get-Local-Network
{
    $Computer = $env:COMPUTERNAME

    $NetworkConnections = Get-LocalNetworkConnections

    $IPAddress = $NetworkConnections.IPAddress

    $Separator = $IPAddress.LastIndexOf(".") 

    $Network = $IPAddress.substring(0, $Separator   ) 
    # $Node    = $IPAddress.substring(   $Separator +1)

    Return $Network
}

$LocalNetwork = Get-Local-Network

$LocalNetwork

$StartAddress = $LocalNetwork + ".1"
$EndAddress   = $LocalNetwork + ".254"

Invoke-TSPingSweep -ResolveHost -ScanPort -StartAddress $StartAddress -EndAddress $EndAddress

