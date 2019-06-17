CLS

$WMIObjects = Get-WMIObject -List| Where{$_.name -match "^Win32_"} | Sort Name | Format-Table Name

$WMIObjects | Out-File "wmi-objects.txt"

$TextFile = Get-Content "wmi-objects.txt"

foreach ($Line in $TextFile)
{
    # $WMIObjectName = $WMIObject.name

    if ($Line -match "Win32")
    {
        "WMIObjectName: " + $Line

        $WMIObject = Get-WmiObject -Class $Line | Get-Member
 
        $WMIObject

#        $WMIClassesObject = Get-WmiObject $Line | Get-Member
    }
    

    # $WMIClassesObject = Get-WmiObject $WMIObjectName | Get-Member
}
