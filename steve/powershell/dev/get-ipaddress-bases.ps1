CLS

$IPAddresses = @{}

$IPAddresses = Get-NetIPAddress -AddressFamily IPv4 -AddressState Preferred | Sort-Object InterfaceIndex | Select-Object IPAddress , InterfaceAlias, PrefixOrigin, SuffixOrigin, AddressState

#..............................................................................

#..............................................................................

#(Get-NetIPConfiguration).IPv4Address

foreach($IPAddress in $IPAddresses)
{
    $AddressState = $IPAddress.AddressState
    $PrefixOrigin = $IPAddress.PrefixOrigin
    $SuffixOrigin = $IPAddress.SuffixOrigin

    if(
          (($PrefixOrigin -eq "DHCP") -or ($PrefixOrigin -eq "Manual")) `
           -and 
          (($SuffixOrigin -eq "DHCP") -or ($SuffixOrigin -eq "Manual")) `
           -and 
           $AddressState -eq "Preferred"
       )
    {
        $IPAddress | Format-List
    }
}


