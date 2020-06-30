$Printername =  New-xDscResourceProperty -Name PrinterName -Type String -Attribute Key -Description "要添加的打印机"
$PrinterPort = New-xDscResourceProperty -Name PrinterPort -Type String -Attribute Required -Description "要添加的打印机端口"
$PortIP = New-xDscResourceProperty -Name PortIP -Type String -Attribute Required -Description "要添加的打印机IP"
$DirverName = New-xDscResourceProperty -Name DirverName -Type String -Attribute Required -Description "打印机驱动名称 该驱动必须已经安装"
$Ensure  =New-xDscResourceProperty -Name Ensure -Type String -Attribute Required -ValidateSet "Absent","Present"
#New-xDscResource -Name xPrinter -Property $Printername,$PrinterPort,$PortIP,$PortDirver -Path c:\xPrinter


Update-xDscResource  -Property $Ensure,$Printername,$PrinterPort,$PortIP,$DirverName -Path C:\xPrinter\DSCResources\xPrinter
