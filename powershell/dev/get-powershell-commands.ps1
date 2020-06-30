CLS

#Get-Command | where { $_.parameters.keys -contains "ComputerName" -and $_.parameters.keys -notcontains "Session"}

#Get-PSSession -ComputerName "home-work"

$PowershellCmdlets = Get-Command | Where-Object CommandType -eq "Cmdlet"

foreach($Cmdlet in $PowershellCmdlets)
{
    $Keys = $Cmdlet.parameters.keys

    foreach($Key in $Keys)
    {
        $Type = $Key.GetType()

        Write-Host $Cmdlet.Name ":" $Key ":" $Type.Name
    }
}