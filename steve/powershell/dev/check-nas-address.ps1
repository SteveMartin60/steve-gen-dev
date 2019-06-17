Clear-Host

#..............................................................................

#..............................................................................
Function Get-NASAddress
{
    $Titan   = '192.168.1.169'
    $HomeNAS = '192.168.1.10'
    
    if(Test-Connection $Titan -Count 1 -ErrorAction SilentlyContinue -Quiet)
    {
        $NASAddress = $Titan
    }
    elseif(Test-Connection $HomeNAS -Count 1 -ErrorAction SilentlyContinue -Quiet)
    {
        $NASAddress = $HomeNAS
    }
    
    Return $NASAddress    
}
#..............................................................................

#..............................................................................

$Reports = "\IT Management\Reports\Systems"
$Source  = "\IT Management\Powershell\Powershell Scripts\Reporting"

$NASAddress = Get-NASAddress

$ReportPath = "\\" + (Get-NASAddress) + $Reports

# Test-Path 
$ReportPath

$NASAddress

