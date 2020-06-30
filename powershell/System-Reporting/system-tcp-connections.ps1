CLS

#..............................................................................

#..............................................................................
Function Get-RemoteConnectionInfo($Connection)
{
    $ConnectionInfo = New-Object Object
    $ConnectionInfoTemp  = @{}
    $ConnectionInfo = {$RemoteConnectionInfoTemp}.Invoke()

    $IpInfo    = Get-IpInfo   ($Connection.RemoteAddress)
    $GeoIpInfo = Get-FreeGeoIp($Connection.RemoteAddress)

    $Hostname    = $IpInfo.hostname
    $ISP         = $IpInfo.org     
    $CountryCode = $GeoIpInfo.country_code
    $CountryName = $GeoIpInfo.country_name

    $ConnectionInfo =
    @{
        "IpAddress"   = $Address
        "Hostname"    = $IpInfo.hostname
        "ISP"         = $IpInfo.org     
        "CountryCode" = $GeoIpInfo.country_code
        "CountryName" = $GeoIpInfo.country_name
        }

    Return $ConnectionInfo
}
#..............................................................................

#..............................................................................
Function Get-LocalHostIpAddress
{
    $LocalHost = Get-NetIPAddress | Where-Object {($_.InterfaceAlias -match "Loopback") -and ($_.AddressFamily -eq "IPv4")} | Select-Object IPAddress

    Return $LocalHost.IPAddress
}
#..............................................................................

#..............................................................................
Function Get-ProcessGroups
{
    $Groups = $ConnectedProcesses | Group-Object | Sort-Object Count

    $ProcessGroups = New-Object Object
    $ProcessGroupsTemp  = @{}
    $ProcessGroups = {$ProcessGroupsTemp}.Invoke()

    foreach($Group in $Groups)
    {
        if($Group.Name.Length -gt 1)
        {
            [string]$GroupCount = $Group.Count
            [string]$FilePath   = Split-Path $Group.Name -Parent
            [string]$FileName   = Split-Path $Group.Name -Leaf
            [string]$GroupName  = [System.IO.Path]::GetFileNameWithoutExtension($FileName)

            $ProcessGroup =
            @{
                "GroupName" =  $GroupName
                "Count"     = $GroupCount
                "FileName"  = $FileName
                "FilePath"  = $FilePath 
             }

            $ProcessGroups += $ProcessGroup
        }
    }

    Return $ProcessGroups
}
#..............................................................................

#..............................................................................
Function Get-NetworkStatistics 
{ 
    $properties = ‘Protocol’,’LocalAddress’,’LocalPort’, ‘RemoteAddress’,’RemotePort’,’State’,’ProcessName’,’PID’

    netstat -ano | Select-String -Pattern ‘\s+(TCP|UDP)’ | ForEach-Object `
    {

        $item = $_.line.split(” “,[System.StringSplitOptions]::RemoveEmptyEntries)

        if($item[1] -notmatch ‘^\[::’) 
        {            
            if (($la = $item[1] -as [ipaddress]).AddressFamily -eq ‘InterNetworkV6’) 
            { 
                $localAddress = $la.IPAddressToString 
                $localPort    = $item[1].split(‘\]:’)[-1] 
            } 
            else 
            { 
                $localAddress = $item[1].split(‘:’)[0] 
                $localPort    = $item[1].split(‘:’)[-1] 
            } 

            if (($ra = $item[2] -as [ipaddress]).AddressFamily -eq ‘InterNetworkV6’) 
            { 
                $remoteAddress = $ra.IPAddressToString 
                $remotePort    = $item[2].split(‘\]:’)[-1] 
            } 
            else 
            { 
                $remoteAddress = $item[2].split(‘:’)[0] 
                $remotePort    = $item[2].split(‘:’)[-1] 
            } 

            New-Object PSObject -Property `
            @{ 
                PID           = $item[-1] 
                ProcessName   = (Get-Process -Id $item[-1] -ErrorAction SilentlyContinue).Name 
                Protocol      = $item[0] 
                LocalAddress  = $localAddress 
                LocalPort     = $localPort 
                RemoteAddress = $remoteAddress 
                RemotePort    = $remotePort 
                State         = if($item[0] -eq ‘tcp’) {$item[3]} else {$null} 
            } | Select-Object -Property $properties 
        } 
    } 
}
#..............................................................................

