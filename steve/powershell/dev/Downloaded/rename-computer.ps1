CLS

Write-Host "Renaming Computer..."
Write-Host

$ComputerNameOld = "K9AMWJ5P"; $ComputerNameNew = "mayo-yang"
$ComputerNameOld = "p27a5ruw"; $ComputerNameNew = "leo-steiner"
$ComputerNameOld = "njgu3d48"; $ComputerNameNew = "li-qingwei"
$ComputerNameOld = "y3k7vtdj"; $ComputerNameNew = "kristine-xu"
$ComputerNameOld = "za5hf6nw"; $ComputerNameNew = "shen-jian"
$ComputerNameOld = "ku843mfr"; $ComputerNameNew = "zou-qingyou"
$ComputerNameOld = "kdae7uz4"; $ComputerNameNew = "peggie-shen"
$ComputerNameOld = "zfat92u5"; $ComputerNameNew = "lisa-li"
$ComputerNameOld = "hqp7w3fm"; $ComputerNameNew = "lei-bin"
$ComputerNameOld = "u7sdwzb5"; $ComputerNameNew = "shao-feng"
$ComputerNameOld = "b2ct8375"; $ComputerNameNew = "zhang-wenjin"
$ComputerNameOld = "w3q75txr"; $ComputerNameNew = "qin-chunhua"
$ComputerNameOld = "ceh26waj"; $ComputerNameNew = "manizheh"
$ComputerNameOld = "mvcbx526"; $ComputerNameNew = "amy-fang"
$ComputerNameOld = "ny9tsf4z"; $ComputerNameNew = "leeyons-li"
$ComputerNameOld = "c832rbsx"; $ComputerNameNew = "rong-longjie"
$ComputerNameOld = "etye";     $ComputerNameNew = "monica-mo"

Write-Host "From: $ComputerNameOld"
Write-Host "To  : $ComputerNameNew"

$Credentials = "192.168.1.132\'admin"

$Restart = $false

if ($Restart)
{
    Write-Host "Force Restart: True"

    Rename-Computer -ComputerName $ComputerNameOld -NewName $ComputerNameNew -LocalCredential $Credentials -Force -PassThru -Restart
}
else
{
    Write-Host "Force Restart: False"

    Rename-Computer -ComputerName $ComputerNameOld -NewName $ComputerNameNew -LocalCredential $Credentials -Force -PassThru
}
