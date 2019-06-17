CLS

$(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object `
{
    $RegPath = "$($_)Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    if (-not (Test-Path -Path $RegPath))
    {
        $null = New-Item -Path $RegPath -ItemType RegistryKey
    }
    if (-not (Get-ItemProperty -Path $RegPath -Name HideFileExt -ErrorAction SilentlyContinue))
    {
        $null = New-ItemProperty -Path $RegPath -Name HideFileExt -PropertyType DWord -Value 0
    }
    else
    {
        Set-ItemProperty -Path $RegPath -Name HideFileExt -Value 0
    }
}

Get-ShowFileExtension