CLS

#..............................................................................

#..............................................................................
Function Get-SubmitSamplesConsent($SubmitSamplesConsent)
{
    $Result = 'Unknown Value'

    if($SubmitSamplesConsent -eq 0) {$Result = 'Always prompt'                  }
    if($SubmitSamplesConsent -eq 1) {$Result = 'Send safe samples automatically'}
    if($SubmitSamplesConsent -eq 2) {$Result = 'Never send'                     }
    if($SubmitSamplesConsent -eq 3) {$Result = 'Send all samples automatically' }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-ASR_RuleState($ASR_RuleGUID)
{
    $Result = 'Unknown Value'

    $ASR_RegistryPath  = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'

    $RuleState = (Get-Itemproperty $ASR_RegistryPath).$ASR_RuleGUID

    if($RuleState -eq 0) {$Result = 'Off’  }
    if($RuleState -eq 1) {$Result = 'Block’}
    if($RuleState -eq 2) {$Result = 'Audit’}

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-ASR_RuleName($ASR_RuleGUID)
{
    $Result = 'Unknown Value'

    if($ASR_RuleGUID -eq 'BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550') {$Result = 'Block executable content from email client and webmail                   '}
    if($ASR_RuleGUID -eq 'D4F940AB-401B-4EFC-AADC-AD5F3C50688A') {$Result = 'Block Office applications from creating child processes                  '}
    if($ASR_RuleGUID -eq '3B576869-A4EC-4529-8536-B80A7769E899') {$Result = 'Block Office applications from creating executable content               '}
    if($ASR_RuleGUID -eq '75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84') {$Result = 'Block Office applications from injecting code into other processes       '}
    if($ASR_RuleGUID -eq 'D3E037E1-3EB8-44C8-A917-57927947596D') {$Result = 'Block JavaScript or VBScript from launching downloaded executable content'}
    if($ASR_RuleGUID -eq '5BEB7EFE-FD9A-4556-801D-275E5FFC04CC') {$Result = 'Block execution of potentially obfuscated scripts                        '}
    if($ASR_RuleGUID -eq '92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B') {$Result = 'Block Win32 API calls from Office macro                                  '}

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-ScanParameter($ScanParameter)
{
    $Result = 'Unknown Value'
    
    if($ScanParameter -eq 1) {$Result = 'Quick Scan'}
    if($ScanParameter -eq 2) {$Result = 'Full Scan' }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-ThreatDefaultAction($ThreatDefaultAction)
{
    $Result = 'Unknown Value'

    if($ThreatDefaultAction -eq 01) {$Result = 'Clean'      }
    if($ThreatDefaultAction -eq 02) {$Result = 'Quarantine' }
    if($ThreatDefaultAction -eq 03) {$Result = 'Remove'     }
    if($ThreatDefaultAction -eq 06) {$Result = 'Allow'      }
    if($ThreatDefaultAction -eq 08) {$Result = 'UserDefined'}
    if($ThreatDefaultAction -eq 09) {$Result = 'NoAction'   }
    if($ThreatDefaultAction -eq 10) {$Result = 'Block'      }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-DaySchedule($DaySchedule)
{
    $Result = 'Unknown Value'

    if($DaySchedule -eq 0) {$Result = 'Everyday' }
    if($DaySchedule -eq 1) {$Result = 'Sunday'   }
    if($DaySchedule -eq 2) {$Result = 'Monday'   }
    if($DaySchedule -eq 3) {$Result = 'Tuesday'  }
    if($DaySchedule -eq 4) {$Result = 'Wednesday'}
    if($DaySchedule -eq 5) {$Result = 'Thursday' }
    if($DaySchedule -eq 6) {$Result = 'Friday'   }
    if($DaySchedule -eq 7) {$Result = 'Saturday' }
    if($DaySchedule -eq 8) {$Result = 'Never'    }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-ComputerState($ComputerState)
{
    $Result = 'Unknown Value'

    if($ComputerState -eq 00) {$Result = 'Clean‘                   }
    if($ComputerState -eq 01) {$Result = 'Pending full scan‘       }
    if($ComputerState -eq 02) {$Result = 'Pending reboot‘          }
    if($ComputerState -eq 04) {$Result = 'Pending manual steps‘    }
    if($ComputerState -eq 08) {$Result = 'Pending offline scan‘    }
    if($ComputerState -eq 16) {$Result = 'Pending critical failure‘}

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-ScanSource($ScanSource)
{
    $Result = 'Unknown Value'

    if($ScanSource -eq 0) {$Result = 'Unknown'  }
    if($ScanSource -eq 1) {$Result = 'User'     }
    if($ScanSource -eq 2) {$Result = 'System'   }
    if($ScanSource -eq 3) {$Result = 'Real-time'}
    if($ScanSource -eq 4) {$Result = 'IOAV'     }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-MAPSReporting($MAPSReporting)
{
    $Result = 'Unknown Value'

    if($MAPSReporting -eq 01) {$Result = 'Disabled'}
    if($MAPSReporting -eq 01) {$Result = 'Basic'   }
    if($MAPSReporting -eq 02) {$Result = 'Advanced'}

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-RealTimeScanDirection($RealTimeScanDirection)
{
    $Result = 'Unknown Value'

    if($RealTimeScanDirection -eq 0) {$Result = 'Scan both incoming and outgoing files'}
    if($RealTimeScanDirection -eq 1) {$Result = 'Scan incoming files only'             }
    if($RealTimeScanDirection -eq 2) {$Result = 'Scan outgoing files only'             }
    
    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-CloudBlockLevel($CloudBlockLevel)
{
    $Result = 'Unknown Value'
                               
    if($CloudBlockLevel -eq 0) {$Result = 'Default'      }
    if($CloudBlockLevel -eq 2) {$Result = 'High'         }
    if($CloudBlockLevel -eq 4) {$Result = 'HighPlus'     }
    if($CloudBlockLevel -eq 6) {$Result = 'ZeroTolerance'}

    Return $Result
}
#..............................................................................

#..............................................................................
CLS

$ComputerName = $Env:COMPUTERNAME

$Today    = Get-Date -UFormat "%Y-%m-%d %H:%M:%S"

$PreferencesInfo = New-Object Object

$PreferencesInfoTemp = @{}

$PreferencesInfo = {$PreferencesInfoTemp}.Invoke()

$MpThreat          = Get-MpThreat
$MpThreatDetection = Get-MpThreatDetection
$MPStatus          = Get-MpComputerStatus
$Preferences       = Get-MpPreference -ErrorAction SilentlyContinue
$ASR_RuleGUIDs     = $Preferences.AttackSurfaceReductionRules_Ids
$ASR_RuleActions   = $Preferences.AttackSurfaceReductionRules_Actions
$ASR_Exclusiuons   = $Preferences.AttackSurfaceReductionOnlyExclusions

$CloudBlockLevel             = Get-CloudBlockLevel      ($Preferences.CloudBlockLevel            )
$RealTimeScanDirection       = Get-RealTimeScanDirection($Preferences.RealTimeScanDirection      )
$LowThreatDefaultAction      = Get-ThreatDefaultAction  ($Preferences.LowThreatDefaultAction     )
$ModerateThreatDefaultAction = Get-ThreatDefaultAction  ($Preferences.ModerateThreatDefaultAction)
$HighThreatDefaultAction     = Get-ThreatDefaultAction  ($Preferences.HighThreatDefaultAction    )
$SevereThreatDefaultAction   = Get-ThreatDefaultAction  ($Preferences.SevereThreatDefaultAction  )
$UnknownThreatDefaultAction  = Get-ThreatDefaultAction  ($Preferences.UnknownThreatDefaultAction )
$MAPSReporting               = Get-MAPSReporting        ($Preferences.MAPSReporting              )
$RemediationScheduleDay      = Get-DaySchedule          ($Preferences.RemediationScheduleDay     )
$ScanScheduleDay             = Get-DaySchedule          ($Preferences.ScanScheduleDay            )
$SignatureScheduleDay        = Get-DaySchedule          ($Preferences.SignatureScheduleDay       )
$ScanParameter               = Get-ScanParameter        ($Preferences.ScanParameters             )
$SubmitSamplesConsent        = Get-SubmitSamplesConsent ($Preferences.SubmitSamplesConsent       )

$ComputerState               = Get-ComputerState        ($MPStatus.   ComputerState              )
$LastFullScanSource          = Get-ScanSource           ($MPStatus.   LastFullScanSource         )
$LastQuickScanSource         = Get-ScanSource           ($MPStatus.   LastQuickScanSource        )

$PreferencesInfo.Add("=============================================")
$PreferencesInfo.Add("Anti-Malware & Anti-Virus Protection Report"  )
$PreferencesInfo.Add("=============================================")
$PreferencesInfo.Add(""                                             )
$PreferencesInfo.Add("=================================="           )
$PreferencesInfo.Add("Report Summary"                               )
$PreferencesInfo.Add("----------------------------------"           )
$PreferencesInfo.Add("Computer Name : " + $Env:COMPUTERNAME             )
$PreferencesInfo.Add("Report Date   : " + $Today                    )
$PreferencesInfo.Add("Computer State: " + $ComputerState            )
$PreferencesInfo.Add("=================================="           )
$PreferencesInfo.Add(""                                             )
$PreferencesInfo.Add(""                                             )

$PreferencesInfo.Add("====================================="                                                                                      )
$PreferencesInfo.Add("Anti-Malware & Anti-Virus Preferences"                                                                                      )
$PreferencesInfo.Add("-------------------------------------"                                                                                      )
$PreferencesInfo.Add("Check For Signatures Before Running Scan            : " +         $Preferences.CheckForSignaturesBeforeRunningScan          )
$PreferencesInfo.Add("Cloud Block Level                                   : " +         $CloudBlockLevel                                          )
$PreferencesInfo.Add("Cloud Extended Timeout (Seconds)                    : " +         $Preferences.CloudExtendedTimeout                         )
$PreferencesInfo.Add("Computer ID                                         : " +         $Preferences.ComputerID                                   )
$PreferencesInfo.Add("Controlled Folder Access Allowed Applications       : " +         $Preferences.ControlledFolderAccessAllowedApplications    )
$PreferencesInfo.Add("Controlled Folder Access Protected Folders          : " +         $Preferences.ControlledFolderAccessProtectedFolders       )
$PreferencesInfo.Add("Disable Archive Scanning                            : " +         $Preferences.DisableArchiveScanning                       )
$PreferencesInfo.Add("Disable Auto Exclusions                             : " +         $Preferences.DisableAutoExclusions                        )
$PreferencesInfo.Add("Disable Behavior Monitoring                         : " +         $Preferences.DisableBehaviorMonitoring                    )
$PreferencesInfo.Add("Disable Block At First Seen                         : " +         $Preferences.DisableBlockAtFirstSeen                      )
$PreferencesInfo.Add("Disable Catchup Full Scan                           : " +         $Preferences.DisableCatchupFullScan                       )
$PreferencesInfo.Add("Disable Catchup Quick Scan                          : " +         $Preferences.DisableCatchupQuickScan                      )
$PreferencesInfo.Add("Disable Email Scanning                              : " +         $Preferences.DisableEmailScanning                         )
$PreferencesInfo.Add("Disable Intrusion Prevention System                 : " +         $Preferences.DisableIntrusionPreventionSystem             )
$PreferencesInfo.Add("Disable I/O AV Protection                           : " +         $Preferences.DisableIOAVProtection                        )
$PreferencesInfo.Add("Disable Privacy Mode                                : " +         $Preferences.DisablePrivacyMode                           )
$PreferencesInfo.Add("Disable Realtime Monitoring                         : " +         $Preferences.DisableRealtimeMonitoring                    )
$PreferencesInfo.Add("Disable Removable Drive Scanning                    : " +         $Preferences.DisableRemovableDriveScanning                )
$PreferencesInfo.Add("Disable Restore Point Scanning                      : " +         $Preferences.DisableRestorePoint                          )
$PreferencesInfo.Add("Disable Scanning Mapped Network Drives For Full Scan: " +         $Preferences.DisableScanningMappedNetworkDrivesForFullScan)
$PreferencesInfo.Add("Disable Scanning Network Files                      : " +         $Preferences.DisableScanningNetworkFiles                  )
$PreferencesInfo.Add("Disable Script Scanning                             : " +         $Preferences.DisableScriptScanning                        )
$PreferencesInfo.Add("Enable Controlled Folder Access                     : " +[boolean]$Preferences.EnableControlledFolderAccess                 )
$PreferencesInfo.Add("Enable Network Protection                           : " +[boolean]$Preferences.EnableNetworkProtection                      )
$PreferencesInfo.Add("Exclusion Extension                                 : " +         $Preferences.ExclusionExtension                           )
$PreferencesInfo.Add("Exclusion Path                                      : " +         $Preferences.ExclusionPath                                )
$PreferencesInfo.Add("Exclusion Process                                   : " +         $Preferences.ExclusionProcess                             )
$PreferencesInfo.Add("MAPS Reporting Membership                           : " +         $MAPSReporting                                            )
$PreferencesInfo.Add("PUA Protection                                      : " +[boolean]$Preferences.PUAProtection                                )
$PreferencesInfo.Add("Quarantine Purge Items After Delay (Days)           : " +         $Preferences.QuarantinePurgeItemsAfterDelay               )
$PreferencesInfo.Add("Randomize Schedule Task Times                       : " +         $Preferences.RandomizeScheduleTaskTimes                   )
$PreferencesInfo.Add("Real Time Scan Direction                            : " +         $RealTimeScanDirection                                    )
$PreferencesInfo.Add("Remediation Schedule Day                            : " +         $RemediationScheduleDay                                   )
$PreferencesInfo.Add("Remediation Schedule Time                           : " +         $Preferences.RemediationScheduleTime                      )
$PreferencesInfo.Add("Reporting Additional Action TimeOut                 : " +         $Preferences.ReportingAdditionalActionTimeOut             )
$PreferencesInfo.Add("Reporting Critical Failure TimeOut                  : " +         $Preferences.ReportingCriticalFailureTimeOut              )
$PreferencesInfo.Add("Reporting Non-Critical TimeOut                      : " +         $Preferences.ReportingNonCriticalTimeOut                  )
$PreferencesInfo.Add("Scan Avg CPU Load Factor                            : " +         $Preferences.ScanAvgCPULoadFactor                         )
$PreferencesInfo.Add("Scan Only If Idle Enabled                           : " +         $Preferences.ScanOnlyIfIdleEnabled                        )
$PreferencesInfo.Add("Scheduled Scan Type                                 : " +         $ScanParameter                                            )
$PreferencesInfo.Add("Scan Purge Items After Delay                        : " +         $Preferences.ScanPurgeItemsAfterDelay                     )
$PreferencesInfo.Add("Scan Schedule Day                                   : " +         $ScanScheduleDay                                          )
$PreferencesInfo.Add("Scan Schedule Quick Scan Time                       : " +         $Preferences.ScanScheduleQuickScanTime                    )
$PreferencesInfo.Add("Scan Schedule Time                                  : " +         $Preferences.ScanScheduleTime                             )
$PreferencesInfo.Add("Signature Au Grace Period                           : " +         $Preferences.SignatureAuGracePeriod                       )
$PreferencesInfo.Add("Signature Definition Update File Shares Sources     : " +         $Preferences.SignatureDefinitionUpdateFileSharesSources   )
$PreferencesInfo.Add("Signature Disable Update On Startup Without Engine  : " +         $Preferences.SignatureDisableUpdateOnStartupWithoutEngine )
$PreferencesInfo.Add("Signature Fallback Order                            : " +         $Preferences.SignatureFallbackOrder                       )
$PreferencesInfo.Add("Signature First Au Grace Period                     : " +         $Preferences.SignatureFirstAuGracePeriod                  )
$PreferencesInfo.Add("Signature Schedule Day                              : " +         $SignatureScheduleDay                                     )
$PreferencesInfo.Add("Signature Schedule Time                             : " +         $Preferences.SignatureScheduleTime                        )
$PreferencesInfo.Add("Signature Update Catchup Interval (Days)            : " +         $Preferences.SignatureUpdateCatchupInterval               )
$PreferencesInfo.Add("Signature Update Interval (Hours)                   : " +         $Preferences.SignatureUpdateInterval                      )
$PreferencesInfo.Add("Submit Samples Consent                              : " +         $SubmitSamplesConsent                         )
$PreferencesInfo.Add("Threat ID Default Action_Actions                    : " +         $Preferences.ThreatIDDefaultAction_Actions                )
$PreferencesInfo.Add("Threat ID Default Action ID's                       : " +         $Preferences.ThreatIDDefaultAction_Ids                    )
$PreferencesInfo.Add("UI Lockdown                                         : " +         $Preferences.UILockdown                                   )

$PreferencesInfo.Add(""                                                 )
$PreferencesInfo.Add("===================================="             )
$PreferencesInfo.Add("Default Threat Actions"                           )
$PreferencesInfo.Add("------------------------------------"             )
$PreferencesInfo.Add("Low Level Threat : " +$LowThreatDefaultAction     )
$PreferencesInfo.Add("Moderate Threat  : " +$ModerateThreatDefaultAction)
$PreferencesInfo.Add("High Level Threat: " +$HighThreatDefaultAction    )
$PreferencesInfo.Add("Severe Threat    : " +$SevereThreatDefaultAction  )
$PreferencesInfo.Add("Unknown Threat   : " +$UnknownThreatDefaultAction )
$PreferencesInfo.Add("===================================="             )
$PreferencesInfo.Add(""                                                 )

$PreferencesInfo.Add("====================================="                                            )
$PreferencesInfo.Add("Anti-Malware & Anti-Virus Status"                                                 )
$PreferencesInfo.Add("-------------------------------------"                                            )
$PreferencesInfo.Add("AM Engine Version                  : " + $MPStatus.AMEngineVersion                )
$PreferencesInfo.Add("AM Product Version                 : " + $MPStatus.AMProductVersion               )
$PreferencesInfo.Add("AM Service Enabled                 : " + $MPStatus.AMServiceEnabled               )
$PreferencesInfo.Add("AM Service Version                 : " + $MPStatus.AMServiceVersion               )
$PreferencesInfo.Add("Anti-Spyware Enabled               : " + $MPStatus.AntispywareEnabled             )
$PreferencesInfo.Add("Anti-Spyware Signature Age         : " + $MPStatus.AntispywareSignatureAge        )
$PreferencesInfo.Add("Anti-Spyware Signature Last Updated: " + $MPStatus.AntispywareSignatureLastUpdated)
$PreferencesInfo.Add("Anti-Spyware Signature Version     : " + $MPStatus.AntispywareSignatureVersion    )
$PreferencesInfo.Add("Anti-Virus Enabled                 : " + $MPStatus.AntivirusEnabled               )
$PreferencesInfo.Add("Anti-Virus Signature Age           : " + $MPStatus.AntivirusSignatureAge          )
$PreferencesInfo.Add("Anti-Virus Signature Last Updated  : " + $MPStatus.AntivirusSignatureLastUpdated  )
$PreferencesInfo.Add("Anti-Virus Signature Version       : " + $MPStatus.AntivirusSignatureVersion      )
$PreferencesInfo.Add("Behavior Monitor Enabled           : " + $MPStatus.BehaviorMonitorEnabled         )
$PreferencesInfo.Add("Full Scan Age                      : " + $MPStatus.FullScanAge                    )
$PreferencesInfo.Add("Full Scan End Time                 : " + $MPStatus.FullScanEndTime                )
$PreferencesInfo.Add("Full Scan Start Time               : " + $MPStatus.FullScanStartTime              )
$PreferencesInfo.Add("I/O AV Protection Enabled          : " + $MPStatus.IoavProtectionEnabled          )
$PreferencesInfo.Add("Last Full Scan Source              : " + $LastFullScanSource                      )
$PreferencesInfo.Add("Last Quick Scan Source             : " + $LastQuickScanSource                     )
$PreferencesInfo.Add("NIS Enabled                        : " + $MPStatus.NISEnabled                     )
$PreferencesInfo.Add("NIS Engine Version                 : " + $MPStatus.NISEngineVersion               )
$PreferencesInfo.Add("NIS Signature Age                  : " + $MPStatus.NISSignatureAge                )
$PreferencesInfo.Add("NIS Signature Last Updated         : " + $MPStatus.NISSignatureLastUpdated        )
$PreferencesInfo.Add("NIS Signature Version              : " + $MPStatus.NISSignatureVersion            )
$PreferencesInfo.Add("On Access Protection Enabled       : " + $MPStatus.OnAccessProtectionEnabled      )
$PreferencesInfo.Add("Quick Scan Age                     : " + $MPStatus.QuickScanAge                   )
$PreferencesInfo.Add("Quick Scan End Time                : " + $MPStatus.QuickScanEndTime               )
$PreferencesInfo.Add("Quick Scan Start Time              : " + $MPStatus.QuickScanStartTime             )
$PreferencesInfo.Add("Real-Time Protection Enabled       : " + $MPStatus.RealTimeProtectionEnabled      )
$PreferencesInfo.Add(""                                                                                 )

$PreferencesInfo.Add("====================================="                                            )
$PreferencesInfo.Add("Attach Surface Reduction Rules"                                                   )
$PreferencesInfo.Add("-------------------------------------"                                            )

foreach ($ASR_RuleGUID in $ASR_RuleGUIDs)
{
    $ASR_RuleName = Get-ASR_RuleName ($ASR_RuleGUID)
    $RuleState    = Get-ASR_RuleState($ASR_RuleGUID)

    $PreferencesInfo.Add($ASR_RuleName  + ": " + $RuleState)
}



$PreferencesInfo

# TODO: Email If:
# Definitions or signatures are more than 2 days old
# Threats Found
# AM or AV Disabled
# ComputerState <> 0
# Full scan age > 3

# Quick scan age > 1
