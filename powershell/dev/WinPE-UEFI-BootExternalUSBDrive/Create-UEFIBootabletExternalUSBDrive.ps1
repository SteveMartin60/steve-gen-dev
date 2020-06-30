# =================================================================
# www.AlexComputerBubble - Create UEFI Bootable External USB Drive
# =================================================================
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

# =================================================================
# Functions
# =================================================================

Function do_StartMediaLabel($state) {
switch($state)
{
    "START" {$labelWaitForCommLineWindow.Text = "Please wait until the Powershell Command Line Windows is closed.";$labelWaitForCommLineWindow.ForeColor = "Red"
             $labelInfoAboutScriptAction.Text = "Once all Media Files are created please proceed to the second step.";$labelInfoAboutScriptAction.ForeColor = "Blue";Break}
    "END" {$labelInfoAboutScriptAction.Text = "";$labelWaitForCommLineWindow.Text = "";Break}
}
    $objForm.Refresh()
}

Function Select-Folder{
param(
        $message=’Select a folder’,
        $path = 0,
        [int]$source
    )
$object = New-Object -ComObject Shell.Application
$folder = $object.BrowseForFolder(0, $message, 0, $path)
    if ($folder -ne $null -and $source -eq 1) {
    $sourceTextbox.Text = $folder.self.path
    $Script:folderPath = $sourceTextbox.Text
    } 
} 

Function do_StartPSScript($Mode){

switch($Mode){
"32-BIT"{ 
$commandStartPSScript = @"
Start-Process PowerShell -ArgumentList "$($Script:folderPath)\WinPE50-UEFI.ps1 -WinArch 'x86'"  
"@
}
"64-BIT"{
$commandStartPSScript = @"
Start-Process PowerShell -ArgumentList "$($Script:folderPath)\WinPE50-UEFI.ps1 -WinArch 'amd64'" 
"@
}
}
    Invoke-Expression $commandStartPSScript
}

Function do_CreateMediaFiles{

    If ($radioButtonOne.Checked -eq $True){
        $WinPEMode = "32-BIT"
    }
    ElseIf($radioButtonTwo.Checked -eq $True){
        $WinPEMode = "64-BIT"
    }
    Else {
        [System.Windows.Forms.MessageBox]::Show("Please select 32-Bit/64-Bit option!")
        return
    }

    If(($sourceTextbox.Text) -and (Test-Path -Path "$($Script:folderPath)\WinPE50-UEFI.ps1" )) {
        do_StartPSScript -Mode $WinPEMode
        do_StartMediaLabel("START")
    }
    Else{
        [System.Windows.Forms.MessageBox]::Show("Please select folder named 'WinPE-UEFI-BootExternalUSBDrive'.")
        do_StartMediaLabel("END")
        return
    }
}

Function do_StartLabel{
    $messageForActionLabel.ForeColor = "Red";$messageForActionLabel.Text = “... Formating , please wait ...”
    $objform.refresh()
}

Function do_ChangeLabel{
    $messageForActionLabel.ForeColor = "Blue";$messageForActionLabel.Text = “Creation of UEFI Boot USB Drive completed successfully”
    $objform.refresh
}

Function do_ClearLabel{
    $messageForActionLabel.Text = “”
    $objform.refresh
}

