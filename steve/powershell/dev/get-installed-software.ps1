CLS

function Get-InstalledAppsFromRegistry
{ 
    $scriptBlock=
    { 
        #this function gets all properties from registry 
        #It doesn't fail if a property value is corrupted 
         
        function read-AppPropertiesToObj
        { 
            param($Application, $Architecture) 
 
            $prop = 
            @{ 
                APP_Architecture = $Architecture 
                APP_GUID         = $Application.PSChildName 
             } 
 
            #for PS 2.0 compatibility 
            $itemslist = @($Application | select -ExpandProperty Property) 
 
            foreach ($item in $itemslist) 
            { 
                #if value is corrupted, get-itemproperty function fails 
                try 
                { 
                    $prop.$item = $Application | Get-ItemProperty -name $item | select -ExpandProperty $item 
                } 
                catch 
                { 
                    $prop.$item = '(invalid value)' 
                } 
            } 
 
            $result = New-Object psobject -Property $prop 
 
            return $result 
        }#function 
 
        $apps    = @() 
        $results = @() 
 
        if (Test-Path 'HKLM:\SOFTWARE\Wow6432Node\microsoft\Windows\CurrentVersion\Uninstall')
        { 
            #"64 bit system, 32 bit node" 
            $apps = Get-ChildItem 'HKLM:\SOFTWARE\Wow6432Node\microsoft\Windows\CurrentVersion\Uninstall' 
         
            foreach ($app in $apps) 
            { 
                $results += read-AppPropertiesToObj -Application $app -Architecture 32 
            } 

            #64 bit system, 64 bit node 
            $apps = Get-ChildItem 'HKLM:\SOFTWARE\microsoft\Windows\CurrentVersion\Uninstall' 
 
            foreach ($app in $apps) 
            { 
                $results += read-AppPropertiesToObj -Application $app -Architecture 64 
            } 
        } 
        else 
        { 
            #32 bit system, 32 bit node 
            $apps = Get-ChildItem 'HKLM:\SOFTWARE\microsoft\Windows\CurrentVersion\Uninstall' 
 
            foreach ($app in $apps) 
            { 
                $results += read-AppPropertiesToObj -Application $app -Architecture 32 
            } 
        }#if else 
 
        return $results | sort DisplayName 
    }#scriptblock 
     
    #determine OS architecture and path to the native powershell.exe 
 
    #-----32 bit process running on a 64 bit machine 
    if (([intptr]::size -eq 4) -and (test-path env:\PROCESSOR_ARCHITEW6432)) 
    { 
        $PsExePath = "C:\windows\sysnative\WindowsPowerShell\v1.0\powershell.exe" 
    } 
    #-----64 bit process running on a 64 bit machine 
    elseif (([intptr]::size -eq 8) -and !(test-path env:\PROCESSOR_ARCHITEW6432)) 
    { 
        $PsExePath = "C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe" 
    } 
    #-----32 bit process running on a 32 bit machine 
    else 
    { 
        $PsExePath = "C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe" 
    } 
 
    #execute command 
    $tmp = & $PsExePath $scriptBlock 
 
    #return results

    Set-Clipboard -Value $tmp

    return $tmp
}

Write-Host "Getting Installed Software..."

$InstalledSoftware = Get-InstalledAppsFromRegistry

($InstalledSoftware).DisplayName