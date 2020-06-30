CLS

#..............................................................................

#..............................................................................
Function Get-WebPage
{
    [cmdletbinding(DefaultParameterSetName = 'url', ConfirmImpact = 'low')]
    Param
    (
        [Parameter(Position  = 0, Mandatory = $True , ParameterSetName = '', ValueFromPipeline = $True)] [string][ValidatePattern("^(http|https)\://*")]$Url,
        [Parameter(Position  = 1, Mandatory = $False, ParameterSetName = 'defaultcred'                )] [switch]$UseDefaultCredentials,            
        [Parameter(               Mandatory = $False, ParameterSetName = ''                           )] [string]$Proxy,
        [Parameter(               Mandatory = $False, ParameterSetName = 'altcred'                    )] [switch]$Credential,            
        [Parameter(               Mandatory = $False, ParameterSetName = ''                           )] [switch]$ShowSize                        
    )

    Begin
    {     
        $psBoundParameters.GetEnumerator() | % {Write-Verbose "Parameter: $_" }
    
        $WebClient = New-Object Net.WebClient 
     
        If ($PSBoundParameters.ContainsKey('Proxy'                )) {$WebClient.Proxy                 = New-Object -TypeName Net.WebProxy($proxy,$True)}
        If ($PSBoundParameters.ContainsKey('UseDefaultCredentials')) {$WebClient.UseDefaultCredentials = $True                                          }
        If ($PSBoundParameters.ContainsKey('Credentials'          )) {$WebClient.Credential            = (Get-Credential).GetNetworkCredential()        }
    }

    Process
    {    
        Try
        {
            If ($ShowSize)
            {
                "{0:N0}" -f ($wr.DownloadString($url) | Out-String).length -as [INT]
            }
            Else
            {
                $WebClient.DownloadString($url)       
            }
        }
        Catch
        {
            Write-Warning "$($Error[0])"
        }
    }
}
#..............................................................................

#..............................................................................
Function Get-WebSite
{
    [cmdletbinding(DefaultParameterSetName = 'url', ConfirmImpact = 'low')]
    
    Param(
            [Parameter(Position = 0, Mandatory = $True , ParameterSetName = '', ValueFromPipeline = $True)] [string][ValidatePattern("^(http|https)\://*")]$Url,
            [Parameter(Position = 1, Mandatory = $False, ParameterSetName = 'defaultcred'                )] [switch]$UseDefaultCredentials,            
            [Parameter(              Mandatory = $False, ParameterSetName = ''                           )] [Int]$Timeout,            
            [Parameter(              Mandatory = $False, ParameterSetName = 'altcred'                    )] [switch]$Credential            
         )

    Begin
    {
        $psBoundParameters.GetEnumerator() | % {Write-Verbose "Parameter: $_" }
    
        $WebRequest = [System.Net.WebRequest]::Create($url)
     
        If ($PSBoundParameters.ContainsKey('TimeOut'              )) {Write-Verbose "Setting the timeout on web request" $WebRequest.Timeout               = $Timeout                               }        
        If ($PSBoundParameters.ContainsKey('UseDefaultCredentials')) {Write-Verbose "Using Default Credentials"          $WebRequest.UseDefaultCredentials = $True                                  }
        If ($PSBoundParameters.ContainsKey('Credentials'          )) {Write-Verbose "Prompt for alternate credentials"   $WebClient.Credential             = (Get-Credential).GetNetworkCredential()}
         
        $then = get-date
    }
    
    Process
    {    
        Try
        {
            $Response = $WebRequest.GetResponse()

            $now = get-date 
         
            Write-Verbose "Generating report from website connection and response"  
            $report = @{
                URL = $url
                StatusCode = $Response.Statuscode -as [int]
                StatusDescription = $Response.StatusDescription
                ResponseTime = "$(($now - $then).totalseconds)"
                WebServer = $Response.Server
                Size = $Response.contentlength
                } 
        }
        Catch
        {
            $now = get-date

            $errorstring = "$($error[0])"
         
            #Generate report
            $report =
            @{
                URL               = $url
                StatusCode        = ([regex]::Match($errorstring,"\b\d{3}\b")).value
                StatusDescription = (($errorstring.split('\)')[2]).split('.\')[0]).Trim()
                ResponseTime      = "$(($now - $then).totalseconds)"
                WebServer         = $Response.Server
                Size              = $Response.contentlength
            }   
        }
    }
    End
    {        
        New-Object PSObject -Property $report 
    }    
}  
#..............................................................................

#..............................................................................

$Address = "http://192.168.1.189:8080/"

$WebPage = Get-WebPage $Address

$WebSite = Get-WebSite $Address

$WebPage

# $WebSite

<#

$WebClient = New-Object Net.WebClient

$WebClient.BaseAddress = $Address


$WebRequest = [System.Net.WebRequest]::Create($Address)
# $WebRequest | Get-Member

$WebRequest.Timeout = 1000

$Response = $WebRequest.GetResponse()

$Headers = $Response.Headers

foreach($Header in $Headers)
{
    #$Header
}

#>