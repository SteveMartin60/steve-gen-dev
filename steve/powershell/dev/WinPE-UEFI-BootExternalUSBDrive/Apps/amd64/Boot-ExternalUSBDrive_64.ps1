# =================================================================
# www.AlexComputerBubble - UEFI Boot External USB Drive
# =================================================================
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

# =================================================================
# Functions
# =================================================================

$volumes = (Get-WmiObject -Query "SELECT * from Win32_LogicalDisk" | Select -Property Properties )
foreach($i In $volumes){
    switch ("$($i.Properties.Item("VolumeName").Value)")
    {
    "IMAGEDATA" {
        #$partition = $i.Properties.Item("VolumeName").Value
        $drive = $i.Properties.Item("Caption").Value
        }
    }
}
[string]$letter = ($Script:drive -replace ":", "")
New-PSDrive -Name [string]$letter -PSProvider FileSystem -Root $drive
$Script:stringUSB = $letter + ":\Images"
$strWimFilePath = "$Script:stringUSB\64-BIT"

# Checking the number of disk drives being detected
New-Item -Path $env:TEMP -Name ListDisk.txt -ItemType File -Force | Out-Null
Add-Content -Path $env:TEMP\ListDisk.txt "List disk"
$listDisk = (DiskPart /s $env:TEMP\ListDisk.txt)
$diskID = $listDisk[-1].Substring(7,2).Trim()
$totalDisk = $diskID
If($totalDisk -lt 1){
    $mainImage = "X:\Windows\System32\ICOs\Warning.png"
}
Else{
    $mainImage = "X:\Windows\System32\ICOs\ID-100106284.jpg"
}

Function do_GetWindowsPartition{
$partitionWinCollection = (Get-WmiObject -Class Win32_LogicalDisk |
Select-Object -Property DeviceID, VolumeName, DriveType, Caption |
Where -FilterScript {$_.DriveType -eq 3 -and $_.Caption -ne "X:"})

If($partitionWinCollection){
    $winPartitionFound = $false
    foreach($partition in $partitionWinCollection){
            If([System.IO.Directory]::Exists("$("$($partition.DeviceID)\Windows\System32")") -and (Test-Path -Path "$("$($partition.DeviceID)\Windows\System32")")){
            $Script:driveWinPartition = $partition.DeviceID
            $labelPartitionToCapture.Text = "Creating an image of Drive $($partition.DeviceID) Partition"
            $winPartitionFound = $true
            Break
            }
            
    } # end of foreach
    If($winPartitionFound -eq $false) {
                [System.Windows.Forms.MessageBox]::Show("Windows partition not found!")
    }
 }
}

Function do_ListPartitions{
$array = New-Object System.Collections.ArrayList

Function do_ComputeSize {
    	Param (
    		[double]$Size
    	)
    	If ($Size -gt 1000000000)
    	{	$ReturnPartitionSize = "{0:N2} GB" -f ($Size / 1GB)
    	}
    	Else
    	{	$ReturnPartitionSize = "{0:N2} MB" -f ($Size / 1MB)
    	}
    	Return $ReturnPartitionSize
    }

$Script:partitionInfo = @(
$partitionCollection = (Get-WmiObject -Class Win32_LogicalDisk |
Select-Object -Property DeviceID, VolumeName, Size, Description )
#$partitions = ($partitionCollection | Select DeviceID).DeviceID
$partitions = ($partitionCollection | Select DeviceID, VolumeName, Size, Description)
ForEach ($partitionLetter in $partitions) {
        $deviceSize = (do_ComputeSize $partitionLetter.Size)
        [pscustomobject]@{DriveLetter=$partitionLetter.DeviceID;VolumeName=$partitionLetter.VolumeName;Size=$deviceSize;Description=$partitionLetter.Description}
}
)

 $array.AddRange($partitionInfo)
 $partitionDriveGrid.DataSource = $array
 $objform.refresh()  
}

function do_GetFolderTree {

function Add-Node { 
        param ( 
            $selectedNode, 
            $name, 
            $tag 
        ) 
        $newNode = new-object System.Windows.Forms.TreeNode  
        $newNode.Name = $name 
        $newNode.Text = $name 
        $newNode.Tag = $tag 
        $selectedNode.Nodes.Add($newNode) | Out-Null 
        return $newNode 
} 

    if ($script:folderItem)  
    {  
        $treeview1.Nodes.remove($script:folderItem) 
        $objform.refresh()  
    } 
    $script:folderItem = New-Object System.Windows.Forms.TreeNode 
    $script:folderItem.text = "Images Folder" 
    $script:folderItem.Name = "Images Folder" 
    $script:folderItem.Tag = "root" 
    $treeView1.Nodes.Add($script:folderItem) | Out-Null     
     
    # Generate Module nodes 
    # $folders = @("$Script:stringUSB\32-BIT", "$Script:stringUSB\64-BIT")
    $folders = @("$Script:stringUSB\64-BIT") 
    $folders | % { 
        $parentNode = Add-Node $script:folderItem $_ "Folder" 
        $folderContent = Get-ChildItem $_ 
        $folderContent | % { 
            $childNode = Add-Node $parentNode $_.Name "File" 
        } 
    } 
    $script:folderItem.Expand() 
} 

