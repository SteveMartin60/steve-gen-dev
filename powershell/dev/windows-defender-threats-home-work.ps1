CLS

$ComputerName = $Env:COMPUTERNAME

Set-Location "C:\Users\steve.martin\Downloads\Dropbox (Mesheven)\Titan\IT Management\Reports\Systems"

#..............................................................................

#..............................................................................
Function Prepare-Report
{
    $NewLine  = "`n"

    $Report = @()

    foreach ($Line in $ThreatInfo)
    {
        $Report += $Line
        $Report += $NewLine
    }

    Return $Report
}
#..............................................................................

#..............................................................................
Function Send-Email
{
    $Computer        =  $Env:COMPUTERNAME
    $SMTPServer      = "smtp.sendgrid.net"
    $SMTPUsername    = "ShanghaiSteve"
    $SMTPPassword    = "multiply-Melodic-inks-972"
    $EmailFrom       = "system-reports@mesheven.com"
    $EmailTo         = "steve.martin@mesheven.com"
    $EmailAttachment = $ReportFile
    $AttachmentType  = "text/plain"
    $SMTPPort        = 587

    $EmailBody       = Prepare-Report
    $Today           = Get-Date -UFormat "%Y-%m-%d %H:%M:%S"

    $Subject         = "System Threat Report: " + $Computer + " - " + $Today

    $MailMessage     = New-Object System.Net.Mail.MailMessage
    $Attachment      = New-Object System.Net.Mail.Attachment  ($EmailAttachment, $AttachmentType)
    $SMTPClient      = New-Object System.Net.Mail.SmtpClient  ($SmtpServer     , $SMTPPort      )
    $Credentials     = New-Object System.Net.NetworkCredential($SMTPUsername   , $SMTPPassword  )

    $SMTPClient.EnableSsl   = $False
    $SMTPClient.Credentials = $Credentials

    $MailMessage.From       = $EmailFrom
    $MailMessage.Subject    = $Subject
    $MailMessage.Body       = $EmailBody

    $MailMessage.To.         Add($EmailTo   )
    $MailMessage.Attachments.Add($Attachment)

    $SMTPClient.Send($MailMessage)
}
#..............................................................................

#..............................................................................
Function Get-ThreatInfo
{
    $ThreatInfo     = New-Object Object
    $ThreatInfoTemp = @{}
    $ThreatInfo     = {$ThreatInfoTemp}.Invoke()

    $ThreatInfo.Add("========================================"              )
    $ThreatInfo.Add("System Threat Report"                                  )
    $ThreatInfo.Add("----------------------------------------"              )
    $ThreatInfo.Add(""                                                      )
    $ThreatInfo.Add("Report Summary"                                        )
    $ThreatInfo.Add("----------------------------------"                    )
    $ThreatInfo.Add("Computer Name: " + $ComputerName                       )
    $ThreatInfo.Add("Command      : Get-MpThreat"                           )
    $ThreatInfo.Add("Report Date  : " + $Today                              )
    $ThreatInfo.Add("----------------------------------"                    )
    $ThreatInfo.Add(""                                                      )
    $ThreatInfo.Add("Threat Totals"                                         )
    $ThreatInfo.Add("-------------------------"                             )
    $ThreatInfo.Add("Total Threats         : " + $MpThreats.Count           )
    $ThreatInfo.Add("Total Threats Resolved: " + $ResolvedThreatCount       )
    $ThreatInfo.Add("Total Threats Active  : " + $ActiveThreatCount         )
    $ThreatInfo.Add(""                                                      )
    $ThreatInfo.Add("Time Since Last Scans"                                 )
    $ThreatInfo.Add("-------------------------"                             )
    $ThreatInfo.Add("Full Scan  : " + $FullScanTimeAgo  + " Hours"          )
    $ThreatInfo.Add("Quick Scan : " + $QuickScanTimeAgo + " Hours"          )
    $ThreatInfo.Add("========================="                             )

    foreach($MpThreat in $MpThreats)
    {
        $Category  = Get-ThreatCategory ($MpThreat.CategoryID               )
        $Severity  = Get-Severity       ($MpThreat.SeverityID               )
        $Type      = Get-Type           ($MpThreat.TypeID                   )

        $Resources = $MpThreat.Resources | Get-Unique | Sort-Object

        $ThreatInfo.Add(""                                                  )
        $ThreatInfo.Add("===================================="              )
        $ThreatInfo.Add("Threat Name: " + $MpThreat.ThreatName              )
        $ThreatInfo.Add("------------------------------------"              )
        $ThreatInfo.Add("Threat ID          : " + $MpThreat.ThreatID        )
        $ThreatInfo.Add("Category           : " + $Category                 )
        $ThreatInfo.Add("Severity           : " + $Severity                 )
        $ThreatInfo.Add("Is Active          : " + $MpThreat.IsActive        )
        $ThreatInfo.Add("Type               : " + $Type                     )
        $ThreatInfo.Add("Did Threat Execute : " + $MpThreat.DidThreatExecute)
        $ThreatInfo.Add("----------"                                        )
        $ThreatInfo.Add("Resources:"                                        )
        $ThreatInfo.Add("----------"                                        )

        foreach($Resource in $Resources)
        {
            $ThreatInfo.Add($Resource)
        }

        $ThreatInfo.Add("----------------------------------------"          )
    }

    Return $ThreatInfo
}
#..............................................................................

