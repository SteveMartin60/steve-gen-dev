Function Control-Tasks
{
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory=$true)][String]$FolderPath,
		[Parameter(Mandatory=$true, ParameterSetname='EnableTask')][Switch]$Enable,
		[Parameter(Mandatory=$true, ParameterSetname='DisableTask')][Switch]$Disable,
		[Parameter()]$TaskScheduler,
		[Parameter()][Switch]$Recursive
	)

	If ($TaskScheduler -eq $null)
    {
		$TaskScheduler = New-Object -ComObject Schedule.Service
		$TaskScheduler.Connect("localhost")
	}

	$curFolder = $TaskScheduler.GetFolder($FolderPath)

	$curFolder.GetTasks(1) | ForEach-Object
    {
		If ($Enable)
        {
			$_.Enabled = $True
			Write-Host "Enable $($_.Path)"
		}

		If ($Disable) 
        {
			$_.Enabled = $False
			Write-Host "Disable $($_.Path)"
		}
	}

	If ($Recursive)
    {
		$curFolder.GetFolders(1)  | ForEach-Object 
        {
			If ($Enable) 
            {
				Control-Tasks -FolderPath $_.Path -Enable -TaskScheduler $TaskScheduler -Recursive
			}
			
            If ($Disable)
            {
				Control-Tasks -FolderPath $_.Path -Disable -TaskScheduler $TaskScheduler -Recursive
			}
		}
	}

}

# Disable Customer Experience Improvement Program tasks0

Control-Tasks -FolderPath "\Microsoft\Windows\Customer Experience Improvement Program" -Disable -Recursive


