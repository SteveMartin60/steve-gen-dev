CLS

#..............................................................................

#..............................................................................
Function Get-FolderName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $OpenFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog

    $Topmost = New-Object System.Windows.Forms.Form
    $Topmost.TopMost = $True
    $Topmost.MinimizeBox = $True

    $OpenFolderDialog.SelectedPath = $initialDirectory

    $OpenFolderDialog.ShowDialog($Topmost) | Out-Null

    return $OpenFolderDialog.SelectedPath
}
#..............................................................................

#..............................................................................

$SelectedPath = Get-FolderName("D:\Documentaries")

$SelectedPath