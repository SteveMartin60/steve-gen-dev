# Filename: WinPE50-UEFI.ps1 - www.alexcomputerbubble.com
# Date:     November, 2015
# Author:   Alex Dujakovic 
# Description: PowerShell script to create UEFI boot WinPE
# -------------------------------------------------------------------------------
[CmdletBinding()]
param (
[string] $WinArch
)
# Paths to WinPE folders
$myFoldersPath = (Get-Location).Path
$WinPE_BuildFolder = "$myFoldersPath\WinPE50"
$WinPE_MountFolder = "$myFoldersPath\Mount"
$WinPE_Drivers = "$myFoldersPath\Drivers"
$WinPE_AppsFiles = "$myFoldersPath\Apps"
$WinPE_Media = "$myFoldersPath\Media"
$winPE_Images = "$myFoldersPath\Images"
$amd64 = "$WinPE_BuildFolder" + "_amd64"
$x86 = "$WinPE_BuildFolder" + "_x86"

Function do_ReadMessage($msg){
Add-Type -AssemblyName System.Speech
$synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$synthesizer.GetInstalledVoices() | ForEach-Object { $_.VoiceInfo }
$synthesizer.Speak("$msg")
}

Function Make-WinPEBootWim($WinPE_Architecture){

# Paths to WinPE folders and tools 
$ADK_Path = "C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit"
$WinPE_ADK_Path = $ADK_Path + "\Windows Preinstallation Environment"
$WinPE_OCs_Path = $WinPE_ADK_Path + "\$WinPE_Architecture\WinPE_OCs"
$DISM_Path = $ADK_Path + "\Deployment Tools" + "\$WinPE_Architecture\DISM"
$WinPE_BuildFolder = $WinPE_BuildFolder + "_" + $WinPE_Architecture

# Functions
Function Delete-Folder($folderPath){
    try {
        if (Test-Path -path $folderPath) {Remove-Item -Path $folderPath -Force -Recurse -ErrorAction Stop}
    }
    catch{
        Write-Warning "$folderPath - Error deleting folder!"
        Write-Warning "Error: $($_.Exception.Message)"
        Break
    }
}

Function Make-Directory($folderPath){
	if (!(Test-Path -path $folderPath)) {New-Item $folderPath -Type Directory}
}

Function WinPE-Mount($buildFolder, $mountFolder){
    & $DISM_Path\Imagex.exe /mountrw $buildFolder\winpe.wim 1 $mountFolder
}

Function WinPE-UnMount($mountFolder){
    & $DISM_Path\Imagex.exe /unmount /commit $mountFolder
}

Delete-Folder -folderPath $WinPE_BuildFolder
Delete-Folder -folderPath $WinPE_MountFolder

Make-Directory -folderPath $WinPE_BuildFolder
Make-Directory -folderPath $WinPE_MountFolder

Copy-Item "$WinPE_ADK_Path\$WinPE_Architecture\en-us\winpe.wim" $WinPE_BuildFolder

# Mount folder
WinPE-Mount -buildFolder $WinPE_BuildFolder -mountFolder $WinPE_MountFolder

# Add WinPE 5.0 optional components using ADK 8.1 version of dism.exe
& $DISM_Path\dism.exe /Image:$WinPE_MountFolder /Add-Package /PackagePath:$WinPE_OCs_Path\WinPE-Scripting.cab
& $DISM_Path\dism.exe /Image:$WinPE_MountFolder /Add-Package /PackagePath:$WinPE_OCs_Path\en-us\WinPE-Scripting_en-us.cab
& $DISM_Path\dism.exe /Image:$WinPE_MountFolder /Add-Package /PackagePath:$WinPE_OCs_Path\WinPE-WMI.cab
& $DISM_Path\dism.exe /Image:$WinPE_MountFolder /Add-Package /PackagePath:$WinPE_OCs_Path\en-us\WinPE-WMI_en-us.cab
& $DISM_Path\dism.exe /Image:$WinPE_MountFolder /Add-Package /PackagePath:$WinPE_OCs_Path\WinPE-MDAC.cab
& $DISM_Path\dism.exe /Image:$WinPE_MountFolder /Add-Package /PackagePath:$WinPE_OCs_Path\en-us\WinPE-MDAC_en-us.cab
& $DISM_Path\dism.exe /Image:$WinPE_MountFolder /Add-Package /PackagePath:$WinPE_OCs_Path\WinPE-NetFx.cab
& $DISM_Path\dism.exe /Image:$WinPE_MountFolder /Add-Package /PackagePath:$WinPE_OCs_Path\en-us\WinPE-NetFx_en-us.cab
& $DISM_Path\dism.exe /Image:$WinPE_MountFolder /Add-Package /PackagePath:$WinPE_OCs_Path\WinPE-PowerShell.cab
& $DISM_Path\dism.exe /Image:$WinPE_MountFolder /Add-Package /PackagePath:$WinPE_OCs_Path\en-us\WinPE-PowerShell_en-us.cab
& $DISM_Path\dism.exe /Image:$WinPE_MountFolder /Add-Package /PackagePath:$WinPE_OCs_Path\WinPE-DismCmdlets.cab
& $DISM_Path\dism.exe /Image:$WinPE_MountFolder /Add-Package /PackagePath:$WinPE_OCs_Path\en-us\WinPE-DismCmdlets_en-us.cab

# Install WinPE 5.0 Drivers
& $DISM_Path\dism.exe /Image:$WinPE_MountFolder /Add-Driver /Driver:"$WinPE_Drivers\$WinPE_Architecture" /Recurse

# Copy WinPE ExtraFiles
Copy-Item "$WinPE_AppsFiles\$WinPE_Architecture\*" "$WinPE_MountFolder\Windows\System32\" -Recurse

# Unmount folder
WinPE-UnMount -mountFolder $WinPE_MountFolder

Make-Directory -folderPath "$WinPE_BuildFolder\bootiso\media\sources"

Copy-Item "$WinPE_ADK_Path\$WinPE_Architecture\Media" "$WinPE_BuildFolder\bootiso" -recurse -Force
Copy-Item "$WinPE_BuildFolder\winpe.wim" "$WinPE_BuildFolder\bootiso\media\sources\boot.wim" -Force

}

