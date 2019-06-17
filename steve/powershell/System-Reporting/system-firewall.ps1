CLS

#..............................................................................

#..............................................................................
Function Write-AllowedServices
{
    $FirewallInfo.Add(""                                                            )
    $FirewallInfo.Add("=================================="                          )
    $FirewallInfo.Add("Allowed Services"                                            )
    $FirewallInfo.Add("----------------------------------"                          )

    foreach($Service in $FirewallServices)
    {
        $FirewallInfo.Add($Service)
    }
}
#..............................................................................

#..............................................................................
Function Write-AllowedApplications
{
    $FirewallInfo.Add(""                                                            )
    $FirewallInfo.Add("=================================="                          )
    $FirewallInfo.Add("Allowed Applications"                                        )
    $FirewallInfo.Add("----------------------------------"                          )

    foreach($Application in $FirewallApplications)
    {
        $FirewallInfo.Add("Name            : " +  $Application.Name                 )
        $FirewallInfo.Add("----------------------------------"                      )
        $FirewallInfo.Add("File Name       : " +  $Application.ProcessImageFileName )
        $FirewallInfo.Add("Property        : " +  $Application.Property             )
        $FirewallInfo.Add("Remote Addresses: " +  $Application.RemoteAddresses      )
        $FirewallInfo.Add("Enabled         : " +  $Application.Enabled              )
        $FirewallInfo.Add("=================================="                      )
    }
}
#..............................................................................

#..............................................................................
Function Write-FirewallProfiles
{
    $FirewallInfo.Add(""                                  )
    $FirewallInfo.Add("==================================")
    $FirewallInfo.Add("Firewall Profiles"                 )
    $FirewallInfo.Add("----------------------------------")
    $FirewallInfo.Add("")

    foreach($Profile in $FirewallProfiles)
    {
        $FirewallInfo.Add("----------------------------"                                                )
        $FirewallInfo.Add("Profile Details: " + $Profile.Name                                           )
        $FirewallInfo.Add("----------------------------"                                                )
        $FirewallInfo.Add("Enabled                        : " + $Profile.Enabled                        )
        $FirewallInfo.Add("DefaultInboundAction           : " + $Profile.DefaultInboundAction           )
        $FirewallInfo.Add("DefaultOutboundAction          : " + $Profile.DefaultOutboundAction          )
        $FirewallInfo.Add("AllowInboundRules              : " + $Profile.AllowInboundRules              )
        $FirewallInfo.Add("AllowLocalFirewallRules        : " + $Profile.AllowLocalFirewallRules        )
        $FirewallInfo.Add("AllowLocalIPsecRules           : " + $Profile.AllowLocalIPsecRules           )
        $FirewallInfo.Add("AllowUserApps                  : " + $Profile.AllowUserApps                  )
        $FirewallInfo.Add("AllowUserPorts                 : " + $Profile.AllowUserPorts                 )
        $FirewallInfo.Add("AllowUnicastResponseToMulticast: " + $Profile.AllowUnicastResponseToMulticast)
        $FirewallInfo.Add("NotifyOnListen                 : " + $Profile.NotifyOnListen                 )
        $FirewallInfo.Add("EnableStealthModeForIPsec      : " + $Profile.EnableStealthModeForIPsec      )
        $FirewallInfo.Add("LogFileName                    : " + $Profile.LogFileName                    )
        $FirewallInfo.Add("LogMaxSizeKilobytes            : " + $Profile.LogMaxSizeKilobytes            )
        $FirewallInfo.Add("LogAllowed                     : " + $Profile.LogAllowed                     )
        $FirewallInfo.Add("LogBlocked                     : " + $Profile.LogBlocked                     )
        $FirewallInfo.Add("LogIgnored                     : " + $Profile.LogIgnored                     )
        $FirewallInfo.Add("DisabledInterfaceAliases       : " + $Profile.DisabledInterfaceAliases       )
        $FirewallInfo.Add("----------------------------"                                                )
        $FirewallInfo.Add(""                                                                            )
    }
}
#..............................................................................

#..............................................................................
Function Write-FirewallSettings
{
    $FirewallInfo.Add(""                                                            )
    $FirewallInfo.Add("=================================="                          )
    $FirewallInfo.Add("Firewall Settings"                                           )
    $FirewallInfo.Add("----------------------------------"                          )
    $FirewallInfo.Add($FirewallSettings                                             )
}
#..............................................................................

#..............................................................................
Function Write-ReportSummary
{
    $ReportDate = Get-Date -UFormat "%Y-%m-%d"
    $ReportTime = Get-Date -UFormat "%H:%M:%S"

    $FirewallInfo.Add("========================================"                    )
    $FirewallInfo.Add("System Firewall Report"                                      )
    $FirewallInfo.Add("========================================"                    )
    $FirewallInfo.Add(""                                                            )
    $FirewallInfo.Add("============================"                                )
    $FirewallInfo.Add("Report Summary"                                              )
    $FirewallInfo.Add("----------------------------"                                )
    $FirewallInfo.Add("Computer Name: " + $Env:COMPUTERNAME                         )
    $FirewallInfo.Add("Report Date  : " + $ReportDate                               )
    $FirewallInfo.Add("Report Time  : " + $ReportTime                               )
    $FirewallInfo.Add(""                                                            )
    $FirewallInfo.Add("Allowed Applications  : "  + $FirewallApplications.     Count)
    $FirewallInfo.Add("Allowed Services      : "  + $FirewallServices.         Count)
    $FirewallInfo.Add("Firewall Profile Count: "  + $FirewallProfiles.         Count)
    $FirewallInfo.Add("Globally Open Ports   : "  + $FirewallGloballyOpenPorts.Count)
    $FirewallInfo.Add("============================"                                )
}
#..............................................................................

