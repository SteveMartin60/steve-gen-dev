function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure,

		[parameter(Mandatory = $true)]
		[System.String]
		$PrinterName,

		[parameter(Mandatory = $true)]
		[System.String]
		$PrinterPort,

		[parameter(Mandatory = $true)]
		[System.String]
		$PortIP,

		[parameter(Mandatory = $true)]
		[System.String]
		$DirverName
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."


	
	$returnValue = @{
		
        Ensure = $Ensure
        PrinterName = $PrinterName
        DirverName = $DirverName
        PrinterPort = $PrinterPort
        PortIP = $PortIP
	}

	$returnValue
	


}




function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure,

		[parameter(Mandatory = $true)]
		[System.String]
		$PrinterName,

		[parameter(Mandatory = $true)]
		[System.String]
		$PrinterPort,

		[parameter(Mandatory = $true)]
		[System.String]
		$PortIP,

		[parameter(Mandatory = $true)]
		[System.String]
		$DirverName
	)
     $Host.UI.WriteVerboseLine("进入配置进程")
     $TestPrinter = TestPrinter -Name $PrinterName 
     $TestPort = TestPort -PortName $PrinterPort 

     if($TestPrinter)
     {
         RemovePrinter -PrinterName $PrinterName
     }
     if($TestPort -and ($Ensure -eq "Absent"))
     {
         RemovePort -PortName $PrinterPort
     }
     
     if($Ensure -eq "Present")
     {
         if(($TestPort -eq $false) -and ($Ensure -eq "Present"))
         {InstallPort -PortName $PrinterPort -PortIP $PortIP }
     
         InstallPrinter -PrinterName $PrinterName -DriverName $DirverName -PortName $PrinterPort
     }
	#$global:DSCMachineStatus = 1

}




function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("Absent","Present")]
		[System.String]
		$Ensure,

		[parameter(Mandatory = $true)]
		[System.String]
		$PrinterName,

		[parameter(Mandatory = $true)]
		[System.String]
		$PrinterPort,

		[parameter(Mandatory = $true)]
		[System.String]
		$PortIP,

		[parameter(Mandatory = $true)]
		[System.String]
		$DirverName
	)
     
     $Host.UI.WriteVerboseLine("进入测试进程")
     $stop =$true
     do
     {
         if($Ensure -eq "Present")
         {
             $Host.UI.WriteVerboseLine("准备测试应用配置状态")
             $stop  = TestPrinter -Name $PrinterName 
             if($stop -eq $false)
             {break}
             $stop=TestPrinterDriver -PrinterName $PrinterName -PrinterDriverName $DirverName
             if($stop -eq $false)
             {break}
             $stop = TestPrinterPortName -PrinterName $PrinterName -PrinterPortName $PrinterPort 
             if($stop -eq $false)
             {break}
             $stop = TestPort -PortName $PrinterPort 
             if($stop -eq $false)
             {break}
             $stop=TestPortIP -PortName $PrinterPort -PortIP $PortIP
             if($stop -eq $false)
             {break}
             
         }   
         if($Ensure -eq "Absent")
         {
             $Host.UI.WriteVerboseLine("准备测试撤销配置状态")
             $TestPrinter  = TestPrinter -Name $PrinterName 
             if($TestPrinter)
             { 
                 $stop =$false
                 break
             }
             $TestPort = TestPort -PortName $PrinterPort 
             if($TestPort)
             {
                 $stop = $false
                 break
             }
             if($TestPrinter -and $PrinterPort)
             {
                  $TestPrinterDriver =TestPrinterDriver -PrinterName $PrinterName -PrinterDriverName $DirverName
                  $TestPrinterPortName =TestPrinterPortName -PrinterName $PrinterName -PrinterPortName $PrinterPort
                  if($TestPrinterDriver)
                  {
                      $stop = $false
                      break
                  } 
                  if($TestPrinterPortName)
                  {
                      $stop = $false
                      break
                  }
             }
             $stop = $true
         }         
         $Host.UI.WriteVerboseLine("资源状态正常")
         $Host.UI.WriteVerboseLine("Test-TargetResource Return  " + $stop.ToString())
     }
     while($stop -eq $false)
     $stop

}



