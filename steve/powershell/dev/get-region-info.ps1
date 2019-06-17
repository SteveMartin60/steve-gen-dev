CLS

$OS = Get-CimInstance -ClassName Win32_OperatingSystem

$Culture = [System.Globalization.CultureInfo]::GetCultures("SpecificCultures") | Where {$_.LCID -eq $OS.OSLanguage}
$RegionInfo = New-Object System.Globalization.RegionInfo $Culture.Name

$Currency      = $RegionInfo.CurrencyEnglishName
$CurrencySymbol = $RegionInfo.CurrencySymbol
$RegionInfo.DisplayName
""
$RegionInfo.GeoId
$RegionInfo.IsMetric
$RegionInfo.ISOCurrencySymbol
$RegionInfo.Name
$RegionInfo.NativeName
$RegionInfo.ThreeLetterISORegionName
$RegionInfo.TwoLetterISORegionName





$OS | Select-Object CountryCode, OSLanguage, 
    @{N = 'OSDefaultLanguage'; E = {New-Object System.Globalization.CultureInfo([Int]$_.OSLanguage)}},
    @{N = 'OSCountryCode'; E = {$RegionInfo.TwoLetterISORegionName}},
    @{N = 'OSCountryName'; E = {$RegionInfo.DisplayName}}