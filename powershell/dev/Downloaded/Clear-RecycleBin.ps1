function Clear-RecycleBin
{

    (New-Object -ComObject Shell.Application).NameSpace(0x0a).Items() | ForEach-Object `
    {
        Remove-Item -LiteralPath $_.Path -Force -Recurse
    }
}

Clear-RecycleBin