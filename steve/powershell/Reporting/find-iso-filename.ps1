CLS

Function Get-ISOFolderName($FileHash)
{
    $URI_Prefix = "https://www.heidoc.net/php/myvsdump_search.php?fulltext=&minsize=1&maxsize=16348&sha1="
    $URI_Suffix = "&filetype=&architecture=&language=&mindate=1998-04-22T20%3A11%3A00&maxdate=2018-02-11T08%3A53"
    $LineNumber = 0
    $TempFile   = [System.IO.Path]::GetTempFileName()

    $URI = $URI_Prefix + $FileHash + $URI_Suffix

    $HTML = Invoke-WebRequest -UseBasicParsing -URI $URI

    $Links = $FolderName.Links

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

    foreach($Line in $Content)
    {
        $LineNumber++

        if ($Line -match "File Name")
        {
            $FileName =  $Content[$LineNumber]
        }
    }

    $FileName = $FileName.Trim()

    $FileName = $FileName.Replace("<td>", "")

    $FileName = $FileName.Replace("</td>", "")

    Return $FileName
}
#..............................................................................

#..............................................................................

$FolderName = Get-ISOFolderName($FileHash.Hash)

CLS

$FolderName


