CLS

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

    $Result = Get-ChildItem -Path $Path –File -Recurse | Where-Object Extension -eq ".iso"

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

$Path = 'J:\迅雷下载\Temp\Office HS'

$FileList = @()

$FileList = Get-DirectoryFileListing($Path)

# $FileList

$Output  = @()
$Folders = @()

foreach($File in $FileList)
{
    Write-Host "Getting Hash for: $File.FullName"

    "----------------------------------------------------------"
    "DirectoryName    ：" + $File.DirectoryName
    "Name             ：" + $File.Name
    "----------------------------------------------------------"
    ""
    "----------------------------------------------------------"
    $FileHash = FileHashSha1 -Algorithm SHA1 $File.FullName
    $tab = "`t"
    $Folders += $File.DirectoryName
    $Output  += $File.Name + $tab +$FileHash.Hash
}
#..............................................................................

#..............................................................................

$Folders

$Folders | Out-File "D:\iso-file-folders.txt"

"----------------------------------------------------------"
""
"----------------------------------------------------------"

$Output

$Output | Out-File "D:\iso-file-hashes.txt"

