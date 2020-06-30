CLS

#..............................................................................

#..............................................................................
Function Monitored-Restart
{ 
    param ($Server = $(throw "A server name is required.")) 
 
    $Events = @() 
    
    $Events += "Started restart attempt on $Server at $((Get-Date).tolongtimestring())`n"  
    
    Write-Host  "Started restart attempt on $Server at $((Get-Date).tolongtimestring())`n"  
 
    $PingFailTimeout   = 180 
    $PingResumeTimeout = 180 
    $ServiceCheckDelay = 180 
 
    Function Test-Port
    { 
        Param([string]$Srv, $Port = 135 , $Timeout = 1000, [switch]$Verbose) 
        
        $ErrorActionPreference = "SilentlyContinue" 
        
        $TcpClient = New-Object System.Net.Sockets.TcpClient 
        
        $iar = $TcpClient.BeginConnect($Srv,$Port,$null,$null) 
        
        $Wait = $iar.AsyncWaitHandle.WaitOne($Timeout,$false) 
        
        if(!$Wait) 
        { 
            $TcpClient.Close() 
        
            if($Verbose)
            {
                Write-Host "Connection Timeout"
            }
        
            Return $false 
        } 
        else 
        { 
            $Error.Clear() 

            $TcpClient.EndConnect($iar) | Out-Null 

            if($Error[0])
            {
                if($Verbose)
                {
                    Write-Host $Error[0]
                }
            
                $Failed = $true
            }
             
            $TcpClient.Close() 
        }    

        if($Failed)
        {
            return $false
        }
        else
        {
            return $true
        }
    }
 
    try
    {
        Restart-Computer $Server -Force -ErrorAction Stop
    }
    catch
    { 
        $Events += "Restart command was not accepted by $Server`n" 
    
        Write-Host "Restart command was not accepted by $Server`n"  
    
        $RestartFailed = $true 
    } 
 
    if (-not ($RestartFailed))
    {
        $Events += "Restart request was accepted by the server at $((Get-Date).tolongtimestring())`n"  
        Write-Host "Restart request was accepted by the server at $((Get-Date).tolongtimestring())`n"  
        Write-Host "Waiting on RPC ping fail.`n" 
 
        $Timer = [System.Diagnostics.Stopwatch]::StartNew() 
 
        $Timer.reset() 
        $Timer.start() 
 
        while ($Timer.elapsed.totalseconds -lt $PingFailTimeout)
        { 
            if(-not (Test-Port -server $Server))
            { 
                $Events += "RPC Ping fail detected at $((Get-Date).tolongtimestring())`n"  

                Write-Host "RPC Ping fail detected at $((Get-Date).tolongtimestring())`n" 

                $RpcPingFail = $true 

                break 
            } 
        } 
 
        Write-Host "Waiting on ICMP Ping file.`n" 
        while ($Timer.elapsed.totalseconds -lt $PingFailTimeout)
        { 
            if (-not (Test-Connection $Server -Quiet))
            {
                $Events += "ICMP Ping fail detected at $((Get-Date).tolongtimestring())`n"  

                Write-Host "ICMP Ping fail detected at $((Get-Date).tolongtimestring())`n" 

                $PingFail = $true 

                break 
            } 
        } 
 
        if (-not($PingFail))
        { 
            $Events += "ICMP Ping fail not detected in $PingFailTimeout seconds.  Server appears to be hung.`n" 

            Write-Host "ICMP Ping fail not detected in $PingFailTimeout seconds.  Server appears to be hung.`n"  

            exit 
        } 
 
        Write-Host "Waiting on ping resume."`n 

        $Timer.reset() 
        $Timer.start() 

        While ($Timer.elapsed.totalseconds -lt $PingResumeTimeout)
        {
            if (Test-Connection $Server -Quiet)
            { 
                $Events +=  "Ping resumed at $((Get-Date).tolongtimestring())`n"  

                Write-Host  "Ping resumed at $((Get-Date).tolongtimestring())`n" 

                $PingResume = $true 

                break 
            } 
        } 
 
        while ($Timer.elapsed.totalseconds -lt $PingResumeTimeout)
        {
            if(Test-Port -server $Server)
            {
                $Events += "RPC Ping Resumed at $((Get-Date).tolongtimestring())`n"  

                Write-Host "RPC Ping Resumed at $((Get-Date).tolongtimestring())`n" 

                $RpcPingResume = $true 

                break 
            } 
        } 
 
        if (-not($PingResume))
        {
            $Events += "Ping Resume not Detected in $PingResumeTimeout seconds.  Server appears to be hung.`n" 

            Write-Host "Ping Resume not Detected in $PingResumeTimeout seconds.  Server appears to be hung.`n" 
        } 
 
        if ($PingResume -and -not $RpcPingResume)
        { 
            $Events += "RPC Ping Resume not detected in $PingResumeTimeout seconds.  Server appears to be hung.`n" 

            Write-Host "RPC Ping Resume not detected in $PingResumeTimeout seconds.  Server appears to be hung.`n" 

            exit 
        } 
     
        $Events +=  "Waiting $ServiceCheckDelay seconds for service startup`n" 

        Write-Host  "Waiting $ServiceCheckDelay seconds for service startup`n" 
 
        sleep -Seconds $ServiceCheckDelay 
 
        $Events += Get-WmiObject Win32_Service -ComputerName $Server |? {$_.StartMode -eq "auto"} | Format-Table state, name, status -AutoSize | Out-String 
    } 
 
    $Events 
}
#..............................................................................

#..............................................................................
