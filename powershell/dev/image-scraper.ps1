CLS

#Step 1 - Invoking the web request, making first contact with the site.

$ImageFolder = "C:\Scrape"

Set-Location $ImageFolder

Write-Host "Attempting to call website." -ForegroundColor Green

$Page = Invoke-WebRequest -Uri "https://community.spiceworks.com/topic/2062121-scraping-images-with-invoke-webrequest"

#Step 2 - Create directory for files to be downloaded into

if(!(Test-Path $ImageFolder))
{
    New-Item -Path $ImageFolder -ItemType directory

    Write-Host "Directory has been created." -ForegroundColor Green
}
else
{
    Write-Host "$ImageFolder Already Exists!"
}

#Step 3 - List all images from page and download them into newly created directory

Write-Host "Getting Image List..."

$Images = ($Page).Images | Select-Object src

foreach ($Image in $Images)
{
    $FileName = $Image.src.Substring($Image.src.LastIndexOf("/") + 1)

    Write-Host "File Name: " $FileName
        
    Invoke-WebRequest -Uri $Image.src -OutFile $FileName
        
    Write-Host 'Image download complete'
}
<#

$Images
@($Page.Images.src).foreach(
    {
        $FileName = $_ | Split-Path -Leaf
        
        Write-Host "File Name: " $FileName

        Invoke-WebRequest -Uri $_ -OutFile "$fileName"
        
        Write-Host 'Image download complete'
    }
)


#>