#测试
#返回布尔
Function TestPrinter
{
    [outputtype([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true,HelpMessage="要测试的打印机名称")]
        [System.String]
        $Name
    )
    $re =$false
    $AllPrinter = Get-Printer
    if($AllPrinter.Count -gt 0 )##打印机数量为0 
    {
        if($AllPrinter |where {$_.name -eq $Name})#数量不为0 则查找特定名称打印机
        {
            $re =$true
        }
    }
     if($re)
     {
         $Message=" 打印机存在"
     }
     else
     {
         $Message=" 打印机不存在"
     }
     $Host.UI.WriteVerboseLine($Name+$Message)
     $re
}
#测试打印机驱动正确
Function TestPrinterDriver
{
    [OutPutType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true,HelpMessage="要测试的打印机名称")]
        [System.String]
        $PrinterName, #打印机名称
        [parameter(Mandatory = $true,HelpMessage="要测试的打印机驱动名称")]
        [System.String]
        $PrinterDriverName  #打印机驱动名称
    )
    $re  =$false
    $Printer = Get-Printer -Name $PrinterName
    if($Printer.DriverName -eq $PrinterDriverName )
    {
        
        $re =$true
    }
    if($re)
    {
       $Message = " 打印机驱动匹配"
    }
    else
    {
       $Message = " 打印机驱动不匹配"
    }
    $Host.UI.WriteVerboseLine($PrinterName+","+$PrinterDriverName +$Message)
    $re
}
#测试打印机端口正确
Function TestPrinterPortName
{
    [OutPutType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true,HelpMessage="要测试的打印机名称")]
        [System.String]
        $PrinterName, #打印机名称
        [parameter(Mandatory = $true,HelpMessage="要测试的打印机所在端口名称")]
        [System.String]
        $PrinterPortName  #打印机端口名称
    )
    $Printer = Get-Printer -Name $PrinterName
    $re =$false
    if($Printer.PortName -eq $PrinterPortName)
    {
        $re =$true
    }
    if($re)
    {
        $Message = " 端口匹配"
    }
    else
    {
        $Message = "端口不匹配"
    }
    $Host.UI.WriteVerboseLine($PrinterName+","+$PrinterPortName+$Message)
    $re
}
#测试指定打印机端口存在
Function TestPort
{
    [OutPutType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true,HelpMessage="要测试的打印端口名称")]
        [System.String]
        $PortName
    )
    $AllPort =Get-PrinterPort

    $re  =$false
    if($AllPort.count -gt 0 )
    {
        if($AllPort| where {$_.Name -eq $PortName})
        {
            $re =$true
        }
    }
    if($re)
    {
        $Message = " 端口存在"
    }
    else
    {
        $Message = " 端口不存在"
    }
    $Host.UI.WriteVerboseLine($PortName+ $Message)
    $re


}
#测试指定打印机端口IP 地址正确
Function TestPortIP
{
    [OutPutType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true,HelpMessage="要测试的打印端口名称")]
        [System.String]
        $PortName,
        [Parameter(Mandatory = $true,HelpMessage="要测试的打印端口所包含打印机主机地址")]
        [System.String]
        $PortIP
    )
    $re = $false
    $Port = Get-PrinterPort -Name $PortName
    if($Port.PrinterHostAddress -eq $PortIP)
    {
        $re = $true
    }
    if($re)
    {
         $Message= " 端口IP地址匹配"
    }
    else
    {
         $Message=" 端口IP地址不匹配"
    }
    $Host.UI.WriteVerboseLine($PortName+","+$PortIP +$Message)
    $re

}
#安装
#安装打印机端口
Function InstallPort
{
    param
    (
        [Parameter(Mandatory = $true,HelpMessage="该打印机所在端口名称")]
        [System.String]
        $PortName,
        [Parameter(Mandatory = $true,HelpMessage="该打印机所在IP")]
        [System.String]
        $PortIP
    )
    $Host.UI.WriteVerboseLine("安装端口 "+$PortName)
    Add-PrinterPort -Name $PortName -PrinterHostAddress $PortIP
}
#安装打印机
Function InstallPrinter
{
    param
    (
        [Parameter(Mandatory = $true,HelpMessage="要安装的打印机名称")]
        [System.String]
        $PrinterName,
        [Parameter(Mandatory = $true,HelpMessage="要安装的打印机驱动名称")]
        [System.String]
        $DriverName,
        [Parameter(Mandatory = $true,HelpMessage="要安装的打印机端口名称")]
        [System.String]
        $PortName
    )
    $Host.UI.WriteVerboseLine("安装打印机 "+$PrinterName)
    Add-Printer -DriverName $DriverName -PortName $PortName -Name $PrinterName
}
##删除
#删除打印机端口
Function RemovePort
{
    param
    (
        [Parameter(Mandatory = $true,HelpMessage="要安装的端口名称")]
        [System.String]
        $PortName
    )
    $Host.UI.WriteVerboseLine("删除端口 "+$PortName)
    $Port = Get-PrinterPort -Name $PortName
    $Port |Remove-PrinterPort -Confirm:$false
}
#删除打印机 
Function RemovePrinter
{
    param
    (
        [Parameter(Mandatory = $true,HelpMessage="要安装的打印机名称")]
        [System.String]
        $PrinterName
    )
    $Host.UI.WriteVerboseLine("删除打印机 "+$PrinterName )
    Get-Printer -Name $PrinterName |Remove-Printer -Confirm:$false
}

Export-ModuleMember -Function *-TargetResource



