CLS

#..............................................................................

#..............................................................................
Function Get-ThreatIDsByComputer($ReportContents)
{
    foreach($Line in $ReportContents)
    {
        if($Line -match "Computer Name")
        {
            $FoundName = $Line
        }
    }

    Write-Host "Getting unique threat IDs for $FoundName..."

    $ThreatIDs     = @()

    foreach($Line in $ReportContents)
    {
        if($Line -match "Threat ID")
        {
            $ID = $Line.Substring(20).trim()
            
            if($ID.Length -gt 0)
            {
                $ThreatIDs += $ID
            }
        }
    }

    $Threats = $ThreatIDs | Sort -Unique

    Write-Host "Found"  $Threats.Count "unique threats on" $FoundName

    if($Threats.Count -eq 0)
    {
        Return $null
    }
    else
    {
        Return $Threats
    }
}
#..............................................................................

#..............................................................................
Function Get-ReportContentsByComputer($ComputerName)
{
    Write-Host "Loading threat report contents for" $ComputerName "..."

    $ReportContents  = New-Object Object

    $ReportContentsTemp = @{}

    $ReportContents = {$ReportContentsTemp}.Invoke()

    for ($i = 0; $i -lt $ThreatReportsNames.Count; $i++)
    {
        if($ThreatReportsNames[$i] -match $ComputerName)
        {
            $Report = $ThreatReportsNames[$i]

            if(Test-Path $Report.FullName)
            {
                $Contents = Get-Content $Report.FullName
            }
            else
            {
                Write-Warning "File not found: " $Report.FullName
            }

            $ReportContents += $Contents
        }
    }

    $ReportContents = $ReportContents | Sort -Unique

    Write-Host "Loaded" $ReportContents.Count "lines"

    Return $ReportContents | Sort -Unique
}
#..............................................................................

#..............................................................................
Function Get-ComputerSummaryReport
{
    Write-Host "Getting computer summary report..."

    $ComputerSummaryReport = New-Object Object

    $ComputerSummaryReportTemp = @{}

    $ComputerSummaryReport = {$ComputerSummaryReportTemp}.Invoke()
    
    foreach($Computer in $UniqueComputers)
    {
        $ReportContents      = Get-ReportContentsByComputer($Computer)

        $ThreatIDsByComputer = Get-ThreatIDsByComputer     ($ReportContents)
        
        if($ThreatIDsByComputer -ne $null)
        {
            $ComputerSummaryReport += "=============================="             
            $ComputerSummaryReport += "Computer Name:" + $Computer                 
            $ComputerSummaryReport += "Threat Count :" + $ThreatIDsByComputer.Count
            $ComputerSummaryReport += "------------------------------"             
        }
    }

    Return $ComputerSummaryReport
}
#..............................................................................

#..............................................................................

$ComputerName = "STEVE-MARTIN"

# $ReportContents = Get-ReportContentsByComputer($ComputerName)

#$ThreatIDs = Get-ThreatIDsByComputer($ReportContents)

$SummaryReport = Get-ComputerSummaryReport



$SummaryReport