Function do_ListDiskPartResult{      
    If($viewDataGrid.columncount -gt 0){
        $viewDataGrid.DataSource = $null
        $viewDataGrid.Columns.Clear()
    }     
    $Column1 = New-Object System.Windows.Forms.DataGridViewCheckBoxColumn
    $Column1.name = "Select"
    $viewDataGrid.Columns.Add($Column1)

	$array = New-Object System.Collections.ArrayList
    $pcInfo = New-Object System.Collections.ArrayList
        # ----------------------------------------------

    New-Item -Path $env:TEMP -Name ListDisk.txt -ItemType File -Force | Out-Null
    Add-Content -Path $env:TEMP\ListDisk.txt "List disk"
    $listDisk = (C:\Windows\System32\DiskPart /s $env:TEMP\ListDisk.txt)
    $diskID = $listDisk[-1].Substring(7,2).Trim()
    $totalDisk = $diskID

   $array = @(
    for ($d=0;$d -le $totalDisk;$d++){
    $diskID = $LISTDISK[-1-$d].Substring(7,5).trim()
    Add-Content -Path $env:TEMP\ListDisk.txt "Select disk $diskID"
    Add-Content -Path $env:TEMP\ListDisk.txt "Detail disk"
    $detailDisk = (C:\Windows\System32\DiskPart /s $env:TEMP\ListDisk.txt)
    $name = $detailDisk[-19].Trim()
    $driveLetter = $detailDisk[-1].Substring(15,1)
    $type = $detailDisk[-17].Substring(9).Trim()
    $size = $detailDisk[-1].Substring(51,9).Trim()
    $partitionType = $detailDisk[-1].Substring(39,9).Trim()
    
    [pscustomobject]@{DiskNumber=$DISKID;DriveLetter=$DRIVELETTER;Type=$TYPE; Size= $SIZE;PartitionType=$partitionType; DiskName=$NAME}
    }
  )
    $pcInfo.AddRange($array)
    $viewDataGrid.DataSource = $pcInfo
 
    for($i=0;$i -lt $viewDataGrid.RowCount;$i++){ 

       if($viewDataGrid.Item('PartitionType',$i).Value.ToString() -like "Removable" `
        -or $viewDataGrid.Item('DriveLetter',$i).Value.ToString() -like "C")
            {
            $viewDataGrid.Item('PartitionType',$i).Style.backcolor = 'red' 
            }
       else    
            {
            $viewDataGrid.Item('PartitionType',$i).Style.backcolor = 'green' 
            }
    }

	$objform.refresh()  
}



Function do_CreateImageContainer{
$volumes = (Get-WmiObject -Query "SELECT * from Win32_LogicalDisk" | Select -Property Properties )
foreach($i In $volumes){
    switch ("$($i.Properties.Item("VolumeName").Value)")
    {
    "IMAGEDATA" {
        # $partition = $i.Properties.Item("VolumeName").Value
        $drive = $i.Properties.Item("Caption").Value
        }
    }
}

If ($radioButtonOne.Checked){
    # "32-BIT"
    New-Item -Path $drive -Name "Images" -ItemType directory | Out-Null
    New-Item -Path "$drive\Images" -Name "32-BIT" -ItemType directory | Out-Null
    New-Item -Path $drive -Name "Owner Files" -ItemType directory | Out-Null
    }
Elseif($radioButtonTwo.Checked){
    # "64-BIT"
    New-Item -Path $drive -Name "Images" -ItemType directory | Out-Null
    New-Item -Path "$drive\Images" -Name "64-BIT" -ItemType directory | Out-Null
    New-Item -Path $drive -Name "Owner Files" -ItemType directory | Out-Null
 }
}

Function do_CopyFiles($diskLetter, $folder){

  $FOF_CREATEPROGRESSDLG = "&H0&"
  $objShell = New-Object -ComObject "Shell.Application"
  $objFolder = $objShell.NameSpace($diskLetter)
 
    if(Test-Path -Path $folder){
	$folder = $folder + "\*.*"
        $objFolder.CopyHere($folder, $FOF_CREATEPROGRESSDLG)

    do_CreateImageContainer

    }  
    else{
        [System.Windows.Forms.MessageBox]::Show("Folder does not exist!")
    }
}

Function do_ReadMessage($msg){
Add-Type -AssemblyName System.Speech
$synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$synthesizer.GetInstalledVoices() | ForEach-Object { $_.VoiceInfo }
$synthesizer.Speak("$msg")
}

Function do_InitializeDrive($diskNumber) {
NEW-ITEM $env:TEMP -Name MakeBootable.txt -ItemType file -force | OUT-NULL
ADD-CONTENT -Path $env:TEMP\MakeBootable.txt -Value "SELECT DISK $diskNumber"
ADD-CONTENT -Path $env:TEMP\MakeBootable.txt -Value "CLEAN"
ADD-CONTENT -Path $env:TEMP\MakeBootable.txt -Value "CREATE PARTITION PRIMARY size=4096"
ADD-CONTENT -Path $env:TEMP\MakeBootable.txt -Value "FORMAT FS=Fat32 QUICK LABEL=""WinPE"" "
ADD-CONTENT -Path $env:TEMP\MakeBootable.txt -Value "ASSIGN"
ADD-CONTENT -Path $env:TEMP\MakeBootable.txt -value "ACTIVE"
ADD-CONTENT -Path $env:TEMP\MakeBootable.txt -Value "CREATE PARTITION PRIMARY"
ADD-CONTENT -Path $env:TEMP\MakeBootable.txt -Value "FORMAT FS=NTFS QUICK LABEL=""IMAGEDATA"" "
ADD-CONTENT -Path $env:TEMP\MakeBootable.txt -Value "ASSIGN"
DiskPart /s $env:TEMP\MakeBootable.txt | Out-Null

New-Item -Path $env:TEMP -Name FindDiskLetter.txt -ItemType File -Force | Out-Null
Add-Content -Path $env:TEMP\FindDiskLetter.txt "List disk"
Add-Content -Path $env:TEMP\FindDiskLetter.txt "Select disk $diskNumber"
Add-Content -Path $env:TEMP\FindDiskLetter.txt "Detail disk"
$detailDisk = (DiskPart /s $env:TEMP\FindDiskLetter.txt)
$driveLetter = $detailDisk[-2].Substring(15,1) + ":"
    if("$($Script:folderPath)\Media") {
        do_CopyFiles -diskLetter $driveLetter -folder "$($Script:folderPath)\Media"
    }
}

Function do_RunAction {
$answer= [System.Windows.Forms.MessageBox]::Show("Do you want to perform this action?" , "Create External USB Bootable Drive" , 4)
if ($answer -eq "YES" ) {
    for($i=0;$i -lt $viewDataGrid.RowCount;$i++){ 
        if($viewDataGrid.Rows[$i].Cells['Select'].Value -eq $true){
            $diskNumber = $viewDataGrid.Rows[$i].Cells['DiskNumber'].Value
            #[System.Windows.Forms.MessageBox]::Show("Selected: $diskNumber")
            do_StartLabel
            do_InitializeDrive($diskNumber) | Out-Null
            do_ChangeLabel
            do_ReadMessage -msg "External USB Bootable Media Created"            
         }    
    }
            
 }  
 else { 
       [System.Windows.Forms.MessageBox]::Show("You have canceled Run action.")
 }      
    #
    $sourceTextbox.Text = ""
    $objform.refresh
}

Function do_CloseForm {
    $objform.Close()
}

# =================================================================
# Create a Form
# =================================================================

$objForm = New-Object System.Windows.Forms.Form
$objForm.Text = "www.AlexComputerBubble - Create UEFI Bootable External USB Drive"
$objForm.Size = New-Object System.Drawing.Size(900,550)
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

$tabcontrol.Font ="Calibri, 12pt style=Bold"
$tabcontrol.Anchor = 'Top, Bottom, Left, Right'
$tabcontrol.ItemSize = '100,25'
$tabcontrol.Padding = '15,5'
$tabcontrol.Location = '20, 20'
$tabcontrol.width = 840
$tabcontrol.Height = 460

# Tab One
# ================================================================
$tabpage_One.Text = "First Step"
$tabpage_One.Location = '20, 15'
$tabpage_One.Padding ='3,3,3,3'
$tabpage_One.Size = '840, 460'
$tabpage_One.BackColor = "White"
$tabpage_One.BackgroundImageLayout = "None"
$tabpage_One.TabIndex = 0

# GroupBox for creation of Media files
$groupBoxMediaFiles = New-Object System.Windows.Forms.groupBox
$groupBoxMediaFiles.Location = '20, 20'
$groupBoxMediaFiles.Name = "groupCapture"
$groupBoxMediaFiles.Size = '780, 375'
$groupBoxMediaFiles.TabStop = $False
$groupBoxMediaFiles.BackColor = "Transparent"
$groupBoxMediaFiles.Text = "Create Bootable Media Files:"

# Add Message Label to the Tab
$bitSelectionLable = New-Object System.Windows.Forms.Label
$bitSelectionLable.Location = New-Object System.Drawing.Size(20,50)
$bitSelectionLable.Size = New-Object System.Drawing.Size(620,18)
$bitSelectionLable.Font = "Calibri, 11pt"
$bitSelectionLable.Text = “1: Click the radion button to select 32-Bit or 64-Bit"

# Create first radiobutton
$radioButtonOne = New-Object System.Windows.Forms.Radiobutton
$radioButtonOne.text = "32-BIT"
$radioButtonOne.Font = "Calibri, 11pt"
$radioButtonOne.height = 20
$radioButtonOne.width = 100
$radioButtonOne.top = 100
$radioButtonOne.left = 40
#$radioButtonOne.add_click({do_SelectArch})

# Create second radiobutton
$radioButtonTwo = New-Object System.Windows.Forms.Radiobutton
$radioButtonTwo.text = "64-BIT"
$radioButtonTwo.Font = "Calibri, 11pt"
$radioButtonTwo.height = 20
$radioButtonTwo.width = 100
$radioButtonTwo.top = 100
$radioButtonTwo.left = 200
#$radioButtonTwo.add_click({do_SelectArch})

# Add Message Label to the Tab
$sourceFolderLabel = New-Object System.Windows.Forms.Label
$sourceFolderLabel.Location = New-Object System.Drawing.Size(20,150)
$sourceFolderLabel.Size = New-Object System.Drawing.Size(620,18)
$sourceFolderLabel.Font = "Calibri, 11pt"
$sourceFolderLabel.Text = “2: Click the Browse Source button to select the folder named 'WinPE-UEFI-BootExternalUSBDrive'.”

# Add Text Box to the Tab
$sourceTextbox = New-Object System.Windows.Forms.TextBox
$sourceTextbox.Location = New-Object System.Drawing.Size(20,200)
$sourceTextbox.Size = New-Object System.Drawing.Size(330,20)
$sourceTextbox.Font = "Calibri, 11pt"

# Add Button to select folder
$sourceBrowseButton = New-Object System.Windows.Forms.Button
$sourceBrowseButton.Location = New-Object System.Drawing.Size(600,200)
$sourceBrowseButton.Size = New-Object System.Drawing.Size(150,25)
$sourceBrowseButton.TabIndex = 0
$sourceBrowseButton.Font = "Calibri, 11pt"
$sourceBrowseButton.Text = “Browse Source”
$sourceBrowseButton.TextAlign = "MiddleCenter"
$tooltipinfo.SetToolTip($sourceBrowseButton, "Click this button to select the folder named 'WinPE-UEFI-BootExternalUSBDrive'")
# $sourceBrowseButton.Add_Click({Select-Folder -message "Select Source Folder" -path "[Environment]::GetFolderPath(‘MyDocuments’)" -source 1})
$sourceBrowseButton.Add_Click({Select-Folder -message "Select Source Folder" -path "" -source 1})
# Add Message Label to the Tab

$searchFolderLabel = New-Object System.Windows.Forms.Label
$searchFolderLabel.Location = New-Object System.Drawing.Size(20,250)
$searchFolderLabel.Size = New-Object System.Drawing.Size(550,18)
$searchFolderLabel.Font = "Calibri, 11pt"
$searchFolderLabel.Text = “3: Click the Start button to start creating folders for UEFI external Drive.”

# Add Button to create media files
$createMediaFilesButton = New-Object System.Windows.Forms.Button
$createMediaFilesButton.Location = New-Object System.Drawing.Size(600,250)
$createMediaFilesButton.Size = New-Object System.Drawing.Size(150,25)
$createMediaFilesButton.TabIndex = 1
$createMediaFilesButton.Font = "Calibri, 11pt"
$createMediaFilesButton.Text = “Start”
$createMediaFilesButton.TextAlign = "MiddleCenter"
$tooltipinfo.SetToolTip($createMediaFilesButton, "Click this button to start creating Media Files for UEFI bootable USB Drive")
$createMediaFilesButton.Add_Click({do_CreateMediaFiles})

# Label Wait for Command line window
$labelWaitForCommLineWindow = New-Object System.Windows.Forms.Label
$labelWaitForCommLineWindow.Font = "Calibri, 12pt, style=Bold"
$labelWaitForCommLineWindow.Location = New-Object System.Drawing.Point(20, 300)
$labelWaitForCommLineWindow.Size = New-Object System.Drawing.Size(550, 25)
$labelWaitForCommLineWindow.Text = ""
$labelWaitForCommLineWindow.TextAlign = "MiddleCenter"

# Label Info about script action
$labelInfoAboutScriptAction = New-Object System.Windows.Forms.Label
$labelInfoAboutScriptAction.Font = "Calibri, 12pt, style=Bold"
$labelInfoAboutScriptAction.Location = New-Object System.Drawing.Point(20, 330)
$labelInfoAboutScriptAction.Size = New-Object System.Drawing.Size(550, 25)
$labelInfoAboutScriptAction.Text = ""
$labelInfoAboutScriptAction.TextAlign = "MiddleCenter"

# Add Button to exit application
$exitButtonOne = New-Object System.Windows.Forms.Button
$exitButtonOne.Location = New-Object System.Drawing.Size(600,320)
$exitButtonOne.Size = New-Object System.Drawing.Size(150,25)
$exitButtonOne.TabIndex = 1
$exitButtonOne.Font = "Calibri, 11pt"
$exitButtonOne.TabIndex = 1
$exitButtonOne.Text = “Exit”
$exitButtonOne.TextAlign = "MiddleCenter"
$tooltipinfo.SetToolTip($exitButtonOne, "Click this button to exit this application")
$exitButtonOne.Add_Click({do_CloseForm})

# Tab Two
# ================================================================
$tabpage_Two.Text = "Second Step"
$tabpage_Two.Location = '20, 15'
$tabpage_Two.Padding ='3,3,3,3'
$tabpage_Two.Size = '840, 460'
$tabpage_Two.BackColor = "white"
$tabpage_Two.TabIndex = 1

# GroupBox for creation of USB external drive
$groupBoxUsbDrive = New-Object System.Windows.Forms.groupBox
$groupBoxUsbDrive.Location = '20, 20'
$groupBoxUsbDrive.Name = "groupCapture"
$groupBoxUsbDrive.Size = '780, 375'
$groupBoxUsbDrive.TabStop = $False
$groupBoxUsbDrive.BackColor = "Transparent"
$groupBoxUsbDrive.Text = "Make External USB Drive Bootable:"

# List USB drives Label
$labelListDisk = New-Object System.Windows.Forms.Label
$labelListDisk.Font = "Calibri, 11pt"
$labelListDisk.Location = New-Object System.Drawing.Size(20,40)
$labelListDisk.Size = New-Object System.Drawing.Size(270,25)
$labelListDisk.Text = “List of the avalilable Drives:”

# Add Grid View to the Tab
$viewDataGrid = New-Object System.Windows.Forms.DataGridView
$viewDataGrid.Name = "ListDiskPartResult"
$viewDataGrid.Font = "Calibri, 10pt"
$viewDataGrid.TabIndex = 0
$viewDataGrid.Location = New-Object Drawing.Point 20,70
$viewDataGrid.Size = New-Object Drawing.Point 540,200
$viewDataGrid.AutoSizeColumnsMode = 'AllCells'  # 'Fill'
$viewDataGrid.MultiSelect = $false
$viewDataGrid.RowHeadersVisible = $false
$viewDataGrid.ColumnHeadersVisible = $true
$viewDataGrid.allowusertoordercolumns = $true

# Message Label Action
$messageForActionLabel = New-Object System.Windows.Forms.Label
$messageForActionLabel.Font = "Calibri, 12pt, style=Bold"
$messageForActionLabel.Location = New-Object System.Drawing.Size(50,300)
$messageForActionLabel.Size = New-Object System.Drawing.Size(380,25)
$messageForActionLabel.Text = “”

# Button List USB drives
$buttonViewDisk = New-Object System.Windows.Forms.Button
$buttonViewDisk.Location = New-Object System.Drawing.Size(600,100)
$buttonViewDisk.Size = New-Object System.Drawing.Size(150,25)
$buttonViewDisk.TabIndex = 3
$buttonViewDisk.Font = "Calibri, 11pt"
$buttonViewDisk.Text = “View Drive(s)”
$buttonViewDisk.TextAlign = "MiddleCenter"
$tooltipinfo.SetToolTip($buttonViewDisk, "Click this button to view all available Drives connected to your computer")
$buttonViewDisk.Add_Click({do_ListDiskPartResult})

# Button Run action
$buttonRun = New-Object System.Windows.Forms.Button
$buttonRun.Location = New-Object System.Drawing.Size(600,250)
$buttonRun.Size = New-Object System.Drawing.Size(150,25)
$buttonRun.TabIndex = 4
$buttonRun.Font = "Calibri, 11pt"
$buttonRun.Text = “Run”
$buttonRun.TextAlign = "MiddleCenter"
$tooltipinfo.SetToolTip($buttonRun, "Click this button to create UEFI Bootable USB External Drive")
$buttonRun.Add_Click({do_RunAction})

# Button Close app
$buttonClose = New-Object System.Windows.Forms.Button
$buttonClose.Location = New-Object System.Drawing.Size(600, 320)
$buttonClose.Size = New-Object System.Drawing.Size(150,25)
$buttonClose.TabIndex = 5
$buttonClose.Font = "Calibri, 11pt"
$buttonClose.Text = “Exit”
$buttonClose.TextAlign = "MiddleCenter"
$tooltipinfo.SetToolTip($buttonClose, "Click this button to exit this application")
$buttonClose.Add_Click({do_CloseForm})

# Add the controls to the form
# =========================================================
$objForm.Controls.Add($tabcontrol)

# Tab One
$groupBoxMediaFiles.Controls.Add($bitSelectionLable)
$groupBoxMediaFiles.Controls.Add($radioButtonOne)
$groupBoxMediaFiles.Controls.Add($radioButtonTwo)
$groupBoxMediaFiles.Controls.Add($sourceFolderLabel)
$groupBoxMediaFiles.Controls.Add($sourceTextbox)
$groupBoxMediaFiles.Controls.Add($sourceBrowseButton)
$groupBoxMediaFiles.Controls.Add($searchFolderLabel)
$groupBoxMediaFiles.Controls.Add($createMediaFilesButton)
$groupBoxMediaFiles.Controls.Add($labelWaitForCommLineWindow)
$groupBoxMediaFiles.Controls.Add($labelInfoAboutScriptAction)
$groupBoxMediaFiles.Controls.Add($exitButtonOne)
$tabpage_One.Controls.Add($groupBoxMediaFiles)

# Tab Two
$groupBoxUsbDrive.Controls.Add($labelListDisk)
$groupBoxUsbDrive.Controls.Add($viewDataGrid)
$groupBoxUsbDrive.Controls.Add($messageForActionLabel)
$groupBoxUsbDrive.Controls.Add($buttonViewDisk)
$groupBoxUsbDrive.Controls.Add($buttonRun)
$groupBoxUsbDrive.Controls.Add($buttonClose)
$tabpage_Two.Controls.Add($groupBoxUsbDrive)

# Tabcontrol
$tabcontrol.tabpages.add($tabpage_One)
$tabcontrol.tabpages.add($tabpage_Two)
# Activate the form
# =========================================================
# $objForm.Add_Load({do_Something})
$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()