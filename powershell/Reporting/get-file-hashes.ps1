CLS

#..............................................................................

#..............................................................................
Function Get-ISOPageContent($Hash)
{
    $URI_Prefix = "https://www.heidoc.net/php/myvsdump_search.php?fulltext=&minsize=1&maxsize=16348&sha1="
    $URI_Suffix = "&filetype=&architecture=&language=&mindate=1998-04-22T20%3A11%3A00&maxdate=2018-02-11T08%3A53"
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

    if($href.Length -gt 0)
    {
        $ISOPage = Invoke-WebRequest -UseBasicParsing -URI $href

        $ISOPage.Content | Out-File $TempFile

        $Content = Get-Content $TempFile

        Remove-Item $TempFile -Force -ErrorAction SilentlyContinue

        Return $Content
    }

    Return $null
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

        if ($Line -match "<title>")
        {
            $ISOFolderName =  $Line
        }
    }

    $ISOFolderName = $ISOFolderName.Trim()
                   
    $ISOFolderName = $ISOFolderName.Replace("<title>" , "")
    $ISOFolderName = $ISOFolderName.Replace("</title>", "")

    Return $ISOFolderName
}
#..............................................................................

#..............................................................................
Function Validate-MicrosoftFileHash($FileHash)
{
    $Result = $false

    $URI_Prefix = "https://www.heidoc.net/php/myvsdump_search.php?fulltext=&minsize=1&maxsize=16348&sha1="
    $URI_Suffix = "&filetype=&architecture=&language=&mindate=1998-04-22T20%3A11%3A00&maxdate=2018-02-11T08%3A53"

    $URI = $URI_Prefix + $FileHash + $URI_Suffix

    $HTML = Invoke-WebRequest -UseBasicParsing -URI $URI

    $Content = $HTML.RawContent

    if (!($Content -match "Your query produced no search results"))
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

$Path = 'C:\Dropbox (Mesheven)\Software\Microsoft\.Net Framework Installers'

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

$Count = 0

foreach($File in $FileList)
{
    $Count++

    $StartTime = Get-Date

    Write-Host "Validating File          : $Count of " $FileList.Count
    Write-Host "Start Time               :" $StartTime
    Write-Host "Getting Hash for         :"$File.FullName
    
    $FileHash           = Get-FileHashSha1 -Algorithm SHA1 $File.FullName

    Write-Host "Validating Hash for      :"$File.FullName
    $ValidMicrosoftFile = Validate-MicrosoftFileHash($FileHash.Hash)

    if($ValidMicrosoftFile)
    {
        $ISOPageContent       = Get-ISOPageContent($FileHash.Hash)

        $ISOFolderName        = Get-ISOFolderName ($ISOPageContent)

        $ISOFileName          = Get-ISOFileName   ($ISOPageContent)

        $DirectoryNameCorrect = ($File.Directory.Name -eq $ISOFolderName)

        $FileNameCorrect      = ($File.Name -eq $ISOFileName)
    }

    ""
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

if($RenameCommands.Count -gt 0)
{
    Write-Host ""
    Write-Host "----------------------------------------------------------"
    Write-Host "Rename Commands"
    $RenameCommands
}