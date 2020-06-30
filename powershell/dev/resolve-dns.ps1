CLS

$DNSObjects = Resolve-DnsName "10.0.4.10"

foreach($Object in $DNSObjects)
{
    $DNSType = $Object.GetType()

    Write-Host "Count         : " $Object.Count
    Write-Host "Query Type    : " $Object.QueryType
    Write-Host "Server        : " $Object.Server
    Write-Host "Name Host     : " $Object.NameHost
    Write-Host "Name          : " $Object.Name
    Write-Host "Type          : " $Object.Type
    Write-Host "Character Set : " $Object.CharacterSet
    Write-Host "Section       : " $Object.Section
    Write-Host "Data Length   : " $Object.DataLength
    Write-Host "TTL           : " $Object.TTL

    $DNSType | Format-List -Property *
}