Function do_FindChecked($node) {

  foreach ($n in $node.nodes) {
    if ($n.checked) { 
        #[System.Windows.Forms.MessageBox]::Show($n.FullPath.Replace("Images Folder\", ""))
        do_RemoveImageFiles $n.FullPath.Replace("Images Folder\", "") 
    }
    do_FindChecked($n)
  }
}

Function do_UncheckChecked($node) {
  foreach ($n in $node.nodes) {
    if ($n.checked) { $n.Checked = $false }
    do_UncheckChecked($n)
  }
}

Function do_RemoveImageFiles($fileName){
        # Delete image files 
        If(Test-Path -Path $fileName) {
            Remove-Item -Path $fileName -Force -Confirm:$false
            #[System.Windows.Forms.MessageBox]::Show($fileName)
        }
        Else{
            [System.Windows.Forms.MessageBox]::Show("File not removed, please make sure the file exists")
        }
}

Function do_DeleteImageFiles {
    $confirmDelImgFile = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete checked image file(s)?" , "Confirm Action!" , 4)
    If ($confirmDelImgFile -eq "YES") {
        do_FindChecked($treeView1)
    }
    else{
        [System.Windows.Forms.MessageBox]::Show("You have canceled this action.")
        do_UncheckChecked($treeView1.Nodes)
    }
}

Function do_ListWimFiles{

$Script:filesCollection = (Get-ChildItem -Path $strWimFilePath -Recurse -Force | 
? -FilterScript{$_.Extension -match ".wim"} | 
Select-Object -Property Name, FullName)
$comboBoxApply.Items.Clear()
    $comboBoxApply.BeginUpdate() 
    foreach($file in $filesCollection){
        $comboBoxApply.Items.add($file.Name) | Out-Null
    }
    $comboBoxApply.EndUpdate() 
 $objForm.Refresh()
}

Function do_RefreshSomeControls{
$ErrorActionPreference = 'SilentlyContinue'
$comboBoxApply.SelectedItem=$null
$deleteButtonSelectImgFile.Visible = $False
$stopButtonImgProcess.Visible = $False
$stopButtonApplyImgProcess.Visible = $False
$textBoxImageName.Clear()
$richBoxCapture.Clear()
$richBoxApply.Clear() 
$objForm.Refresh()
}

Function do_ReadDescription{

$wimFileCollection = $strWimFilePath

$richBoxApply.Clear() 
    $fileName = ($comboBoxApply.SelectedItem.ToString() -replace ".wim", "")
    $fileNewName = $fileName + "_Comment.txt"
    $wimFileDescription = (Get-ChildItem -Path $wimFileCollection -Recurse -Force | 
    ? -FilterScript{$_.Extension -match ".txt" -and $_.Name -eq "$fileNewName" })
        
    # [System.Windows.Forms.MessageBox]::Show("$($wimFileDescription)")
    If("$($wimFileDescription)") {
        $message = (Get-Content -Path "$wimFileCollection\$wimFileDescription")
        $richBoxApply.AppendText($message)
        Clear-Variable message
    }
    
    $deleteButtonSelectImgFile.Visible = $True
    $objForm.Refresh()      
}

Function do_CaptureImage($winDrive,$imageFilePath,$imageDesc){
    Push-Location X:\Windows\system32\GImageX\
    Start-Process imagex.exe -ArgumentLIst "/capture $winDrive $imageFilePath ""$imageDesc"" "
    [int]$Script:processImageID = (Get-Process | Where -FilterScript {$_.ProcessName -eq "imagex"} |Select -Property $_.Id).Id
}

Function do_CheckInputAndCaptureWim{

If($strWimFilePath -eq $null){
    [System.Windows.Forms.MessageBox]::Show("Please note: Folder for .wim file not found!")
    return
}
If($textBoxImageName.Text -eq $null -or $textBoxImageName.Text.Length -eq 0){
    [System.Windows.Forms.MessageBox]::Show("Please type a name for Wim File!")
    $textBoxImageName.Focus()
    return
}
If($textBoxImageName.Text.Contains(".wim") -or $textBoxImageName.Text.Contains(".Wim") ){
    $Script:wimFileName = $textBoxImageName.Text
}
else{
    $Script:wimFileName = $textBoxImageName.Text + ".wim"
 }
 
$fileTempName = ($Script:wimFileName -replace ".wim", "")
$wimName = $fileTempName + "_Comment.txt"

$confirmCapture = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to capture drive: $($Script:driveWinPartition) and create: $strWimFilePath\" + $Script:wimFileName + " image?" , "Confirm Action!" , 4)
    if ($confirmCapture -eq "YES") {
        New-Item -path $strWimFilePath -name $wimName -itemtype "file" -value $richBoxCapture.Text -Force
        do_StartLabels("CAPTURE") 
        do_CaptureImage -winDrive "$($Script:driveWinPartition)" -imageFilePath "$($strWimFilePath)\$Script:wimFileName" -imageDesc $Script:wimFileName
    }
    else{
        [System.Windows.Forms.MessageBox]::Show("You have canceled this action.")
    }
}

Function do_RemoveFiles{
        # Delete any files created by imaging proces being stopped
        $strFileToDelete = $strWimFilePath + "\$Script:wimFileName"
        If(Test-Path -Path $strFileToDelete) {
            Remove-Item -Path $strFileToDelete -Force -Confirm:$false
        }
        $fileCommentTempName = ("$Script:wimFileName" -replace ".wim", "")
        $imageComment = $fileCommentTempName + "_Comment.txt"
        $strFileCommentToDelete = $strWimFilePath + "\$imageComment"
        If(Test-Path -Path $strFileCommentToDelete) {
            Remove-Item -Path $strFileCommentToDelete -Force -Confirm:$false
        }
}

Function do_StopImaging($processId){
$objFindProcess = (Get-WmiObject -Query "SELECT * from Win32_Process WHERE ProcessID = '$processId'")
 If ($objFindProcess){
    $confirmStopCaptureImage = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to stop capture image process?" , "Confirm Action!" , 4)
    If ($confirmStopCaptureImage -eq "YES") {
        Stop-Process -id $processId -Force
        Start-Sleep -Seconds 1
        do_RemoveFiles    
        do_StartLabels("END-CAPTURE")
        do_RefreshSomeControls  
    }
    else{
        [System.Windows.Forms.MessageBox]::Show("You have canceled this action.")
    }
 }
 Else{
    do_StartLabels("END-CAPTURE")
    do_RefreshSomeControls
 }
}

Function do_PartitionDrive {
If ($radioButtonOne.Checked){

# -------------| Get DiskPartFile created |--------------------
$Script:commandPartDrive = @"
select disk 0
clean
create partition primary size="$($systemTextbox.Text)"
format quick fs=ntfs label="System"
assign letter="S"
active
create partition primary
format quick fs=ntfs label="Windows"
assign letter="W"
list volume
exit
"@
}
ElseIf($radioButtonTwo.Checked){
$Script:commandPartDrive = @"
select disk 0
clean
create partition primary size="$($recoveryTextbox.Text)"
format quick fs=ntfs label="Recovery"
assign letter="R"
set id=27
create partition primary size="$($systemTextbox.Text)"
format quick fs=ntfs label="System"
assign letter="S"
active
create partition primary
format quick fs=ntfs label="Windows"
assign letter="W"
list volume
exit
"@
}
ElseIf($radioButtonThree.Checked){
# Note for EFI partiton: for Advanced Format Generation 4Kn drives, change to size=260.
$Script:commandPartDrive = @"
select disk 0
clean
convert gpt
create partition primary size="$($gptWinRETextbox.Text)"
format quick fs=ntfs label="Windows RE tools"
assign letter="T"
create partition efi size="$($systemGPTTextbox.Text)"
rem == Note: for Advanced Format Generation One drives, change to size=260.
format quick fs=fat32 label="System"
assign letter="S"
create partition msr size="$($gptMSRTextbox.Text)"
create partition primary
format quick fs=ntfs label="Windows"
assign letter="W"
list volume
exit
"@
}
ElseIf($radioButtonFour.Checked){
$Script:commandPartDrive = @"
select disk 0
clean
convert gpt
create partition primary size=300
format quick fs=ntfs label="Windows RE tools"
assign letter="T"
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
gpt attributes=0x8000000000000001
create partition efi size="$($systemGPTTextbox.Text)"
format quick fs=fat32 label="System"
assign letter="S"
create partition msr size="$($gptMSRTextbox.Text)"
create partition primary
shrink minimum="$($gptRecoveryTextbox.Text)"
format quick fs=ntfs label="Windows"
assign letter="W"
create partition primary
format quick fs=ntfs label="Recovery image"
assign letter="R"
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
gpt attributes=0x8000000000000001
list volume
exit
"@
}
Else {
    [System.Windows.Forms.MessageBox]::Show("Please select Select BIOS/UEFI Partitions option!")
    return
}

$commandPartDrive | Out-File X:\Windows\system32\PartitionDrive.txt -Force

}

Function do_ApplyWim{

    do_PartitionDrive | Out-Null
    Start-Sleep -Seconds 2

If($comboBoxApply.SelectedItem -eq $null){
 [System.Windows.Forms.MessageBox]::Show("Please select an Image to be applied!")
    Return
}

$confirmApply = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to apply: $($comboBoxApply.SelectedItem)" + " image?" , "Confirm Action!" , 4)
If ($confirmApply -eq "YES") {  
      
        do_StartLabels("APPLY")
        do_ApplySelectedImage -winImage "$strWimFilePath\$($comboBoxApply.SelectedItem)" | Out-Null
    }
    else{
        [System.Windows.Forms.MessageBox]::Show("You have canceled this action.")
    }
}

Function do_ApplySelectedImage($winImage){
New-Item -Path $env:TEMP -Name applyImgX.ps1 -ItemType File -Force | Out-Null
Add-Content -Path $env:TEMP\applyImgX.ps1 "Write-Host 'Formatting Hard Drive - Creating Windows Partitions' -ForegroundColor Green"
Add-Content -Path $env:TEMP\applyImgX.ps1 "(Get-Content X:\Windows\system32\PartitionDrive.txt) | DiskPart"
Add-Content -Path $env:TEMP\applyImgX.ps1 "Start-Sleep -Seconds 3"
Add-Content -Path $env:TEMP\applyImgX.ps1 "Write-Host 'Applying selected image file to Windows partition' -ForegroundColor Green"
Add-Content -Path $env:TEMP\applyImgX.ps1 "X:\Windows\system32\GImageX\imagex.exe /apply $winImage 1 W:"
Add-Content -Path $env:TEMP\applyImgX.ps1 "Start-Sleep -Seconds 3"
Add-Content -Path $env:TEMP\applyImgX.ps1 "Write-Host 'Applying bcdboot tool to make bootable partition' -ForegroundColor Green"
Add-Content -Path $env:TEMP\applyImgX.ps1 "bcdboot W:\Windows /s S:"
Add-Content -Path $env:TEMP\applyImgX.ps1 "Write-Host 'Finish applying image ... (Done)!' -ForegroundColor Green"
Add-Content -Path $env:TEMP\applyImgX.ps1 "Start-Sleep -Seconds 3"

Function do_StartPSScript{
$commandStartApplyPSScript = @"
Start-Process PowerShell -ArgumentList " -ExecutionPolicy Bypass -File $($env:TEMP)\applyImgX.ps1"  
"@
Invoke-Expression $commandStartApplyPSScript
 }
 do_StartPSScript
}

Function do_StartLabels($state) {
switch($state)
{
    "REFRESH" {$labelPartitionToCapture.Text = "Creating image of Drive $($Script:driveWinPartition) Partition"}
    "CAPTURE" {$stopButtonImgProcess.Visible = $True}
    "END-CAPTURE"{$stopButtonImgProcess.Visible = $False}
    "APPLY" {$stopButtonApplyImgProcess.Visible = $True}
    "END-APPLY"{$stopButtonApplyImgProcess.Visible = $False}
}
$objForm.Refresh()
}

Function do_StopApplyImage{
[int]$Script:processApplyImageID = (Get-Process | Where -FilterScript {$_.ProcessName -eq "imagex"} |Select -Property $_.Id).Id

 If ($Script:processApplyImageID){
    $confirmStopApplyImage = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to stop the apply image process?" , "Confirm Action!" , 4)
    If ($confirmStopApplyImage -eq "YES") {
        Stop-Process -id $Script:processApplyImageID -Force
        do_StartLabels("END-APPLY")
        do_RefreshSomeControls
    }
    else{
        [System.Windows.Forms.MessageBox]::Show("You have canceled this action.")
    }
 }
Else{
    do_StartLabels("END-APPLY")
    do_RefreshSomeControls
 }
}

Function do_DeleteImageFile{
$confirmDeleteFile = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete file: $($comboBoxApply.SelectedItem)" + " ?" , "Confirm Action!" , 4)
If ($confirmDeleteFile -eq "YES") {
    $strFileToDelete = $strWimFilePath + "\$($comboBoxApply.SelectedItem)"
    If(Test-Path -Path $strFileToDelete) {
        #[System.Windows.Forms.MessageBox]::Show("File: $strFileToDelete deleted")
        Remove-Item -Path $strFileToDelete -Force
    }
    $fileCommentTempName = ("$($comboBoxApply.SelectedItem)" -replace ".wim", "")
    $imageComment = $fileCommentTempName + "_Comment.txt"
    $strFileCommentToDelete = $strWimFilePath + "\$imageComment"
    If(Test-Path -Path $strFileCommentToDelete) {
        #[System.Windows.Forms.MessageBox]::Show("File: $strFileCommentToDelete deleted")
        Remove-Item -Path $strFileCommentToDelete -Force
    }
    do_RunRefreshForm
}
else{
    [System.Windows.Forms.MessageBox]::Show("You have canceled this action.")
 }
}

Function do_ProductKey{
    $command = "X:\Windows\System32\produkey-x64\ProduKey.exe"
    Invoke-Expression $command
}

Function do_InputPicture ($file){
    
    $image = [System.Drawing.Image]::Fromfile($file)
    $inputPicture.Image = $image
    
}

Function do_ViewPartition {
    $radioOption = $this.Text
    Switch($radioOption){

    "Default BIOS/MBR"{
                $MbrSystemLabel.Visible = $True
                $systemTextbox.Visible = $True
                $MbrWindowsLabel.Visible = $True
                $windowsTextbox.Visible = $True
                #--------------------------------
                $MbrRecoveryLabel.Visible = $False
                $recoveryTextbox.Visible = $False
                $gptWinRELabel.Visible = $False
                $gptWinRETextbox.Visible = $False
                $gptSystemLabel.Visible = $False
                $systemGPTTextbox.Visible = $False
                $gptMSRLabel.Visible = $False
                $gptMSRTextbox.Visible = $False
                $gptWindowsLabel.Visible = $False
                $gptWindowsTextbox.Visible = $False
                $gptRecoveryLabel.Visible = $False
                $gptRecoveryTextbox.Visible = $False
                $partitionPic = "X:\Windows\System32\PartitionPics\DefaultBIOS_MBR.jpg"
                do_InputPicture -file $partitionPic}
    "Recommended BIOS/MBR"{
                $MbrSystemLabel.Visible = $True
                $systemTextbox.Visible = $True
                $MbrWindowsLabel.Visible = $True
                $windowsTextbox.Visible = $True
                $MbrRecoveryLabel.Visible = $True
                $recoveryTextbox.Visible = $True
                #-------------------------------
                $gptWinRELabel.Visible = $False
                $gptWinRETextbox.Visible = $False
                $gptSystemLabel.Visible = $False
                $systemGPTTextbox.Visible = $False
                $gptMSRLabel.Visible = $False
                $gptMSRTextbox.Visible = $False
                $gptWindowsLabel.Visible = $False
                $gptWindowsTextbox.Visible = $False
                $gptRecoveryLabel.Visible = $False
                $gptRecoveryTextbox.Visible = $False
                $partitionPic = "X:\Windows\System32\PartitionPics\RecommendedBIOS_MBR.jpg"
                do_InputPicture -file $partitionPic}
    "Default UEFI/GPT"{
                $gptSystemLabel.Visible = $True
                $systemGPTTextbox.Visible = $True
                $gptMSRLabel.Visible = $True
                $gptMSRTextbox.Visible = $True
                $gptWindowsLabel.Visible = $True
                $gptWindowsTextbox.Visible = $True
                #---------------------------------
                $MbrSystemLabel.Visible = $False
                $systemTextbox.Visible = $False
                $MbrWindowsLabel.Visible = $False
                $windowsTextbox.Visible = $False
                $MbrRecoveryLabel.Visible = $False
                $recoveryTextbox.Visible = $False
                $gptWinRELabel.Visible = $False
                $gptWinRETextbox.Visible = $False
                $gptRecoveryLabel.Visible = $False
                $gptRecoveryTextbox.Visible = $False
                $partitionPic = "X:\Windows\System32\PartitionPics\DefaultUEFI_GPT.jpg"
                do_InputPicture -file $partitionPic}
    "Recommended UEFI/GPT"{
                $gptWinRELabel.Visible = $True
                $gptWinRETextbox.Visible = $True
                $gptSystemLabel.Visible = $True
                $systemGPTTextbox.Visible = $True
                $gptMSRLabel.Visible = $True
                $gptMSRTextbox.Visible = $True
                $gptWindowsLabel.Visible = $True
                $gptWindowsTextbox.Visible = $True
                $gptRecoveryLabel.Visible = $True
                $gptRecoveryTextbox.Visible = $True
                #----------------------------------
                $MbrSystemLabel.Visible = $False
                $systemTextbox.Visible = $False
                $MbrWindowsLabel.Visible = $False
                $windowsTextbox.Visible = $False
                $MbrRecoveryLabel.Visible = $False
                $recoveryTextbox.Visible = $False
                $partitionPic = "X:\Windows\System32\PartitionPics\RecomendedUEFI_GPT.jpg"
                do_InputPicture -file $partitionPic}
    } 
}

Function do_RunRefreshForm{
    do_ListPartitions
    do_GetFolderTree
    do_GetWindowsPartition
    do_RefreshSomeControls
    do_ListWimFiles
    do_StartLabels("REFRESH")
    $objform.refresh()
}

Function do_Restart{
 $confirmRestart = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to Restart?" , "Confirm Action!" , 4)
If ($confirmRestart -eq "YES") {
    $command = "X:\Windows\System32\Cmd.exe /c wpeutil Reboot"
    Invoke-Expression $command
}
else{
    [System.Windows.Forms.MessageBox]::Show("You have canceled this action.")
 }
}

Function do_Shutdown{
$confirmShutdown = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to Shutdown?" , "Confirm Action!" , 4)
If ($confirmShutdown -eq "YES") {
    $command = "X:\Windows\System32\Cmd.exe /c wpeutil Shutdown"
    Invoke-Expression $command
}
else{
    [System.Windows.Forms.MessageBox]::Show("You have canceled this action.")
 }
}

# =================================================================
# Create a Form
# =================================================================
$imageOne = [system.drawing.image]::FromFile("$mainImage")
$objForm = New-Object System.Windows.Forms.Form
$objForm.Text = "www.AlexComputerBubble - UEFI Boot External USB Drive"
$objForm.Size = New-Object System.Drawing.Size(1100,530)
$objForm.StartPosition = "CenterScreen"
$objForm.KeyPreview = $True

# Create a ToolTip
$tooltipinfo = New-Object 'System.Windows.Forms.ToolTip'

# Form Tabs
# =================================================================
# Create the tabcontrol
$tabcontrol = New-Object windows.Forms.TabControl
$tabpage_One = New-Object windows.Forms.TabPage
$tabpage_Two = New-Object windows.Forms.TabPage
$tabpage_Three = New-Object windows.Forms.TabPage

$tabcontrol.Font ="Calibri, 10pt style=Bold"
$tabcontrol.Anchor = 'Top, Bottom, Left, Right'
$tabcontrol.ItemSize = '100,25'
$tabcontrol.Padding = '15,5'
$tabcontrol.Location = '20, 20'
$tabcontrol.width = 1050
$tabcontrol.Height = 460

# Tab One
# ================================================================
$tabpage_One.Text = "Computer Info"
$tabpage_One.Location = '20, 15'
$tabpage_One.Padding ='3,3,3,3'
$tabpage_One.Size = '1050, 460'
$tabpage_One.BackColor = "White"
$tabpage_One.BackgroundImageLayout = "None"
$tabpage_One.TabIndex = 0

# RichTextBox for Pc Info
$pcInfoTextBox = New-Object System.Windows.Forms.RichTextBox
$pcInfoTextBox.location = New-Object System.Drawing.Size(20,20) 
$pcInfoTextBox.Size = New-Object System.Drawing.Size(600,130)
$pcInfoTextBox.Font ="Calibri, 7pt"
$pcInfoTextBox.AppendText("Computer Name:" + [char](9) + [char](9) + $env:COMPUTERNAME + [char]13 + [char]10)
$pcInfoTextBox.AppendText("Manufacturer:" + [char](9) + [char](9) + (Get-WmiObject -classname win32_computersystem).manufacturer + [char]13 + [char]10)
$pcInfoTextBox.AppendText("Model Number:" + [char](9) + [char](9) + (Get-WmiObject -classname win32_computersystem).Model + [char]13 + [char]10)
$pcInfoTextBox.AppendText("Serial:" + [char](9) + [char](9) + [char](9) + (Get-WmiObject -classname win32_bios).SerialNumber + [char]13 + [char]10)
$pcInfoTextBox.AppendText("Processor Name:" + [char](9) + [char](9) + (Get-WmiObject -Class Win32_Processor).Name + [char]13 + [char]10)
$pcInfoTextBox.AppendText("NIC:" + [char](9) + [char](9) + [char](9) + (Get-wmiObject -classname win32_networkadapterconfiguration|Where {$_.DHCPEnabled -match "True" -and $_.IpAddress -ne $null}|Select-Object -property Description).Description + [char]13 + [char]10)
$pcInfoTextBox.AppendText("MAC Address:" + [char](9) + [char](9) + (Get-wmiObject -classname win32_networkadapterconfiguration|Where {$_.DHCPEnabled -match "True"}|Select-Object -property MACAddress).MACAddress + [char]13 + [char]10)
$pcInfoTextBox.AppendText("IP Address:" + [char](9) + [char](9) + (Get-wmiObject -classname win32_networkadapterconfiguration|Where {$_.DHCPEnabled -match "True"}|Select-Object -property IpAddress).IpAddress)
$pcInfoTextBox.Visible=$True
$pcInfoTextBox.readonly = $true

# Data Grid
$partitionDriveGrid = New-Object System.Windows.Forms.DataGridView
$partitionDriveGrid.Name = "ViewPartitions"
$partitionDriveGrid.Font ="Calibri, 8pt"
$partitionDriveGrid.Location = New-Object Drawing.Point 20,170
$partitionDriveGrid.Size = New-Object Drawing.Point 600,100
$partitionDriveGrid.AutoSizeColumnsMode = 'AllCells'  # 'Fill'
$partitionDriveGrid.MultiSelect = $false
$partitionDriveGrid.RowHeadersVisible = $false
$partitionDriveGrid.allowusertoordercolumns = $true
$partitionDriveGrid.ColumnHeadersVisible = $true

# Label Folder Images
$labelTreeViewImages = New-Object System.Windows.Forms.Label
$labelTreeViewImages.Location = New-Object System.Drawing.Size(20,280)
$labelTreeViewImages.Size = New-Object System.Drawing.Size(260,20)
$labelTreeViewImages.BackColor = "Transparent"
$labelTreeViewImages.Text = "External USB Images Folder:"

# TreeView Folder Images
$treeView1 = New-Object System.Windows.Forms.TreeView
$treeView1.Location = New-Object System.Drawing.Size(20,305)
$treeView1.Size = New-Object System.Drawing.Size(600,100)
$treeView1.Name = "treeImageFolderView" 
$treeView1.Font = "Calibri, 10pt" 
$treeView1.CheckBoxes = $true

# Button Delete image files
$buttonDelImgFile = New-Object System.Windows.Forms.Button
$buttonDelImgFile.Location = New-Object System.Drawing.Size(480,280)
$buttonDelImgFile.Size = New-Object System.Drawing.Size(120,20)
$buttonDelImgFile.Font = "Calibri, 8pt"
$buttonDelImgFile.Text = “Delete”
$buttonDelImgFile.TextAlign = "middleCenter"
$buttonDelImgFile.TabIndex = 1
$tooltipinfo.SetToolTip($buttonDelImgFile, "Click this button to delete checked image files")
$buttonDelImgFile.Add_Click({do_DeleteImageFiles})

# PictureBox for main page
$picBoxOne = New-Object System.Windows.Forms.PictureBox
$picBoxOne.Width = $imageOne.Size.Width
$picBoxOne.Height = $imageOne.Size.Height
$picBoxOne.Image = $imageOne
$picBoxOne.Location = New-Object Drawing.Point 650,50
$picBoxOne.BackColor = "Transparent"

# Button Shutdown
$shutdownButton = New-Object System.Windows.Forms.Button
$shutdownButton.Image = [system.drawing.image]::FromFile("X:\Windows\System32\ICOs\Shutdown.ico")
$shutdownButton.ImageAlign = "TopCenter"
$shutdownButton.BackColor = "ButtonFace"
$shutdownButton.UseVisualStyleBackColor = $True
$shutdownButton.Location = New-Object System.Drawing.Size(920,335)
$shutdownButton.Size = New-Object System.Drawing.Size(64,60)
$shutdownButton.Font = "Calibri, 5pt"
$shutdownButton.TabIndex = 1
$shutdownButton.Text = “Shutdown”
$shutdownButton.TextAlign = "BottomCenter"
$tooltipinfo.SetToolTip($shutdownButton, "Shutdown Computer")
$shutdownButton.Add_Click({do_Shutdown})

# Button Restart
$restartButton = New-Object System.Windows.Forms.Button
$restartButton.Image = [system.drawing.image]::FromFile("X:\Windows\System32\ICOs\Restart.ico")
$restartButton.ImageAlign = "TopCenter"
$restartButton.BackColor = "ButtonFace"
$restartButton.UseVisualStyleBackColor = $True
$restartButton.Location = New-Object System.Drawing.Size(840,335)
$restartButton.Size = New-Object System.Drawing.Size(64,60)
$restartButton.Font = "Calibri, 5pt"
$restartButton.TabIndex = 1
$restartButton.Text = “Restart”
$restartButton.TextAlign = "BottomCenter"
$tooltipinfo.SetToolTip($restartButton, "Restart Computer")
$restartButton.Add_Click({do_Restart})

# Button Refresh
$refreshButton = New-Object System.Windows.Forms.Button
$refreshButton.Image = [system.drawing.image]::FromFile("X:\Windows\System32\ICOs\Refresh.ico")
$refreshButton.ImageAlign = "TopCenter"
$refreshButton.BackColor = "ButtonFace"
$refreshButton.UseVisualStyleBackColor = $True
$refreshButton.Location = New-Object System.Drawing.Size(760,335)
$refreshButton.Size = New-Object System.Drawing.Size(64,60)
$refreshButton.Font = "Calibri, 5pt"
$refreshButton.TabIndex = 1
$refreshButton.Text = “Refresh”
$refreshButton.TextAlign = "BottomCenter"
$tooltipinfo.SetToolTip($refreshButton, "Refresh")
$refreshButton.Add_Click({do_RunRefreshForm})

# Button Product Key
$productKeyButton = New-Object System.Windows.Forms.Button
$productKeyButton.Image = [system.drawing.image]::FromFile("X:\Windows\System32\ICOs\ProductKey.ico")
$productKeyButton.ImageAlign = "TopCenter"
$productKeyButton.BackColor = "ButtonFace"
$productKeyButton.UseVisualStyleBackColor = $True
$productKeyButton.Location = New-Object System.Drawing.Size(680,335)
$productKeyButton.Size = New-Object System.Drawing.Size(64,60)
$productKeyButton.Font = "Calibri, 5pt"
$productKeyButton.TabIndex = 1
$productKeyButton.Text = “OS Key”
$productKeyButton.TextAlign = "BottomCenter"
$tooltipinfo.SetToolTip($productKeyButton, "Operating system product key information")
$productKeyButton.Add_Click({do_ProductKey})

# Tab Two
# ================================================================
$tabpage_Two.Text = "Create Image"
$tabpage_Two.Location = '20, 15'
$tabpage_Two.Padding ='3,3,3,3'
$tabpage_Two.Size = '1050, 460'
$tabpage_Two.BackColor = "white"
$tabpage_Two.TabIndex = 1

# Capture section
# ---------------------------------------------------------------
# GroupBox for creation of Wim files - Capture
$groupBoxCapture = New-Object System.Windows.Forms.groupBox
$groupBoxCapture.Location = '20, 20'
$groupBoxCapture.Name = "groupCapture"
$groupBoxCapture.Size = '600, 375'
$groupBoxCapture.TabStop = $False
$groupBoxCapture.BackColor = "Transparent"
$groupBoxCapture.Text = "Capture Wim Files"

# Label Image .Wim Type File Name
$labelWriteImageName = New-Object System.Windows.Forms.Label
$labelWriteImageName.Location = New-Object System.Drawing.Point(20, 40)
$labelWriteImageName.Size = New-Object System.Drawing.Size(150, 25)
$labelWriteImageName.Font ="Calibri, 8pt"
$labelWriteImageName.Text = "Type Image Name:"

# Letter Image Name Text Box
$textBoxImageName = New-Object System.Windows.Forms.TextBox
$textBoxImageName.Location = New-Object System.Drawing.Size(170,40)
$textBoxImageName.Size = New-Object System.Drawing.Size(190,25)
$textBoxImageName.Font ="Calibri, 10pt"
$textBoxImageName.TabIndex = 0

# RichBox for description of captured wim files
$richBoxCapture = New-Object System.Windows.Forms.RichTextBox
$richBoxCapture.location = New-Object System.Drawing.Size(20,100) 
$richBoxCapture.Size = New-Object System.Drawing.Size(340,150) 
$richBoxCapture.font = "Calibri, 8pt"
$richBoxCapture.Visible=$True
$richBoxCapture.wordwrap = $true
$richBoxCapture.multiline = $true
$richBoxCapture.readonly = $false
$richBoxCapture.scrollbars = "Vertical"
$richBoxCapture.TabIndex = 2

# Label Info about Windows Partition
$labelPartitionToCapture = New-Object System.Windows.Forms.Label
$labelPartitionToCapture.Font = "Calibri, 7pt, style=Bold"
$labelPartitionToCapture.ForeColor = "Blue"
$labelPartitionToCapture.Location = New-Object System.Drawing.Point(10, 290)
$labelPartitionToCapture.Size = New-Object System.Drawing.Size(280, 25)
$labelPartitionToCapture.Text = ""
$labelPartitionToCapture.TextAlign = "MiddleCenter"

# Button stop imaging Capture process
$stopButtonImgProcess = New-Object System.Windows.Forms.Button
$stopButtonImgProcess.Image = [system.drawing.image]::FromFile("X:\Windows\System32\ICOs\Stop.ico")
$stopButtonImgProcess.ImageAlign = "TopCenter"
$stopButtonImgProcess.BackColor = "ButtonFace"
$stopButtonImgProcess.UseVisualStyleBackColor = $True
$stopButtonImgProcess.Location = New-Object System.Drawing.Size(390,270)
$stopButtonImgProcess.Size = New-Object System.Drawing.Size(64,60)
$stopButtonImgProcess.Font = "Calibri, 5pt"
$stopButtonImgProcess.TabIndex = 1
$stopButtonImgProcess.Text = “Imaging”
$stopButtonImgProcess.TextAlign = "BottomCenter"
$tooltipinfo.SetToolTip($stopButtonImgProcess, "Stops the current imaging capture process.")
$stopButtonImgProcess.Visible = $False
$stopButtonImgProcess.Add_Click({do_StopImaging -processId $Script:processImageID})
# ---------------------------------------------------------------
# PictureBox for main page
$picBoxTwo = New-Object System.Windows.Forms.PictureBox
$picBoxTwo.Width = $imageOne.Size.Width
$picBoxTwo.Height = $imageOne.Size.Height
$picBoxTwo.Image = $imageOne
$picBoxTwo.Location = New-Object Drawing.Point 650,50
$picBoxTwo.BackColor = "Transparent"

# Button Shutdown
$shutdownButtonCreateImg = New-Object System.Windows.Forms.Button
$shutdownButtonCreateImg.Image = [system.drawing.image]::FromFile("X:\Windows\System32\ICOs\Shutdown.ico")
$shutdownButtonCreateImg.ImageAlign = "TopCenter"
$shutdownButtonCreateImg.BackColor = "ButtonFace"
$shutdownButtonCreateImg.UseVisualStyleBackColor = $True
$shutdownButtonCreateImg.Location = New-Object System.Drawing.Size(920,335)
$shutdownButtonCreateImg.Size = New-Object System.Drawing.Size(64,60)
$shutdownButtonCreateImg.Font = "Calibri, 5pt"
$shutdownButtonCreateImg.TabIndex = 1
$shutdownButtonCreateImg.Text = “Shutdown”
$shutdownButtonCreateImg.TextAlign = "BottomCenter"
$tooltipinfo.SetToolTip($shutdownButtonCreateImg, "Shutdown Computer")
$shutdownButtonCreateImg.Add_Click({do_Shutdown})

# Button Restart
$restartButtonCreateImg = New-Object System.Windows.Forms.Button
$restartButtonCreateImg.Image = [system.drawing.image]::FromFile("X:\Windows\System32\ICOs\Restart.ico")
$restartButtonCreateImg.ImageAlign = "TopCenter"
$restartButtonCreateImg.BackColor = "ButtonFace"
$restartButtonCreateImg.UseVisualStyleBackColor = $True
$restartButtonCreateImg.Location = New-Object System.Drawing.Size(840,335)
$restartButtonCreateImg.Size = New-Object System.Drawing.Size(64,60)
$restartButtonCreateImg.Font = "Calibri, 5pt"
$restartButtonCreateImg.TabIndex = 1
$restartButtonCreateImg.Text = “Restart”
$restartButtonCreateImg.TextAlign = "BottomCenter"
$tooltipinfo.SetToolTip($restartButtonCreateImg, "Restart Computer")
$restartButtonCreateImg.Add_Click({do_Restart})

# Button Refresh
$refreshButtonCreateImg = New-Object System.Windows.Forms.Button
$refreshButtonCreateImg.Image = [system.drawing.image]::FromFile("X:\Windows\System32\ICOs\Refresh.ico")
$refreshButtonCreateImg.ImageAlign = "TopCenter"
$refreshButtonCreateImg.BackColor = "ButtonFace"
$refreshButtonCreateImg.UseVisualStyleBackColor = $True
$refreshButtonCreateImg.Location = New-Object System.Drawing.Size(760,335)
$refreshButtonCreateImg.Size = New-Object System.Drawing.Size(64,60)
$refreshButtonCreateImg.Font = "Calibri, 5pt"
$refreshButtonCreateImg.TabIndex = 1
$refreshButtonCreateImg.Text = “Refresh”
$refreshButtonCreateImg.TextAlign = "BottomCenter"
$tooltipinfo.SetToolTip($refreshButtonCreateImg, "Refresh")
$refreshButtonCreateImg.Add_Click({do_RunRefreshForm})

# Button Create Image
$createImgButton = New-Object System.Windows.Forms.Button
$createImgButton.Image = [system.drawing.image]::FromFile("X:\Windows\System32\ICOs\CreateImage.ico")
$createImgButton.ImageAlign = "TopCenter"
$createImgButton.BackColor = "ButtonFace"
$createImgButton.UseVisualStyleBackColor = $True
$createImgButton.Location = New-Object System.Drawing.Size(680,335)
$createImgButton.Size = New-Object System.Drawing.Size(64,60)
$createImgButton.Font = "Calibri, 5pt"
$createImgButton.TabIndex = 1
$createImgButton.Text = “Create”
$createImgButton.TextAlign = "BottomCenter"
$tooltipinfo.SetToolTip($createImgButton, "Create or capture an image of this computer")
$createImgButton.Add_Click({do_CheckInputAndCaptureWim})

# Tab Three
# ================================================================
$tabpage_Three.Text = "Apply Image"
$tabpage_Three.Location = '20, 15'
$tabpage_Three.Padding ='3,3,3,3'
$tabpage_Three.Size = '1050, 460'
$tabpage_Three.BackColor = "White"
$tabpage_Three.TabIndex = 2

# Section for two tabs under Tab Three
# ----------------------------------------------------------------
# Create the tabcontrolAply
$tabcontrolAply = New-Object windows.Forms.TabControl
$tabpage_Partition = New-Object windows.Forms.TabPage
$tabpage_ApplyImg = New-Object windows.Forms.TabPage

$tabcontrolAply.Font ="Calibri, 10pt style=Bold"
$tabcontrolAply.BackColor = "Transparent"
$tabcontrolAply.Anchor = 'Top, Bottom, Left, Right'
$tabcontrolAply.ItemSize = '100,25'
$tabcontrolAply.Padding = '15,5'
$tabcontrolAply.Location = '20, 20'
$tabcontrolAply.width = 600
$tabcontrolAply.Height = 420
# ================================================================
$tabpage_Partition.Text = "Select MBR/UEFI Partitions"
$tabpage_Partition.Location = '20, 15'
$tabpage_Partition.Padding ='3,3,3,3'
$tabpage_Partition.Size = '600, 375'
$tabpage_Partition.BackColor = "White"
$tabpage_Partition.BackgroundImageLayout = "None"
$tabpage_Partition.TabIndex = 0

# Adding radio button to patition tab
# ================================================================
# Create first radiobutton
$radioButtonOne = New-Object System.Windows.Forms.Radiobutton
$radioButtonOne.text = "Default BIOS/MBR"
$radioButtonOne.Font ="Calibri, 7pt"
$radioButtonOne.height = 20
$radioButtonOne.width = 210
$radioButtonOne.top = 30
$radioButtonOne.left = 15
$radioButtonOne.add_click({do_ViewPartition})

# Create second radiobutton
$radioButtonTwo = New-Object System.Windows.Forms.Radiobutton
$radioButtonTwo.text = "Recommended BIOS/MBR"
$radioButtonTwo.Font ="Calibri, 7pt"
$radioButtonTwo.height = 20
$radioButtonTwo.width = 210
$radioButtonTwo.top = 60
$radioButtonTwo.left = 15
$radioButtonTwo.add_click({do_ViewPartition})

# Create third radiobutton
$radioButtonThree = New-Object System.Windows.Forms.Radiobutton
$radioButtonThree.text = "Default UEFI/GPT"
$radioButtonThree.Font ="Calibri, 7pt"
$radioButtonThree.height = 20
$radioButtonThree.width = 210
$radioButtonThree.top = 30
$radioButtonThree.left = 230
$radioButtonThree.add_click({do_ViewPartition})

# Create fourth radiobutton
$radioButtonFour = New-Object System.Windows.Forms.Radiobutton
$radioButtonFour.text = "Recommended UEFI/GPT"
$radioButtonFour.Font ="Calibri, 7pt"
$radioButtonFour.height = 20
$radioButtonFour.width = 210
$radioButtonFour.top = 60
$radioButtonFour.left = 230
$radioButtonFour.add_click({do_ViewPartition})

# Adding labels and textboxes to partition tab
# ----------------- MBR ------------------------------------

#  MBR System Label
$MbrSystemLabel = new-object System.Windows.Forms.Label
$MbrSystemLabel.Location = new-object System.Drawing.Size(15,105) 
$MbrSystemLabel.size = new-object System.Drawing.Size(80,20) 
$MbrSystemLabel.Text = "System:"
$MbrSystemLabel.Font ="Calibri, 8pt"
$MbrSystemLabel.Visible = $False

# MBR System Text Box
$systemTextbox = New-Object System.Windows.Forms.TextBox
$systemTextbox.Location = New-Object System.Drawing.Size(100,105)
$systemTextbox.Size = New-Object System.Drawing.Size(70,20)
$systemTextbox.Text = 350
$systemTextbox.Font ="Calibri, 8pt"
$systemTextbox.Add_TextChanged({
    $this.Text = $this.Text -replace '\D'
})
$systemTextbox.Visible = $False

#  MBR Windows Label
$MbrWindowsLabel = new-object System.Windows.Forms.Label
$MbrWindowsLabel.Location = new-object System.Drawing.Size(15,135) 
$MbrWindowsLabel.size = new-object System.Drawing.Size(80,20) 
$MbrWindowsLabel.Text = "Windows:"
$MbrWindowsLabel.Font ="Calibri, 8pt"
$MbrWindowsLabel.Visible = $False

# MBR Windows Text Box
$windowsTextbox = New-Object System.Windows.Forms.TextBox
$windowsTextbox.Location = New-Object System.Drawing.Size(100,135)
$windowsTextbox.Size = New-Object System.Drawing.Size(70,20)
$windowsTextbox.Text = "XXXXXX"
$windowsTextbox.Font ="Calibri, 8pt"
$windowsTextbox.ReadOnly = $True
$windowsTextbox.Visible = $False

#  MBR Recovery Label
$MbrRecoveryLabel = new-object System.Windows.Forms.Label
$MbrRecoveryLabel.Location = new-object System.Drawing.Size(15,165) 
$MbrRecoveryLabel.size = new-object System.Drawing.Size(80,20) 
$MbrRecoveryLabel.Text = "Recovery:"
$MbrRecoveryLabel.Font ="Calibri, 8pt"
$MbrRecoveryLabel.Visible = $False

# MBR Recovery Text Box
$recoveryTextbox = New-Object System.Windows.Forms.TextBox
$recoveryTextbox.Location = New-Object System.Drawing.Size(100,165)
$recoveryTextbox.Size = New-Object System.Drawing.Size(70,20)
$recoveryTextbox.Text = 15000
$recoveryTextbox.Font ="Calibri, 8pt"
$recoveryTextbox.Add_TextChanged({
    $this.Text = $this.Text -replace '\D'
})
$recoveryTextbox.Visible = $False

#--------------------- GPT -----------------------------------

#  GPT WinRE Label
$gptWinRELabel = new-object System.Windows.Forms.Label
$gptWinRELabel.Location = new-object System.Drawing.Size(220,105) 
$gptWinRELabel.size = new-object System.Drawing.Size(80,20) 
$gptWinRELabel.Text = "WinRE:"
$gptWinRELabel.Font ="Calibri, 8pt"
$gptWinRELabel.Visible = $False

# GPT WinRE Text Box
$gptWinRETextbox = New-Object System.Windows.Forms.TextBox
$gptWinRETextbox.Location = New-Object System.Drawing.Size(315,105)
$gptWinRETextbox.Size = New-Object System.Drawing.Size(70,20)
$gptWinRETextbox.Text = 350
$gptWinRETextbox.Font ="Calibri, 8pt"
$gptWinRETextbox.Add_TextChanged({
    $this.Text = $this.Text -replace '\D'
})
$gptWinRETextbox.Visible = $False

#  GPT System Label
$gptSystemLabel = new-object System.Windows.Forms.Label
$gptSystemLabel.Location = new-object System.Drawing.Size(220,135) 
$gptSystemLabel.size = new-object System.Drawing.Size(80,20) 
$gptSystemLabel.Text = "System:"
$gptSystemLabel.Font ="Calibri, 8pt"
$gptSystemLabel.Visible = $False

# GPT System Text Box
$systemGPTTextbox = New-Object System.Windows.Forms.TextBox
$systemGPTTextbox.Location = New-Object System.Drawing.Size(315,135)
$systemGPTTextbox.Size = New-Object System.Drawing.Size(70,20)
$systemGPTTextbox.Text = 350
$systemGPTTextbox.Font ="Calibri, 8pt"
$systemGPTTextbox.Add_TextChanged({
    $this.Text = $this.Text -replace '\D'
})
$systemGPTTextbox.Visible = $False

#  GPT MSR Label
$gptMSRLabel = new-object System.Windows.Forms.Label
$gptMSRLabel.Location = new-object System.Drawing.Size(220,165) 
$gptMSRLabel.size = new-object System.Drawing.Size(80,20) 
$gptMSRLabel.Text = "MSR:"
$gptMSRLabel.Font ="Calibri, 8pt"
$gptMSRLabel.Visible = $False

# GPT MSR Text Box
$gptMSRTextbox = New-Object System.Windows.Forms.TextBox
$gptMSRTextbox.Location = New-Object System.Drawing.Size(315,165)
$gptMSRTextbox.Size = New-Object System.Drawing.Size(70,20)
$gptMSRTextbox.Text = 128
$gptMSRTextbox.Font ="Calibri, 8pt"
$gptMSRTextbox.Add_TextChanged({
    $this.Text = $this.Text -replace '\D'
})
$gptMSRTextbox.Visible = $False

#  GPT Windows Label
$gptWindowsLabel = new-object System.Windows.Forms.Label
$gptWindowsLabel.Location = new-object System.Drawing.Size(220,195) 
$gptWindowsLabel.size = new-object System.Drawing.Size(80,20) 
$gptWindowsLabel.Text = "Windows:"
$gptWindowsLabel.Font ="Calibri, 8pt"
$gptWindowsLabel.Visible = $False

# GPT Windows Text Box
$gptWindowsTextbox = New-Object System.Windows.Forms.TextBox
$gptWindowsTextbox.Location = New-Object System.Drawing.Size(315,195)
$gptWindowsTextbox.Size = New-Object System.Drawing.Size(70,20)
$gptWindowsTextbox.Text = "XXXXXX"
$gptWindowsTextbox.Font ="Calibri, 8pt"
$gptWindowsTextbox.ReadOnly = $True
$gptWindowsTextbox.Visible = $False

#  GPT Recovery Label
$gptRecoveryLabel = new-object System.Windows.Forms.Label
$gptRecoveryLabel.Location = new-object System.Drawing.Size(220,225) 
$gptRecoveryLabel.size = new-object System.Drawing.Size(80,20) 
$gptRecoveryLabel.Text = "Recovery:"
$gptRecoveryLabel.Font ="Calibri, 8pt"
$gptRecoveryLabel.Visible = $False

# GPT Recovery Text Box
$gptRecoveryTextbox = New-Object System.Windows.Forms.TextBox
$gptRecoveryTextbox.Location = New-Object System.Drawing.Size(315,225)
$gptRecoveryTextbox.Size = New-Object System.Drawing.Size(70,20)
$gptRecoveryTextbox.Text = 15000
$gptRecoveryTextbox.Font ="Calibri, 8pt"
$gptRecoveryTextbox.Add_TextChanged({
    $this.Text = $this.Text -replace '\D'
    $Script:mbrSystem =  $this.Text
})
$gptRecoveryTextbox.Visible = $False

# Input PictureBox
$inputPicture = New-Object System.Windows.Forms.PictureBox
$inputPicture.Location = New-Object Drawing.Point 30,255
$inputPicture.Width = "400"
$inputPicture.Height = "200"
$inputPicture.BackColor = "Transparent"
$inputPicture.SizeMode = "Normal" # "Zoom" , "AutoSize", "CenterImage", "Normal"

# --------------------- End Of MBR and GPT --------------------------
# ================================================================
$tabpage_Partition.Controls.Add($radioButtonOne)
$tabpage_Partition.Controls.Add($radioButtonTwo)
$tabpage_Partition.Controls.Add($radioButtonThree)
$tabpage_Partition.Controls.Add($radioButtonFour)

$tabpage_Partition.Controls.Add($MbrSystemLabel)
$tabpage_Partition.Controls.Add($MbrWindowsLabel)
$tabpage_Partition.Controls.Add($MbrRecoveryLabel)

$tabpage_Partition.Controls.Add($systemTextbox)
$tabpage_Partition.Controls.Add($windowsTextbox)
$tabpage_Partition.Controls.Add($recoveryTextbox)

$tabpage_Partition.Controls.Add($gptWinRELabel)
$tabpage_Partition.Controls.Add($gptSystemLabel)
$tabpage_Partition.Controls.Add($gptMSRLabel)
$tabpage_Partition.Controls.Add($gptWindowsLabel)
$tabpage_Partition.Controls.Add($gptRecoveryLabel)

$tabpage_Partition.Controls.Add($gptWinRETextbox)
$tabpage_Partition.Controls.Add($systemGPTTextbox)
$tabpage_Partition.Controls.Add($gptMSRTextbox)
$tabpage_Partition.Controls.Add($gptWindowsTextbox)
$tabpage_Partition.Controls.Add($gptRecoveryTextbox)

$tabpage_Partition.Controls.Add($inputPicture)

# ================================================================
$tabpage_ApplyImg.Text = "Select Image"
$tabpage_ApplyImg.Location = '20, 15'
$tabpage_ApplyImg.Padding ='3,3,3,3'
$tabpage_ApplyImg.Size = '600, 375'
$tabpage_ApplyImg.BackColor = "white"
$tabpage_ApplyImg.TabIndex = 1

# Adding labels and controls to Select Image tab
# ---------------------------------------------------------------

# RichBox for description of wim files
$richBoxApply = New-Object System.Windows.Forms.RichTextBox
$richBoxApply.location = New-Object System.Drawing.Size(20,100) 
$richBoxApply.Size = New-Object System.Drawing.Size(340,150) 
$richBoxApply.font = "Calibri, 8pt"
$richBoxApply.Visible=$True
$richBoxApply.wordwrap = $true
$richBoxApply.multiline = $true
$richBoxApply.readonly = $true
$richBoxApply.scrollbars = "Vertical"

# Label select .Wim file
$labelForWimFile = New-Object System.Windows.Forms.Label
$labelForWimFile.Location = New-Object System.Drawing.Point(20, 40)
$labelForWimFile.Size = New-Object System.Drawing.Size(140, 25)
$labelForWimFile.Font ="Calibri, 8pt"
$labelForWimFile.Text = "Select Image File:"

# ComoboBox to select Wim files
$comboBoxApply = New-Object System.Windows.Forms.ComboBox
$comboBoxApply.Location = New-Object System.Drawing.Point(160, 40)
$comboBoxApply.Size = New-Object System.Drawing.Size(200, 310)
$comboBoxApply.Font ="Calibri, 8pt"
$comboBoxApply.DropDownStyle = 1
$comboBoxApply.add_SelectedIndexChanged({do_ReadDescription})

# Label Info about Apply image action
$labelPartitionToApply = New-Object System.Windows.Forms.Label
$labelPartitionToApply.Font = "Calibri, 6pt, style=Bold"
$labelPartitionToApply.ForeColor = "Red"
$labelPartitionToApply.Location = New-Object System.Drawing.Point(10, 330)
$labelPartitionToApply.Size = New-Object System.Drawing.Size(340, 25)
$labelPartitionToApply.Text = "NOTE: Computer's Hard Drive will be formatted!"
$labelPartitionToApply.TextAlign = "MiddleCenter"

# Button Delete selected image file
$deleteButtonSelectImgFile = New-Object System.Windows.Forms.Button
$deleteButtonSelectImgFile.Image = [system.drawing.image]::FromFile("X:\Windows\System32\ICOs\Delete.ico")
$deleteButtonSelectImgFile.ImageAlign = "TopCenter"
$deleteButtonSelectImgFile.BackColor = "ButtonFace"
$deleteButtonSelectImgFile.UseVisualStyleBackColor = $True
$deleteButtonSelectImgFile.Location = New-Object System.Drawing.Size(390,265)
$deleteButtonSelectImgFile.Size = New-Object System.Drawing.Size(64,60)
$deleteButtonSelectImgFile.Font = "Calibri, 5pt"
$deleteButtonSelectImgFile.TabIndex = 1
$deleteButtonSelectImgFile.Text = “Delete”
$deleteButtonSelectImgFile.TextAlign = "BottomCenter"
$tooltipinfo.SetToolTip($deleteButtonSelectImgFile, "Deletes selected image file from the list.")
$deleteButtonSelectImgFile.Visible = $False
$deleteButtonSelectImgFile.Add_Click({do_DeleteImageFile})

# Button stop imaging Apply process
$stopButtonApplyImgProcess = New-Object System.Windows.Forms.Button
$stopButtonApplyImgProcess.Image = [system.drawing.image]::FromFile("X:\Windows\System32\ICOs\Stop.ico")
$stopButtonApplyImgProcess.ImageAlign = "TopCenter"
$stopButtonApplyImgProcess.BackColor = "ButtonFace"
$stopButtonApplyImgProcess.UseVisualStyleBackColor = $True
$stopButtonApplyImgProcess.Location = New-Object System.Drawing.Size(320,265)
$stopButtonApplyImgProcess.Size = New-Object System.Drawing.Size(64,60)
$stopButtonApplyImgProcess.Font = "Calibri, 5pt"
$stopButtonApplyImgProcess.TabIndex = 1
$stopButtonApplyImgProcess.Text = “Imaging”
$stopButtonApplyImgProcess.TextAlign = "BottomCenter"
$tooltipinfo.SetToolTip($stopButtonApplyImgProcess, "Stops the current imaging apply process.")
$stopButtonApplyImgProcess.Visible = $False
$stopButtonApplyImgProcess.Add_Click({do_StopApplyImage})

# ================================================================

$tabpage_ApplyImg.Controls.Add($labelForWimFile)
$tabpage_ApplyImg.Controls.Add($comboBoxApply)
$tabpage_ApplyImg.Controls.Add($richBoxApply)
$tabpage_ApplyImg.Controls.Add($labelPartitionToApply)
$tabpage_ApplyImg.Controls.Add($stopButtonApplyImgProcess)
$tabpage_ApplyImg.Controls.Add($deleteButtonSelectImgFile)

# PictureBox for main page
$picBoxThree = New-Object System.Windows.Forms.PictureBox
$picBoxThree.Width = $imageOne.Size.Width
$picBoxThree.Height = $imageOne.Size.Height
$picBoxThree.Image = $imageOne
$picBoxThree.Location = New-Object Drawing.Point 650,50
$picBoxThree.BackColor = "Transparent"

# Button Shutdown
$shutdownButtonApplImg = New-Object System.Windows.Forms.Button
$shutdownButtonApplImg.Image = [system.drawing.image]::FromFile("X:\Windows\System32\ICOs\Shutdown.ico")
$shutdownButtonApplImg.ImageAlign = "TopCenter"
$shutdownButtonApplImg.BackColor = "ButtonFace"
$shutdownButtonApplImg.UseVisualStyleBackColor = $True
$shutdownButtonApplImg.Location = New-Object System.Drawing.Size(920,335)
$shutdownButtonApplImg.Size = New-Object System.Drawing.Size(64,60)
$shutdownButtonApplImg.Font = "Calibri, 5pt"
$shutdownButtonApplImg.TabIndex = 1
$shutdownButtonApplImg.Text = “Shutdown”
$shutdownButtonApplImg.TextAlign = "BottomCenter"
$tooltipinfo.SetToolTip($shutdownButtonApplImg, "Shutdown Computer")
$shutdownButtonApplImg.Add_Click({do_Shutdown})

# Button Restart
$restartButtonApplImg = New-Object System.Windows.Forms.Button
$restartButtonApplImg.Image = [system.drawing.image]::FromFile("X:\Windows\System32\ICOs\Restart.ico")
$restartButtonApplImg.ImageAlign = "TopCenter"
$restartButtonApplImg.BackColor = "ButtonFace"
$restartButtonApplImg.UseVisualStyleBackColor = $True
$restartButtonApplImg.Location = New-Object System.Drawing.Size(840,335)
$restartButtonApplImg.Size = New-Object System.Drawing.Size(64,60)
$restartButtonApplImg.Font = "Calibri, 5pt"
$restartButtonApplImg.TabIndex = 1
$restartButtonApplImg.Text = “Restart”
$restartButtonApplImg.TextAlign = "BottomCenter"
$tooltipinfo.SetToolTip($restartButtonApplImg, "Restart Computer")
$restartButtonApplImg.Add_Click({do_Restart})

# Button Refresh
$refreshButtonApplImg = New-Object System.Windows.Forms.Button
$refreshButtonApplImg.Image = [system.drawing.image]::FromFile("X:\Windows\System32\ICOs\Refresh.ico")
$refreshButtonApplImg.ImageAlign = "TopCenter"
$refreshButtonApplImg.BackColor = "ButtonFace"
$refreshButtonApplImg.UseVisualStyleBackColor = $True
$refreshButtonApplImg.Location = New-Object System.Drawing.Size(760,335)
$refreshButtonApplImg.Size = New-Object System.Drawing.Size(64,60)
$refreshButtonApplImg.Font = "Calibri, 5pt"
$refreshButtonApplImg.TabIndex = 1
$refreshButtonApplImg.Text = “Refresh”
$refreshButtonApplImg.TextAlign = "BottomCenter"
$tooltipinfo.SetToolTip($refreshButtonApplImg, "Refresh")
$refreshButtonApplImg.Add_Click({do_RunRefreshForm})

# Button Create Image
$applyImgButton = New-Object System.Windows.Forms.Button
$applyImgButton.Image = [system.drawing.image]::FromFile("X:\Windows\System32\ICOs\ApplyImage.ico")
$applyImgButton.ImageAlign = "TopCenter"
$applyImgButton.BackColor = "ButtonFace"
$applyImgButton.UseVisualStyleBackColor = $True
$applyImgButton.Location = New-Object System.Drawing.Size(680,335)
$applyImgButton.Size = New-Object System.Drawing.Size(64,60)
$applyImgButton.Font = "Calibri, 5pt"
$applyImgButton.TabIndex = 1
$applyImgButton.Text = “Apply”
$applyImgButton.TextAlign = "BottomCenter"
$tooltipinfo.SetToolTip($applyImgButton, "Apply or install an image to this computer")
$applyImgButton.Add_Click({do_ApplyWim})

# Add the controls to the form
# =========================================================

$objForm.Controls.Add($tabcontrol)
# Tab One
$tabpage_One.Controls.Add($picBoxOne)
$tabpage_One.Controls.Add($pcInfoTextBox)
$tabpage_One.Controls.Add($partitionDriveGrid)
$tabpage_One.Controls.Add($labelTreeViewImages)
$tabpage_One.Controls.Add($treeView1)
$tabpage_One.Controls.Add($buttonDelImgFile)
$tabpage_One.Controls.Add($shutdownButton)
$tabpage_One.Controls.Add($restartButton)
$tabpage_One.Controls.Add($refreshButton)
$tabpage_One.Controls.Add($productKeyButton)
# Tab Two
$groupBoxCapture.Controls.Add($labelWriteImageName)
$groupBoxCapture.Controls.Add($textBoxImageName)
$groupBoxCapture.Controls.Add($richBoxCapture)
$groupBoxCapture.Controls.Add($labelPartitionToCapture)
$groupBoxCapture.Controls.Add($stopButtonImgProcess)
$tabpage_Two.Controls.Add($groupBoxCapture)
$tabpage_Two.Controls.Add($picBoxTwo)
$tabpage_Two.Controls.Add($shutdownButtonCreateImg)
$tabpage_Two.Controls.Add($restartButtonCreateImg)
$tabpage_Two.Controls.Add($refreshButtonCreateImg)
$tabpage_Two.Controls.Add($createImgButton)
# Tab Three
# ------------------------------------------------
$tabpage_Three.Controls.Add($tabcontrolAply)
$tabcontrolAply.tabpages.add($tabpage_Partition)
$tabcontrolAply.tabpages.add($tabpage_ApplyImg)

$tabpage_Three.Controls.Add($picBoxThree)
$tabpage_Three.Controls.Add($shutdownButtonApplImg)
$tabpage_Three.Controls.Add($restartButtonApplImg)
$tabpage_Three.Controls.Add($refreshButtonApplImg)
$tabpage_Three.Controls.Add($applyImgButton)
# Tabcontrol
$tabcontrol.tabpages.add($tabpage_One)
$tabcontrol.tabpages.add($tabpage_Two)
$tabcontrol.tabpages.add($tabpage_Three)

# Activate the form
# =========================================================
$objForm.Add_Load({do_ListPartitions;do_GetFolderTree;do_GetWindowsPartition;do_ListWimFiles})
$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()