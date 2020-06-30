CLS

$OutputFolder   = "E:\Dropbox (Mesheven)\Titan\IT Management\Powershell\Powershell Scripts\Management\"
$OutputFolder   = "C:\Dropbox (Mesheven)\Titan\IT Management\Powershell\Powershell Scripts\Management\"
$OutputFile     = "server-list.txt"
$OutputFileXML  = "server-list.xml"
$OutputFileCSV  = "server-list.csv"

$ServerList     = New-Object Object
$ServerListTemp = @{}
$ServerList     = {$ServerListTemp}.Invoke()

$ServerList =
    @{
         "3dPrinterServer"     = "3d-printer"
         "CncServer"           = "CNCPC"
         "DataBaseServer01"    = "mesh-db-01"
         "DataBaseServer02"    = "mesh-db-02"
         "EmbedderBuildServer" = "Embedded-Build"
         "FileServer01"        = "file-server-01"
         "FinanceServer"       = "finserver"
         "MeshMachine01"       = "HX-02-A"
         "MeshMachine02"       = "HX-02-B"
         "MeshMachine03"       = "HX-02-C"
         "MeshMachine04"       = "HX-02-D"
         "NasDaphnis"          = "daphnis"
         "NasTitan  "          = "titan"
         "PrintServer"         = "print-server"
         "UvLaserServer"       = "UVLaserCut"
         "NasHomeSteve"        = "LiuMaDS1"
         "SteveHomeWork"       = "home-work"
     }

     

$ServerList | Export-Clixml $OutputFolder$OutputFileXML
$ServerList | Export-Csv    $OutputFolder$OutputFileCSV

$Content = @{}

$Content = Import-Clixml $OutputFolder$OutputFileXML
$Content = Import-Csv    $OutputFolder$OutputFileCSV

$Content.Count
