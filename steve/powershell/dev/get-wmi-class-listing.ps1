CLS


if (-not $WMIObjects)
{
    Write-Host "Getting all WMI Classes..."

    $WMIObjects = Get-WMIObject -List| Where{$_.name -match "^Win32_"} | Sort Name | Format-Table Name
}
else
{
    Write-Host "Listing all WMI Classes..."
    
    # $WMIObjects
}

Write-Host "WMI Classes Count: " $WMIObjects.length

$WMIFilter = 'Hard'

foreach($Line in $WMIObjects)
{
    if ($Line -match "32")
    {
        $Line
    }
}