#..............................................................................
Function Get-ActiveThreatCount($Threats)
{
    $Result = 0

    foreach($Threat in $Threats)
    {
        if ($Threat.IsActive -eq $true)
        {
            $Result++
        }
    }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-UniqueThreatIDs
{
    $U_ThreatIDs     = @{}
    $U_ThreatIDs     = New-Object Object
    $U_ThreatIDsTemp = @{}
    $U_ThreatIDs     = {$ThreatIDsTemp}.Invoke()

    foreach($Threat in $MpThreats         ) {$U_ThreatIDs += $Threat.ThreatID}
    foreach($Threat in $MpThreatDetections) {$U_ThreatIDs += $Threat.ThreatID}

    $U_ThreatIDs = $U_ThreatIDs | Sort-Object | Get-Unique

    Return $U_ThreatIDs
}
#..............................................................................

#..............................................................................
Function Get-Type($TypeID)
{
    $Result = 'Unknown Value'

    if($TypeID -eq 0) {$Result = 'Known Bad' }
    if($TypeID -eq 1) {$Result = 'Behavior'  }
    if($TypeID -eq 2) {$Result = 'Unknown'   }
    if($TypeID -eq 3) {$Result = 'Known Good'}
    if($TypeID -eq 4) {$Result = 'NRI'       }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-Severity($SeverityID)
{
    $Result = 'Unknown Value'

    if($SeverityID -eq 0) {$Result = 'Unknown' }
    if($SeverityID -eq 1) {$Result = 'Low'     }
    if($SeverityID -eq 2) {$Result = 'Moderate'}
    if($SeverityID -eq 3) {$Result = 'High'    }
    if($SeverityID -eq 4) {$Result = 'Severe'  }
    if($SeverityID -eq 5) {$Result = 'N/A'     }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-CurrentThreatExecutionStatus($CurrentThreatExecutionStatusID)
{
    $Result = 'Unknown Value'

    if($DetectionSourceTypeID -eq 0) {$Result = 'Unknown'     }
    if($DetectionSourceTypeID -eq 1) {$Result = 'Blocked'     }
    if($DetectionSourceTypeID -eq 2) {$Result = 'Allowed'     }
    if($DetectionSourceTypeID -eq 3) {$Result = 'Executing'   }
    if($DetectionSourceTypeID -eq 4) {$Result = 'NotExecuting'}

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-DetectionSourceType($DetectionSourceTypeID)
{
    $Result = 'Unknown Value'

    if($DetectionSourceTypeID -eq 0) {$Result = 'Unknown'          }
    if($DetectionSourceTypeID -eq 1) {$Result = 'User'             }
    if($DetectionSourceTypeID -eq 2) {$Result = 'System'           }
    if($DetectionSourceTypeID -eq 3) {$Result = 'Real-time'        }
    if($DetectionSourceTypeID -eq 4) {$Result = 'IOAV'             }
    if($DetectionSourceTypeID -eq 5) {$Result = 'NRI'              }
    if($DetectionSourceTypeID -eq 7) {$Result = 'ELAM'             }
    if($DetectionSourceTypeID -eq 8) {$Result = 'LocalAttestation' }
    if($DetectionSourceTypeID -eq 9) {$Result = 'RemoteAttestation'}

    Return $Result
}

#..............................................................................

#..............................................................................
Function Get-ThreatStatus($ThreatStatusID)
{

    $Result = 'Unknown Value'

    if($ThreatStatusID -eq         0) {$Result = 'Unknown'          }
    if($ThreatStatusID -eq         1) {$Result = 'Detected'         }
    if($ThreatStatusID -eq         2) {$Result = 'Cleaned'          }
    if($ThreatStatusID -eq         3) {$Result = 'Quarantined'      }
    if($ThreatStatusID -eq         4) {$Result = 'Removed'          }
    if($ThreatStatusID -eq         5) {$Result = 'Allowed'          }
    if($ThreatStatusID -eq         6) {$Result = 'Blocked'          }
    if($ThreatStatusID -eq       102) {$Result = 'QuarantineFailed' }
    if($ThreatStatusID -eq       103) {$Result = 'RemoveFailed'     }
    if($ThreatStatusID -eq       104) {$Result = 'AllowFailed'      }
    if($ThreatStatusID -eq       105) {$Result = 'Abondoned'        }
    if($ThreatStatusID -eq       107) {$Result = 'BlockedFailed'    }

    if($ThreatStatusID -eq 'Blocked') {$Result = 'CleanFailed'      }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-ThreatCategory($ThreatCategoryID)
{

    $Result = 'Unknown Value'

    if($ThreatCategoryID -eq 00) {$Result = 'INVALID'                  }
    if($ThreatCategoryID -eq 01) {$Result = 'ADWARE'                   }
    if($ThreatCategoryID -eq 02) {$Result = 'SPYWARE'                  }
    if($ThreatCategoryID -eq 03) {$Result = 'PASSWORDSTEALER'          }
    if($ThreatCategoryID -eq 04) {$Result = 'TROJANDOWNLOADER'         }
    if($ThreatCategoryID -eq 05) {$Result = 'WORM'                     }
    if($ThreatCategoryID -eq 06) {$Result = 'BACKDOOR'                 }
    if($ThreatCategoryID -eq 07) {$Result = 'REMOTEACCESSTROJAN'       }
    if($ThreatCategoryID -eq 08) {$Result = 'TROJAN'                   }
    if($ThreatCategoryID -eq 09) {$Result = 'EMAILFLOODER'             }
    if($ThreatCategoryID -eq 10) {$Result = 'KEYLOGGER'                }
    if($ThreatCategoryID -eq 11) {$Result = 'DIALER'                   }
    if($ThreatCategoryID -eq 12) {$Result = 'MONITORINGSOFTWARE'       }
    if($ThreatCategoryID -eq 13) {$Result = 'BROWSERMODIFIER'          }
    if($ThreatCategoryID -eq 14) {$Result = 'COOKIE'                   }
    if($ThreatCategoryID -eq 15) {$Result = 'BROWSERPLUGIN'            }
    if($ThreatCategoryID -eq 16) {$Result = 'AOLEXPLOIT'               }
    if($ThreatCategoryID -eq 17) {$Result = 'NUKER'                    }
    if($ThreatCategoryID -eq 18) {$Result = 'SECURITYDISABLER'         }
    if($ThreatCategoryID -eq 19) {$Result = 'JOKEPROGRAM'              }
    if($ThreatCategoryID -eq 20) {$Result = 'HOSTILEACTIVEXCONTROL'    }
    if($ThreatCategoryID -eq 21) {$Result = 'SOFTWAREBUNDLER'          }
    if($ThreatCategoryID -eq 22) {$Result = 'STEALTHNOTIFIER'          }
    if($ThreatCategoryID -eq 23) {$Result = 'SETTINGSMODIFIER'         }
    if($ThreatCategoryID -eq 24) {$Result = 'TOOLBAR'                  }
    if($ThreatCategoryID -eq 25) {$Result = 'REMOTECONTROLSOFTWARE'    }
    if($ThreatCategoryID -eq 26) {$Result = 'TROJANFTP'                }
    if($ThreatCategoryID -eq 27) {$Result = 'POTENTIALUNWANTEDSOFTWARE'}
    if($ThreatCategoryID -eq 28) {$Result = 'ICQEXPLOIT'               }
    if($ThreatCategoryID -eq 29) {$Result = 'TROJANTELNET'             }
    if($ThreatCategoryID -eq 30) {$Result = 'FILESHARINGPROGRAM'       }
    if($ThreatCategoryID -eq 31) {$Result = 'MALWARE_CREATION_TOOL'    }
    if($ThreatCategoryID -eq 32) {$Result = 'REMOTE_CONTROL_SOFTWARE'  }
    if($ThreatCategoryID -eq 33) {$Result = 'TOOL'                     }
    if($ThreatCategoryID -eq 34) {$Result = 'TROJAN_DENIALOFSERVICE'   }
    if($ThreatCategoryID -eq 36) {$Result = 'TROJAN_DROPPER'           }
    if($ThreatCategoryID -eq 37) {$Result = 'TROJAN_MASSMAILER'        }
    if($ThreatCategoryID -eq 38) {$Result = 'TROJAN_MONITORINGSOFTWARE'}
    if($ThreatCategoryID -eq 39) {$Result = 'TROJAN_PROXYSERVER'       }
    if($ThreatCategoryID -eq 40) {$Result = 'VIRUS'                    }
    if($ThreatCategoryID -eq 42) {$Result = 'KNOWN'                    }
    if($ThreatCategoryID -eq 43) {$Result = 'UNKNOWN'                  }
    if($ThreatCategoryID -eq 44) {$Result = 'SPP'                      }
    if($ThreatCategoryID -eq 45) {$Result = 'BEHAVIOR'                 }
    if($ThreatCategoryID -eq 46) {$Result = 'VULNERABILTIY'            }
    if($ThreatCategoryID -eq 47) {$Result = 'POLICY'                   }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-ThreatResources($Resources)
{
    $ResourceList     = @{}
    $ResourceList     = New-Object Object
    $ResourceListTemp = @{}
    $ResourceList     = {$ResourceListTemp}.Invoke()

    foreach($Resource in $Resources)
    {
        if($Resource.Contains('webfile:'))
        {
            $ResourceList = $Resource
        }
        elseif($Resource.Contains('file:'))
        {
            $ThreatFile = $Resource
        }
        elseif($Resource.Contains('container:'))
        {
            $ThreatContainer = $Resource
        }
        else
        {
        }
    }
}
#..............................................................................

#..............................................................................

$MPStatus            = Get-MpComputerStatus
$MpThreats           = Get-MpThreat
$MpThreatDetections  = Get-MpThreatDetection
$ThreatIDs           = Get-UniqueThreatIDs
$ActiveThreatCount   = Get-ActiveThreatCount($MpThreats)
$Today               = Get-Date -UFormat "%Y-%m-%d %H:%M:%S"
$ReportFile          = "Sytem-Threats.txt"                    

$LastFullScanTime    = $MPStatus. FullScanEndTime
$LastQuickScanTime   = $MPStatus. QuickScanEndTime
$TotalThreatCount    = $MpThreats.Count
$ResolvedThreatCount = $TotalThreatCount - $ActiveThreatCount

$FullScanTimeAgo  = ((Get-Date) - $LastFullScanTime ).Days * 24 + ((Get-Date) - $LastFullScanTime ).Hours
$QuickScanTimeAgo = ((Get-Date) - $LastQuickScanTime).Days * 24 + ((Get-Date) - $LastQuickScanTime).Hours

$ThreatInfo = Get-ThreatInfo

$ThreatInfo

$ThreatInfo | Out-File $ReportFile

if ($TotalThreatCount -gt 0)
{
    Send-Email
}

