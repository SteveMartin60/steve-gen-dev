


Configuration Printer
{
    node LocalHost
    {
        xPrinter A
        {
             Ensure =  "present"
             PortIP = "192.168.2.1"
             PrinterPort =  "Publicx"
             PrinterName = "XX"
             DirverName = "Canon iR2002/2202 UFRII LT"

        }
    }
}



Configuration Printer
{
    node LocalHost
    {
        xPrinter A
        {
             Ensure =  "Absent"
             PortIP = "192.168.2.1"
             PrinterPort =  "Public"
             PrinterName = "XXx"
             DirverName = "Canon iR2002/2202 UFRII LT"

        }
    }
}



Get-ChildItem C:\1 -Recurse | Remove-Item -Force 

Printer -OutputPath C:\1 
Start-DscConfiguration -Path c:\1 -Wait -Verbose -Force

Get-Process wmi* |Stop-Process -Force
Get-Printer xx |Remove-Printer
Get-PrinterPort Public |Remove-PrinterPort
