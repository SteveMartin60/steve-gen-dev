CLS

Function Get-InstalledSoftware
{
	Param
	(
		[Alias('Computer','ComputerName','HostName')]
		[Parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$true,Position=1)]
		[string[]]$Name = $env:COMPUTERNAME
	)
	Begin
	{
		$LMkeys = "Software\Microsoft\Windows\CurrentVersion\Uninstall","SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
		$LMtype = [Microsoft.Win32.RegistryHive]::LocalMachine
		$CUkeys = "Software\Microsoft\Windows\CurrentVersion\Uninstall"
		$CUtype = [Microsoft.Win32.RegistryHive]::CurrentUser
		
	}
	Process
	{
		ForEach($Computer in $Name)
		{
			$MasterKeys = @()

			$CURegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($CUtype,$computer)
			$LMRegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($LMtype,$computer)
			ForEach($Key in $LMkeys)
			{
				$RegKey = $LMRegKey.OpenSubkey($key)
				If($RegKey -ne $null)
				{
					ForEach($subName in $RegKey.getsubkeynames())
					{
						foreach($sub in $RegKey.opensubkey($subName))
						{
							$MasterKeys += (New-Object PSObject -Property `
                            @{
							    "Name"              = $sub.getvalue("displayname"    )
							    "Version"           = $sub.getvalue("DisplayVersion" )
							    "Uninstall Command" = $sub.getvalue("UninstallString")
                                "Install Date"      = $sub.getvalue("InstallDate"    )
							})
						}
					}
				}
			}
			
            ForEach($Key in $CUKeys)
			{
				$RegKey = $CURegKey.OpenSubkey($Key)
				If($RegKey -ne $null)
				{
					ForEach($subName in $RegKey.getsubkeynames())
					{
						foreach($sub in $RegKey.opensubkey($subName))
						{
							$MasterKeys += (New-Object PSObject -Property `
                            @{
							    "Name"              = $sub.getvalue("displayname"    )
							    "Version"           = $sub.getvalue("DisplayVersion" )
							    "Uninstall Command" = $sub.getvalue("UninstallString")
                                "Install Date"      = $sub.getvalue("InstallDate"    )
     			             })
						}
					}
				}
			}
			
            $MasterKeys = ($MasterKeys | Where {$_.Name -ne $Null -AND $_.SystemComponent -ne "1" -AND $_.ParentKeyName -eq $Null} | select Name, Version, "Install Date" | sort Name)

			$MasterKeys
		}
	}
}

Get-InstalledSoftware
