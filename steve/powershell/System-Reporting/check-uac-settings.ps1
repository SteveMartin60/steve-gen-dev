CLS

#..............................................................................

#..............................................................................
Function Set-AdminUserUacLevel($UacLevel)
{
    <#
        Admin Users UAC Settings
        Note that the default value is 5

        0 – Elevate without displaying the UAC prompt
        1 – Prompt for credentials on the secure desktop
        2 – Prompt for consent on the secure desktop
        3 – Prompt for credentials
        4 – Prompt for consent
        5 – Prompt for consent for non-Microsoft applications
    #>

    $ElevateNoPrompt                   = 0
    $SecureDesktopPromptCredentials    = 1
    $SecureDesktopPromptConsent        = 2
    $NonSecureDesktopPromptCredentials = 3
    $NonSecureDesktopPromptConsent     = 4
    $NonMicrosoftAppPromptConsent      = 5

    if    ($UacLevel -eq 0) {$BehaviorPrompt = $ElevateNoPrompt                  }
    elseif($UacLevel -eq 1) {$BehaviorPrompt = $SecureDesktopPromptCredentials   }
    elseif($UacLevel -eq 2) {$BehaviorPrompt = $SecureDesktopPromptConsent       }
    elseif($UacLevel -eq 3) {$BehaviorPrompt = $NonSecureDesktopPromptCredentials}
    elseif($UacLevel -eq 4) {$BehaviorPrompt = $NonSecureDesktopPromptConsent    }
    elseif($UacLevel -eq 5) {$BehaviorPrompt = $NonMicrosoftAppPromptConsent     }
    else                    {$BehaviorPrompt = $NonMicrosoftAppPromptConsent     }

    Set-ItemProperty -Path "$RegKey" -Name ConsentPromptBehaviorAdmin -Type DWORD -Value $BehaviorPrompt
}
#..............................................................................

#..............................................................................
Function Set-StandarsdUserUacLevel($UacLevel)
{
    <#
        Standard Users UAC Settings
        Note that the default value is 3

        0 – Automatically deny requests for elevated privileges
        1 – Prompt for credentials on the secure desktop
        3 – Prompt for credentials
    #>

    $AutoDenyElevation                 = 0
    $SecureDesktopPromptCredentials    = 1
    $NonSecureDesktopPromptCredentials = 3

    if    ($UacLevel -eq 0) {$BehaviorPrompt = $AutoDenyElevation                }
    elseif($UacLevel -eq 1) {$BehaviorPrompt = $SecureDesktopPromptCredentials   }
    elseif($UacLevel -eq 3) {$BehaviorPrompt = $NonSecureDesktopPromptCredentials}
    else                    {$BehaviorPrompt = $NonSecureDesktopPromptCredentials}

    Set-ItemProperty -Path "$RegKey" -Name ConsentPromptBehaviorUser -Type DWORD -Value $BehaviorPrompt
}
#..............................................................................

#..............................................................................
Function Force-SecureDesktop
{
    Set-ItemProperty -Path "$RegKey" -Name PromptOnSecureDesktop -Type DWORD -Value $true
}
#..............................................................................

#..............................................................................
Function Force-AllAdminUsersUAC
{
    Set-ItemProperty -Path "$RegKey" -Name EnableLUA -Type DWORD -Value $true
}
#..............................................................................

#..............................................................................
Function Force-CreateRegKey
{
    if (-Not(Test-Path "$RegKey"))
    {
        New-Item -Path "$($RegKey.TrimEnd($RegKey.Split('\')[-1]))" -Name "$($RegKey.Split('\')[-1])" -Force | Out-Null
    }
}
#..............................................................................

#..............................................................................
Function Set-UacDefaults
{
    Force-CreateRegKey
    Set-AdminUserUacLevel
    Set-StandarsdUserUacLevel
    Force-SecureDesktop
    Force-AllAdminUsersUAC
}
#..............................................................................

#..............................................................................
Function Get-UacSettings
{
    $UacSettings  = New-Object Object

    $UacSettingsTemp = @{}

    $UacSettings = {$UacSettingsTemp}.Invoke()
    
    $AllAdminUsersUAC           = (Get-ItemProperty -Path "$RegKey" -Name EnableLUA                 ).EnableLUA
    $PromptOnSecureDesktop      = (Get-ItemProperty -Path "$RegKey" -Name PromptOnSecureDesktop     ).PromptOnSecureDesktop
    $ConsentPromptBehaviorUser  = (Get-ItemProperty -Path "$RegKey" -Name ConsentPromptBehaviorUser ).ConsentPromptBehaviorUser  
    $ConsentPromptBehaviorAdmin = (Get-ItemProperty -Path "$RegKey" -Name ConsentPromptBehaviorAdmin).ConsentPromptBehaviorAdmin 

    if     ($ConsentPromptBehaviorAdmin -eq 0) {$ConsentPromptBehaviorAdmin = "Elevate without displaying the UAC prompt"        }
    elseif ($ConsentPromptBehaviorAdmin -eq 1) {$ConsentPromptBehaviorAdmin = "Prompt for credentials on the secure desktop"     }
    elseif ($ConsentPromptBehaviorAdmin -eq 2) {$ConsentPromptBehaviorAdmin = "Prompt for consent on the secure desktop"         }
    elseif ($ConsentPromptBehaviorAdmin -eq 3) {$ConsentPromptBehaviorAdmin = "Prompt for credentials"                           }
    elseif ($ConsentPromptBehaviorAdmin -eq 4) {$ConsentPromptBehaviorAdmin = "Prompt for consent"                               }
    elseif ($ConsentPromptBehaviorAdmin -eq 5) {$ConsentPromptBehaviorAdmin = "Prompt for consent for non-Microsoft applications"}
    else                                       {$ConsentPromptBehaviorAdmin = "Unknown Value"                                    }

    if     ($ConsentPromptBehaviorUser -eq 0) {$ConsentPromptBehaviorUser = "Automatically deny requests for elevated privileges"}
    elseif ($ConsentPromptBehaviorUser -eq 1) {$ConsentPromptBehaviorUser = "Prompt for credentials on the secure desktop"       }
    elseif ($ConsentPromptBehaviorUser -eq 3) {$ConsentPromptBehaviorUser = "Prompt for credentials"                             }
    else                                      {$ConsentPromptBehaviorUser = "Unknown Value"                                      }

    $UacSettings +=
    @{
         "All Admin Users UAC"           = [Boolean]$AllAdminUsersUAC
         "Consent Prompt Behavior Admin" = $ConsentPromptBehaviorAdmin 
         "Consent Prompt Behavior User"  = $ConsentPromptBehaviorUser  
         "Prompt On Secure Desktop"      = [Boolean]$PromptOnSecureDesktop      
     }

    Return $UacSettings
}
#..............................................................................

#..............................................................................

$RegKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

# Set-UacDefaults

Get-UacSettings | Out-File "E:\uac-settings.txt"

