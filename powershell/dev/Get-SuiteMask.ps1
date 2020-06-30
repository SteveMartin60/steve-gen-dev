function Get-SuiteMask
{
    param([int]$SuiteMask)

    $SuiteTable = @{

        0x00 = "Windows Server, Small Business Edition"
        0x01 = "Windows Server, Enterprise Edition"
        0x02 = "Windows Server, Backoffice Edition"
        0x03 = "Windows Server, Communications Edition"
        0x04 = "Microsoft Terminal Services"
        0x05 = "Windows Server, Small Business Edition Restricted"
        0x06 = "Windows Embedded"
        0x07 = "Windows Server, Datacenter Edition"
        0x08 = "Single User"
        0x09 = "Windows Home Edition"
        0x10 = "Windows Server, Web Edition"
    }

    foreach($Mask in $SuiteTable.Keys | Sort-Object)
    {
        if (($SuiteMask -band $Mask) -eq $Mask)
        {
            $SuiteTable[$Mask]
        }
    }
}

Get-SuiteMask -SuiteMask 272