# Make folder for boot.wim files
Function Make-Directory($folderPath){
	if (!(Test-Path -path $folderPath)) {New-Item $folderPath -Type Directory}
}

Function CreateBootFiles($WinPeMode){
switch($WinPeMode){
'x86'{
        do_ReadMessage -msg "Creating Media Files - Please Wait" | Out-Null
        Write-Host "Please do not close this application ..." -ForegroundColor Red
        # To create bootable WinPE x86
        Make-WinPEBootWim -WinPE_Architecture "x86"
        Write-Host "Finish creating 32 Bit bootable image, please wait" -ForegroundColor Green
        do_ReadMessage -msg "Finish creating 32 Bit bootable image, please wait"

        if (Test-Path -path $WinPE_Media) {Remove-Item -Path $WinPE_Media -Recurse -Force}
        Make-Directory -folderPath $WinPE_Media
        Copy-Item "$x86\bootiso\media\*" -Destination $WinPE_Media -recurse -Force

    }
'amd64'{
        do_ReadMessage -msg "Creating Media Files - Please Wait" | Out-Null
        Write-Host "Please do not close this application ..." -ForegroundColor Red
        # To create bootable WinPE x64
        Make-WinPEBootWim -WinPE_Architecture "amd64"
        Write-Host "Finish creating 64 Bit bootable image, please wait" -ForegroundColor Green
        do_ReadMessage -msg "Finish creating 64 Bit bootable image, please wait"

        if (Test-Path -path $WinPE_Media) {Remove-Item -Path $WinPE_Media -Recurse -Force}
        Make-Directory -folderPath $WinPE_Media
        Copy-Item "$amd64\bootiso\media\*" -Destination $WinPE_Media -recurse -Force
    }
 }

# Delete all language files except en-us
$foldersCollection = (Get-ChildItem $WinPE_Media)
foreach($folder In $foldersCollection){
    If($folder.Name.Contains("-") -and $folder.Name -ne ("en-us")){
        Remove-Item -Path $folder.FullName -Force -Recurse -Confirm:$false
        "Deleting: $($folder.FullName)"
    }
}

Write-Host "Finish creating all neccessary folders" -ForegroundColor Green
Write-Host "Finish making boot Media Files... (Done)!" -ForegroundColor Green
do_ReadMessage -msg "Media File Created - Please go to the second step" | Out-Null
Start-Sleep -Seconds 3
}
CreateBootFiles -WinPeMode $WinArch