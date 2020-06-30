CLS

$Debug             = $false
$SourcePath        = $null
$ReportPath        = $null
$DefaultSearchPath = "U:\"
$TitanReportPath   = "\\192.168.1.169\IT Management\Reports\Systems"
$TitanSourcePath   = "\\192.168.1.169\IT Management\Powershell\Powershell Scripts\Reporting"

#..............................................................................

#..............................................................................
Function Get-DropboxPath
{
    $DropboxPath = "$env:LOCALAPPDATA\Dropbox"
    $FileName    = "info.json"
}
#..............................................................................

#..............................................................................
Function Get-FolderPath
{
   Param(
             [parameter(Mandatory=$True, Position=0)][string]$InitialDirectory,
             [parameter(Mandatory=$True, Position=1)][string]$Caption
        )

   [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $OpenFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog

    $Topmost = New-Object System.Windows.Forms.Form

    $Topmost.TopMost     = $True
    $Topmost.MinimizeBox = $True

    $OpenFolderDialog.Description = $Caption

    $OpenFolderDialog.SelectedPath = $InitialDirectory

    $OpenFolderDialog.ShowDialog($Topmost) | Out-Null

    return $OpenFolderDialog.SelectedPath
}
#..............................................................................

#..............................................................................

$ReportPath      = Get-FolderPath $DefaultSearchPath "Select Report Path..."
$SourcePath      = Get-FolderPath $DefaultSearchPath "Select Source Path..."

if($SourcePath -eq $DefaultSearchPath)
{
    $SourcePath = $TitanSourcePath
}

if($ReportPath -eq $DefaultSearchPath)
{
    $ReportPath = $TitanReportPath
}

"Source Path: $SourcePath"
"Report Path: $ReportPath"

$ComputerName    = $env:COMPUTERNAME
$CurrentDateTime = $((Get-Date).ToString('yyyy-MM-dd HH.mm.ss'))
$CurrentLocation = Get-Location

$IPString = Get-NetIPAddress -AddressFamily IPv4 -AddressState Preferred -PrefixOrigin Dhcp | Select-Object IPAddress

$IPString = "$ReportPath\$ComputerName\$CurrentDateTime\$IPString"

$IndexStart = $IPString.LastIndexOf('=')
$IndexEnd   = $IPString.LastIndexOf('}')

$IPString = $IPString.Substring(($IndexStart)+1, ($IndexEnd-$IndexStart)-1)

$OutputPath = "$ReportPath\$ComputerName - $IPString\$CurrentDateTime\"

if (!$Debug)
{
    Write-Host "Running reports..."

    New-Item -ItemType Directory -Path $OutputPath

    Set-Location $OutputPath

    PowerShell.exe -ExecutionPolicy Bypass -File "\\192.168.1.169\IT Management\Powershell\Powershell Scripts\Reporting\system-usb-devices.ps1"

    PowerShell.exe -ExecutionPolicy Bypass -File "\\192.168.1.169\IT Management\Powershell\Powershell Scripts\Reporting\system-other.ps1"

    PowerShell.exe -ExecutionPolicy Bypass -File "\\192.168.1.169\IT Management\Powershell\Powershell Scripts\Reporting\system-os.ps1"

    Set-Location $CurrentLocation
}