#..............................................................................
Function Get-FirewallManager
{
    Return New-Object -ComObject HNetCfg.FwMgr
}
#..............................................................................

#..............................................................................
Function Get-FirewallPolicy
{
    Return $FirewallManager.LocalPolicy.CurrentProfile
}
#..............................................................................

#..............................................................................
Function Get-FWServices
{ 
    $FWServices = @()

    $Services = $FirewallPolicy.Services

    foreach($Service in $Services)
    {
        $OpenPorts = $Service.GloballyOpenPorts

        $ThisService     = New-Object Object
        $ThisServiceTemp = @{}
        $ThisService     = {$ThisServiceTemp}.Invoke()

        $ThisService += @{Name            = $Service.Name           }
        $ThisService += @{Customized      = $Service.Customized     }
        $ThisService += @{IpVersion       = $Service.IpVersion      }
        $ThisService += @{Scope           = $Service.Scope          }
        $ThisService += @{RemoteAddresses = $Service.RemoteAddresses} 
        $ThisService += @{Enabled         = $Service.Enabled        }
        $ThisService += @{OpenPortCount   = $OpenPorts.Count        }

        $Count = 0

        foreach ($Port in $OpenPorts) 
        { 
            $Count++
            
            $PortID = "Port" + $Count + ": "

            $PortName     = $PortID + "Name"
            $PortProtocol = $PortID + "Protocol"
            $PortOpenPort = $PortID + "Port"
            $PortBuiltIn  = $PortID + "Builtin"

            $ThisService += @{$PortName       = $Port.Name    }
            $ThisService += @{$PortProtocol   = $Port.Protocol}
            $ThisService += @{$PortOpenPort   = $Port.Port    }
            $ThisService += @{$PortBuiltIn    = $Port.Builtin }
        } 

        $ThisService = $ThisService | Format-Table

        $FWServices += , $ThisService 
    }

    Return $FwServices
} 
#..............................................................................

#..............................................................................
Function Get-FWApplications 
{ 
    $Applications = @() 
 
    ForEach($item in $FirewallPolicy.AuthorizedApplications) 
    { 
        $ThisApplication = New-Object -TypeName PSObject -Property `
        @{ 
            Property             = "Application" 
            Name                 = $item.Name 
            ProcessImageFileName = $item.ProcessImageFileName 
            IpVersion            = $item.IpVersion 
            Scope                = $item.Scope 
            RemoteAddresses      = $item.RemoteAddresses 
            Enabled              = $item.Enabled 
        }
            
        $Applications += $ThisApplication 
    } 
     
    Return $Applications 
} 
#..............................................................................

#..............................................................................
Function Get-FWGloballyOpenPorts 
{ 
    $OpenPorts = @() 
 
    ForEach($Port in $FirewallPolicy.GloballyOpenPorts) 
    { 
        $ThisPort = New-Object -TypeName PSObject -Property `
        @{ 
            Name            = $Port.Name 
            IpVersion       = $Port.IpVersion
            Protocol        = $Port.Protocol 
            Port            = $Port.Port 
            Scope           = $Port.Scope 
            RemoteAddresses = $Port.RemoteAddresses 
            Enabled         = $Port.Enabled 
            BuiltIn         = $Port.BuiltIn 
        }
            
        $OpenPorts += $ThisPort 
    } 
    Return $OpenPorts 
} 
#..............................................................................

#..............................................................................
Function New-FWPortOpening 
{ 
    [CmdletBinding()] 
    Param 
    ( 
        [string]$RuleName, 
        [int   ]$RuleProtocol, 
        [double]$RulePort, 
        [string]$RuleRemoteAddresses, 
        [bool  ]$RuleEnabled 
    ) 
    Begin 
    { 
        $FwMgr = New-Object -ComObject HNetCfg.FwMgr 
        $FwProfile = $FwMgr.LocalPolicy.CurrentProfile 
    } 
    Process 
    { 
        $FwPort                 = New-Object -ComObject HNetCfg.FwOpenPort 
        $FwPort.Name            = $RuleName 
        $FwPort.Protocol        = $RuleProtocol 
        $FwPort.Port            = $RulePort 
        $FwPort.RemoteAddresses = $RuleRemoteAddresses 
        $FwPort.Enabled         = $RuleEnabled 
    } 
    
    End 
    { 
        $FwProfile.GloballyOpenPorts.Add($FwPort) 
    } 
}
#..............................................................................

#..............................................................................

$FirewallManager = Get-FirewallManager
$FirewallPolicy  = Get-FirewallPolicy

$FirewallApplications      = Get-FWApplications 
$FirewallServices          = Get-FWServices
$FirewallSettings          = Get-NetFirewallSetting
$FirewallGloballyOpenPorts = Get-FWGloballyOpenPorts 
$FirewallProfiles          = Get-NetFirewallProfile

$FirewallInfo     = New-Object Object
$FirewallInfoTemp = @{}
$FirewallInfo     = {$FirewallInfoTemp}.Invoke()

Write-ReportSummary

Write-FirewallSettings

Write-FirewallProfiles

Write-AllowedApplications

Write-AllowedServices

$FirewallInfo | Out-File "System-Firewall.txt"
