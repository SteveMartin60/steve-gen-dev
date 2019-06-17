CLS

$ComputerName = "FinanceServer"

#..............................................................................

#..............................................................................
Function PingComputer($ComputerName)
{
    Write-Host "Pinging: $ComputerName"
            
    Test-Connection $ComputerName -Count 1 | Select Address, Ipv4Address

    if(Test-Connection $ComputerName -Count 1 | Select Address, Ipv4Address)
    {
        Write-Host "Ping Response OK" -ForegroundColor Green
    }
    Else
    {
        Write-Host "Ping failed - host not found" -ForegroundColor red
    }
}
#..............................................................................

#..............................................................................

PingComputer $ComputerName
