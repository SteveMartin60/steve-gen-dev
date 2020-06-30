CLS

#..............................................................................

#..............................................................................
Function Get-ISOPageContent($Hash)
{
    $URI_Prefix = "https://msdn.su/?filter="
    $LineNumber = 0
    $TempFile   = [System.IO.Path]::GetTempFileName()

    $URI = $URI_Prefix + $Hash + $URI_Suffix

    $HTML = Invoke-WebRequest -UseBasicParsing -URI $URI

    $Links = $HTML.Links

    foreach($Link in $Links)
    {
        if ($Link.outerHTML -match "myvsdump_details.php")
        {
            $href = $Link.href
        }
    }

    $ISOPage = Invoke-WebRequest -UseBasicParsing -URI $href

    $ISOPage.Content | Out-File $TempFile

    $Content = Get-Content $TempFile

    Remove-Item $TempFile -Force -ErrorAction SilentlyContinue

    Return $Content
}
#..............................................................................

#..............................................................................
Function Get-ISOFileName($ISOPageContent)
{
    $LineNumber = 0

    foreach($Line in $ISOPageContent)
    {
        $LineNumber++

        if ($Line -match "File Name")
        {
            $ISOFileName =  $ISOPageContent[$LineNumber]
        }
    }

    $ISOFileName   = $ISOFileName.Trim()
                   
    $ISOFileName   = $ISOFileName.Replace("<td>" , "")
    $ISOFileName   = $ISOFileName.Replace("</td>", "")

    Return $ISOFileName
}
#..............................................................................

#..............................................................................
Function Get-ISOFolderName($ISOPageContent)
{
    $LineNumber = 0

    foreach($Line in $ISOPageContent)
    {
        $LineNumber++

        if ($Line -match "MSDN File Description")
        {
            $ISOFolderName =  $ISOPageContent[$LineNumber]
        }
    }

    $ISOFolderName   = $ISOFolderName.Trim()
                   
    $ISOFolderName   = $ISOFolderName.Replace("<td>" , "")
    $ISOFolderName   = $ISOFolderName.Replace("</td>", "")

    Return $ISOFolderName
}
#..............................................................................
cls
#..............................................................................
Function Validate-MicrosoftFileHash($FileHash)
{
    $Result = $false

    $URI_Prefix = "https://msdn.su/?filter="

    $URI = $URI_Prefix + $FileHash

    $HTML = Invoke-WebRequest -UseBasicParsing -URI $URI

    $Content = $HTML.RawContent

    if (!($Content -match "Sorry, no files found. Please modify or simplify the search query."))
    {
        $Result = $true
    }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-DirectoryFileListing($Path)
{
    $Result = @{}

    $Result = Get-ChildItem -Path $Path –File -Recurse | Where-Object Extension -eq ".exe"

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-FileHashSha1($FilePath)
{
    Return Get-FileHash -Algorithm SHA1 $FilePath
}
#..............................................................................

#..............................................................................

$Path = 'C:\Dropbox (Mesheven)\Software\Microsoft\.Net Framework Installers\.NET Framework 1.1'

if(!(Test-Path $Path))
{
    Write-Host "Path Not Found: " $Path
}

$FileList       = @()
$Output         = @()
$Folders        = @()
$HTML           = @()
$DeleteCommands = @()
$RenameCommands = @()

$FileList = Get-DirectoryFileListing($Path)

foreach($File in $FileList)
{
    $StartTime = Get-Date
    Write-Host "Start Time               : " $StartTime

    Write-Host "Getting Hash for         : "$File.FullName
    $FileHash           = Get-FileHashSha1 -Algorithm SHA1 $File.FullName

    Write-Host "Validating Hash for      : "$File.FullName
    $ValidMicrosoftFile = Validate-MicrosoftFileHash($FileHash.Hash)

    $ISOPageContent       = Get-ISOPageContent($FileHash.Hash)

    $ISOFolderName        = Get-ISOFolderName ($ISOPageContent)

    $ISOFileName          = Get-ISOFileName   ($ISOPageContent)

    $DirectoryNameCorrect = ($File.Directory.Name -eq $ISOFolderName)

    $FileNameCorrect      = ($File.Name -eq $ISOFileName)

    "---------------------------"
    "Actual File Path         : " + $File.DirectoryName
    "Actual Directory Name    : " + $File.Directory.Name
    "Actual File Name         : " + $File.Name
    "Hash                     : " + $FileHash.Hash
    "Algorithm                : " + $FileHash.Algorithm
    "Valid Microsoft File     : " + $ValidMicrosoftFile

    if($ValidMicrosoftFile)
    {
        "Required File Name       : " + $ISOFileName
        "Required Folder Name     : " + $ISOFolderName
        "Actual Directory Correct : " + $DirectoryNameCorrect
        "Actual File Name Correct : " + $FileNameCorrect

        if(!($FileNameCorrect))
        {
            $RenameCommand = "Rename-Item """ + $File.FullName + """ """ + $ISOFolderName + """"

            $RenameCommands += $RenameCommand
        }

        if(!($DirectoryNameCorrect))
        {
            $RenameCommand = "Rename-Item """ + $File.DirectoryName + """ """ + $ISOFolderName + """"

            $RenameCommands += $RenameCommand
        }

        $FinishTime = Get-Date

        Write-Host "Finish Time              :" $FinishTime
    }
    else
    {
        $DeleteCommand = "DEL """ + $File.FullName + """"

        $DeleteCommands += $DeleteCommand

        $FinishTime = Get-Date

        Write-Host "Finish Time              :" $FinishTime
    }

    Write-Host "----------------------------------------------------------"
}
#..............................................................................

#..............................................................................

Write-Host "----------------------------------------------------------"
Write-Host "Rename Commands"

$RenameCommands

