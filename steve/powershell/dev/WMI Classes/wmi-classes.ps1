CLS 

function Get-Temperature
{
    $t = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"

    $returntemp = @()

    foreach ($temp in $t.CurrentTemperature)
    {
        $currentTempKelvin = $temp / 10
        $currentTempCelsius = $currentTempKelvin - 273.15

        $currentTempFahrenheit = (9/5) * $currentTempCelsius + 32

        $returntemp += $currentTempCelsius.ToString() + " C : " + $currentTempFahrenheit.ToString() + " F : " + $currentTempKelvin + "K"  
    }

    return $returntemp
}

Get-Temperature

Get-WmiObject -List

# Get-WmiObject -Class Win32_BaseBoard

# Get-WMIObject -List| Where{$_.name -match "^Win32_"} | Sort Name | Format-Table Name

# Get-WmiObject -Class Win32_Bios

# http://www.computerperformance.co.uk/powershell/powershell_wmi_classes.htm