#..............................................................................
Function Get-LocalNetworkConnections
{
    if(Test-Connection -ComputerName $Computer -Count 1 -ErrorAction SilentlyContinue)
    {
        try
        {
            $Networks = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $Computer -ErrorAction Stop | Where-Object {($_.IPEnabled) -and !($_.Description -match "VPN")}
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

            if($Network.DHCPEnabled)
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
Function Get-LocalNetwork
{
    $NetworkConnections = Get-LocalNetworkConnections

    $IPAddress = $NetworkConnections.IPAddress

    $Separator = $IPAddress.LastIndexOf(".") 

    $Network = $IPAddress.substring(0, $Separator   ) 

    Return $Network
}
#..............................................................................

#..............................................................................
Function Get-LocalAddresses
{
    $Addresses       = $TcpConnections | Select-Object LocalAddress

    $LocalAddresses = @()

    foreach($Address in $Addresses)
    {
        if(($Address.LocalAddress -match $LocalNetwork) -or ($Address.LocalAddress -match "0.0.0.0") -or ($Address.LocalAddress -match $LocalHost))
        {
            $LocalAddresses += $Address.LocalAddress
        }
    }

    $Addresses = $TcpConnections | Select-Object RemoteAddress

    foreach($Address in $Addresses)
    {
        if($Address.RemoteAddress -match $LocalNetwork)
        {
            $LocalAddresses += $Address.RemoteAddress
        }
    }

    $LocalAddresses = $LocalAddresses | Sort -Unique

    Return $LocalAddresses
}
#..............................................................................

#..............................................................................
Function Get-RemoteAddresses
{
    $Addresses = $TcpConnections | Select-Object RemoteAddress

    $RemoteAddresses = @()

    foreach($Address in $Addresses)
    {
        $RemAddr = $Address.RemoteAddress

        if(!($LocalAddresses.Contains($RemAddr)) -and ($RemAddr -ne "::"))
        {
            $RemoteAddresses += $Address.RemoteAddress
        }
    }

    $RemoteAddresses = $RemoteAddresses | Sort -Unique

    Return $RemoteAddresses
}
#..............................................................................

#..............................................................................
Function Get-IpInfo($IpAddress)
{
    Return Invoke-RestMethod https://ipinfo.io/$IpAddress/json}
#..............................................................................

#..............................................................................
Function Get-FreeGeoIp($IpAddress)
{
    Return Invoke-RestMethod https://freegeoip.app/json/$IpAddress
}
#..............................................................................

#..............................................................................
Function Write-ReportSummary
{
    $TcpSummaryReport     = New-Object Object
    $TcpSummaryReportTemp = @{}
    $TcpSummaryReport     = {$TcpSummaryReportTemp}.Invoke()

    $ReportDate = Get-Date -UFormat "%Y-%m-%d"
    $ReportTime = Get-Date -UFormat "%H:%M:%S"

    $TcpSummaryReport.Add("========================================"             )
    $TcpSummaryReport.Add("System TCP Connections Report"                        )
    $TcpSummaryReport.Add("========================================"             )
    $TcpSummaryReport.Add(""                                                     )
    $TcpSummaryReport.Add("============================"                         )
    $TcpSummaryReport.Add("Report Summary"                                       )
    $TcpSummaryReport.Add("----------------------------"                         )
    $TcpSummaryReport.Add("Computer Name: " + $Env:COMPUTERNAME                  )
    $TcpSummaryReport.Add("Report Date  : " + $ReportDate                        )
    $TcpSummaryReport.Add("Report Time  : " + $ReportTime                        )
    $TcpSummaryReport.Add("Command      : Get-NetTCPConnection"                  )
    $TcpSummaryReport.Add("----------------------------"                         )
    $TcpSummaryReport.Add("Total TCP Connections : "  + $TcpConnections.    Count)
    $TcpSummaryReport.Add("Connected Processes   : "  + $ConnectedProcesses.Count)
    $TcpSummaryReport.Add("Connected Applications: "  + $ProcessGroups.     Count)
    $TcpSummaryReport.Add("Connected Local Ports : "  + $LocalPorts.        Count)
    $TcpSummaryReport.Add("Connected Remote Ports: "  + $RemotePorts.       Count)
    $TcpSummaryReport.Add("============================"                         )

    Return $TcpSummaryReport
}
#..............................................................................

#..............................................................................
Function Get-ProcessName($Process)
{
    $ProcessName = $Process.Name

    if($ProcessName.Length -lt 1)
    {
        $ProcessName = $Process.ProcessName
    }

    if($ProcessName.Length -lt 1)
    {
        $ProcessName = "Process Name Not Found"
    }

    Return $ProcessName
}
#..............................................................................

#..............................................................................
Function Get-ProcessByID($ProcessID)
{
    try
    {
        $Process = Get-Process -ErrorAction SilentlyContinue | Where-Object Id -eq $ProcessID 
    }
    catch
    {}

    Return $Process
}
#..............................................................................

#..............................................................................
Function Get-BasePriority($Process)
{
    if($Process.BasePriority -eq 4 ) {Return "Idle"    }
    if($Process.BasePriority -eq 8 ) {Return "Normal"  }
    if($Process.BasePriority -eq 13) {Return "High"    }
    if($Process.BasePriority -eq 24) {Return "RealTime"}

    Return "Unknown: " + $Process.BasePriority
}
#..............................................................................

#..............................................................................
Function Get-TcpConnectionReport
{
    $TcpConnectionReport     = New-Object Object
    $TcpConnectionReportTemp = @{}
    $TcpConnectionReport     = {$TcpConnectionReportTemp}.Invoke()

    $Count = 0

    foreach($Connection in $TcpConnections)
    {
        $Count++
        $ProgessStatus = "$Count of " + $TcpConnections.Count
         
        Write-Progress -Activity "Scanning TCP Connections.." -Status $ProgessStatus -PercentComplete (($Count/($TcpConnections.Count)) * 100) -Id 2

        $Process         = Get-ProcessByID($Connection.OwningProcess)
        $BasePriority    = Get-BasePriority($Process)
        $ThreadCount     = $Process.Threads.Count
        $ProcessModules  = $Process.Modules
        $MainModule      = $Process.MainModule
        $FileVersionInfo = $MainModule.FileVersionInfo
        $NetUDPEndpoint  = Get-NetUDPEndpoint -OwningProcess $Process.Id -ErrorAction SilentlyContinue
        $ProcessName     = Get-ProcessName($Process)

        if($MainModule)
        {
            $HasMainModule = $true
        }
        else
        {
            $HasMainModule = $false
        }

        $TCPConnectionReport.Add("-------------------------------------------------"            )
        $TCPConnectionReport.Add("Connection Details ($Count of " + $TcpConnections.Count + ")" )
        $TCPConnectionReport.Add("-------------------------------------------------"            )
        $TCPConnectionReport.Add("Process Name            : " + $ProcessName                    )
        $TCPConnectionReport.Add("Process ID              : " + $Connection.OwningProcess       )
        $TCPConnectionReport.Add("State                   : " + $Connection.State               )
        $TCPConnectionReport.Add("OffloadState            : " + $Connection.OffloadState        )
        $TCPConnectionReport.Add("InstanceID              : " + $Connection.InstanceID          )
        $TCPConnectionReport.Add("EnabledDefault          : " + $Connection.EnabledDefault      )
        $TCPConnectionReport.Add("RequestedState          : " + $Connection.RequestedState      )
        $TCPConnectionReport.Add("TransitioningToState    : " + $Connection.TransitioningToState)
        $TCPConnectionReport.Add("CreationTime            : " + $Connection.CreationTime        )
        $TCPConnectionReport.Add("LocalAddress            : " + $Connection.LocalAddress        )
        $TCPConnectionReport.Add("LocalPort               : " + $Connection.LocalPort           )
        $TCPConnectionReport.Add("OwningProcess           : " + $Connection.OwningProcess       )
        $TCPConnectionReport.Add("RemoteAddress           : " + $Connection.RemoteAddress       )
        $TCPConnectionReport.Add("RemotePort              : " + $Connection.RemotePort          )
        $TCPConnectionReport.Add("Has Main Module         : " + $HasMainModule                  )
        $TCPConnectionReport.Add("Module Count            : " + $ProcessModules.Count           )
        $TCPConnectionReport.Add("---------------"                                              )
        $TCPConnectionReport.Add("Process Details"                                              )
        $TCPConnectionReport.Add("---------------"                                              )

        if($Process.MainWindowTitle     ) {$TCPConnectionReport.Add("Main Windowitle       : " + $Process.MainWindowTitle     )}
        if($BasePriority                ) {$TCPConnectionReport.Add("Base Priority         : " + $BasePriority                )}
        if($ThreadCount                 ) {$TCPConnectionReport.Add("Thread Count          : " + $ThreadCount                 )}
        if($Process.Company             ) {$TCPConnectionReport.Add("Company               : " + $Process.Company             )}
        if($Process.CPU                 ) {$TCPConnectionReport.Add("CPU                   : " + $Process.CPU                 )}
        if($Process.Description         ) {$TCPConnectionReport.Add("Description           : " + $Process.Description         )}
        if($Process.FileVersion         ) {$TCPConnectionReport.Add("FileVersion           : " + $Process.FileVersion         )}
        if($Process.HandleCount         ) {$TCPConnectionReport.Add("Handle Count          : " + $Process.HandleCount         )}
        if($Process.Id                  ) {$TCPConnectionReport.Add("Id                    : " + $Process.Id                  )}
        if($Process.Name                ) {$TCPConnectionReport.Add("Name                  : " + $Process.Name                )}
        if($Process.Path                ) {$TCPConnectionReport.Add("Path                  : " + $Process.Path                )}
        if($Process.PriorityBoostEnabled) {$TCPConnectionReport.Add("Priority Boost Enabled: " + $Process.PriorityBoostEnabled)}
        if($Process.PriorityClass       ) {$TCPConnectionReport.Add("Priority Class        : " + $Process.PriorityClass       )}
        if($Process.ProcessName         ) {$TCPConnectionReport.Add("Process Name          : " + $Process.ProcessName         )}
        if($Process.ProcessorAffinity   ) {$TCPConnectionReport.Add("Processor Affinity    : " + $Process.ProcessorAffinity   )}
        if($Process.Product             ) {$TCPConnectionReport.Add("Product               : " + $Process.Product             )}
        if($Process.ProductVersion      ) {$TCPConnectionReport.Add("Product Version       : " + $Process.ProductVersion      )}
        if($Process.Responding          ) {$TCPConnectionReport.Add("Responding            : " + $Process.Responding          )}
        if($Process.SessionId           ) {$TCPConnectionReport.Add("Session Id            : " + $Process.SessionId           )}
        if($Process.StartTime           ) {$TCPConnectionReport.Add("Start Time            : " + $Process.StartTime           )}

        if($NetUDPEndpoint.Count -gt 0)
        {
            $LocalUdpAddresses = $NetUDPEndpoint.LocalAddress | Sort -Unique
            $LocalUdpPorts     = $NetUDPEndpoint.LocalPort    | Sort -Unique
            $UdpCreationTimes  = $NetUDPEndpoint.CreationTime | Sort -Unique
                               
            $LocalUdpAddresses = $LocalUdpAddresses -Join "; "
            $LocalUdpPorts     = $LocalUdpPorts     -Join "; "
            $UdpCreationTimes  = $UdpCreationTimes  -Join "; "

            $TCPConnectionReport.Add("---------------"                              )
            $TCPConnectionReport.Add("UDP End Points: "       + $NetUDPEndpoint.Count)
            $TCPConnectionReport.Add("---------------"                              )
            $TCPConnectionReport.Add("Creation Times :" + $UdpCreationTimes  )
            $TCPConnectionReport.Add("Local Addresses:" + $LocalUdpAddresses )
            $TCPConnectionReport.Add("Local Ports    :" + $LocalUdpPorts     )
        }

        if($MainModule)
        {
                $TCPConnectionReport.Add("---------------")
                $TCPConnectionReport.Add("Process Module" )
                $TCPConnectionReport.Add("---------------")

                if($MainModule.Company       ) {$TCPConnectionReport.Add("Company        : " + $MainModule.Company       )}
                if($MainModule.FileVersion   ) {$TCPConnectionReport.Add("File Version   : " + $MainModule.FileVersion   )}
                if($MainModule.ProductVersion) {$TCPConnectionReport.Add("Product Version: " + $MainModule.ProductVersion)}
                if($MainModule.Description   ) {$TCPConnectionReport.Add("Description    : " + $MainModule.Description   )}
                if($MainModule.Product       ) {$TCPConnectionReport.Add("Product        : " + $MainModule.Product       )}
                if($MainModule.ModuleName    ) {$TCPConnectionReport.Add("ModuleName     : " + $MainModule.ModuleName    )}

                if($FileVersionInfo.Language ) {$TCPConnectionReport.Add("Language       : " + $FileVersionInfo.Language )}
        }
        else
        {
            foreach($Module in $ProcessModules)
            {
                $FileVersionInfo = $Module.FileVersionInfo

                $TCPConnectionReport.Add("-----------------"                             )
                $TCPConnectionReport.Add("Module Info"                                   )
                $TCPConnectionReport.Add("-----------------"                             )
                $TCPConnectionReport.Add("Company        : " + $Module.Company           )
                $TCPConnectionReport.Add("File Version   : " + $Module.FileVersion       )
                $TCPConnectionReport.Add("Product Version: " + $Module.ProductVersion    )
                $TCPConnectionReport.Add("Description    : " + $Module.Description       )
                $TCPConnectionReport.Add("Product        : " + $Module.Product           )
                $TCPConnectionReport.Add("ModuleName     : " + $Module.ModuleName        )
                $TCPConnectionReport.Add("FileName       : " + $Module.FileName          )
                $TCPConnectionReport.Add("Language       : " + $FileVersionInfo.Language )
            }
        }

        if($RemoteAddresses.Contains($Connection.RemoteAddress))
        {
            $RemoteConnectionInfo = Get-RemoteConnectionInfo($Connection                 )
            $TCPConnectionReport.Add("-----------------"                                 )
            $TCPConnectionReport.Add("Remote Connection"                                 )
            $TCPConnectionReport.Add("-----------------"                                 )
            $TCPConnectionReport.Add("Country Code: " + $RemoteConnectionInfo.CountryCode)
            $TCPConnectionReport.Add("Country Name: " + $RemoteConnectionInfo.CountryName)
            $TCPConnectionReport.Add("Host Name   : " + $RemoteConnectionInfo.Hostname   )
            $TCPConnectionReport.Add("IP Address  : " + $RemoteConnectionInfo.IpAddress  )
            $TCPConnectionReport.Add("ISP         : " + $RemoteConnectionInfo.ISP        )
        }

        $TCPConnectionReport.Add("=================================================")
    }

    Return $TCPConnectionReport
}
#..............................................................................

#..............................................................................
Function Get-RemotePorts
{
    $RemotePorts = $TcpConnections | Select-Object RemotePort

    $Ports = @()

    foreach($Port in $RemotePorts)
    {
        $Ports += $Port.RemotePort 
    }

    Return $Ports | Sort-Object -Unique
}
#..............................................................................

#..............................................................................
Function Get-LocalPorts
{
    $LocalPorts = $TcpConnections | Select-Object LocalPort

    $Ports = @()

    foreach($Port in $LocalPorts)
    {
        $Ports += $Port.LocalPort 
    }

    Return $Ports | Sort-Object -Unique
}
#..............................................................................

#..............................................................................

$Computer = $env:COMPUTERNAME

$TcpConnections      = Get-NetTCPConnection
$LocalNetwork        = Get-LocalNetwork
$LocalHost           = Get-LocalHostIpAddress
$LocalAddresses      = Get-LocalAddresses
$RemoteAddresses     = Get-RemoteAddresses
$LocalPorts          = Get-LocalPorts 
$RemotePorts         = Get-RemotePorts
$TCPConnectionReport = Get-TcpConnectionReport

$ProcessGroups = Get-ProcessGroups

CLS

$ReportSummary = Write-ReportSummary

$ReportSummary

CLS

$FinalReport = $ReportSummary + $TCPConnectionReport

$FinalReport | Out-File "System-TCP-Connections.txt"
