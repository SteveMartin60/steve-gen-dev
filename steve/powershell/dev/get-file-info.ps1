CLS

#..............................................................................

#..............................................................................
Function Get-FileHashSha1($FilePath)
{
    Return Get-FileHash -Algorithm SHA1 $FilePath
}
#..............................................................................

#..............................................................................
Function Convert-BytesToSize
{
    [CmdletBinding()]
    Param([parameter(Mandatory=$False,Position=0)][int64]$Size)
    
    $Result = $null

    if(($Size -gt 1PB)                     ) {$NewSize = $([math]::Round(($Size / 1PB),2)); $Result = $NewSize.ToString() + "PB"}
    if(($Size -gt 1TB) -and ($Size -lt 1PB)) {$NewSize = $([math]::Round(($Size / 1TB),2)); $Result = $NewSize.ToString() + "TB"}
    if(($Size -gt 1GB) -and ($Size -lt 1TB)) {$NewSize = $([math]::Round(($Size / 1GB),2)); $Result = $NewSize.ToString() + "GB"}
    if(($Size -gt 1MB) -and ($Size -lt 1GB)) {$NewSize = $([math]::Round(($Size / 1MB),2)); $Result = $NewSize.ToString() + "MB"}
    if(($Size -gt 1KB) -and ($Size -lt 1MB)) {$NewSize = $([math]::Round(($Size / 1KB),2)); $Result = $NewSize.ToString() + "KB"}

    if ($Result-eq $null)
    {
        $NewSize = $([math]::Round($Size,2))
        $Result = $NewSize.ToString() + " Bytes"
    }

    Return $Result
}
#..............................................................................

#..............................................................................

$FilePath = "C:\Users\admin\Downloads\Win10_1709_English_x32.iso"

if (Test-Path $FilePath)
{
    Write-Host "Getting General Info for: "$FilePath
    $File = Get-Item $FilePath

    Write-Host "Getting Version Info..."
    $VersionInfo = $File.VersionInfo

    Write-Host "Getting Security Descriptor Info..."
    $ACL         = Get-Acl $File.FullName

    Write-Host "Getting Security Access Info..."
    $Access      = $ACL.Access

    Write-Host "Getting File Hash Info..."
    $FileHash    = Get-FileHash -Algorithm SHA1 $FilePath

    $Size        = Convert-BytesToSize $File.Length

    Write-Host "==========================="
    Write-Host "File Report"
    Write-Host "-----------"
    Write-Host "File Name: " $File.Name
    Write-Host "File Size: " $Size
    Write-Host "File Path: " $File.Directory
    Write-Host "---------------------------"

    Write-Host "LinkType         : " $File.LinkType
    Write-Host "Mode             : " $File.Mode
    Write-Host "Target           : " $File.Target
    Write-Host "Attributes       : " $File.Attributes
    Write-Host "CreationTime     : " $File.CreationTime
    Write-Host "CreationTimeUtc  : " $File.CreationTimeUtc
    Write-Host "Exists           : " $File.Exists
    Write-Host "Extension        : " $File.Extension
    Write-Host "FullName         : " $File.FullName
    Write-Host "IsReadOnly       : " $File.IsReadOnly
    Write-Host "LastAccessTime   : " $File.LastAccessTime
    Write-Host "LastAccessTimeUtc: " $File.LastAccessTimeUtc
    Write-Host "LastWriteTime    : " $File.LastWriteTime
    Write-Host "LastWriteTimeUtc : " $File.LastWriteTimeUtc
    Write-Host "PSChildName      : " $File.PSChildName
    Write-Host "PSIsContainer    : " $File.PSIsContainer
    Write-Host "PSParentPath     : " $File.PSParentPath
    Write-Host "PSPath           : " $File.PSPath
    Write-Host "PSProvider       : " $File.PSProvider
    Write-Host "BaseName         : " $File.BaseName
    Write-Host
    Write-Host "------------------"
    Write-Host "Hash Info"
    Write-Host "------------------"
    Write-Host "Hash          ： "    $FileHash.Hash
    Write-Host "Hash Algorithm： "    $FileHash.Algorithm

    Write-Host "------------------"
    Write-Host "Version Info"
    Write-Host "------------------"

    Write-Host "Comments          ： "    $VersionInfo.Comments
    Write-Host "CompanyName       ： "    $VersionInfo.CompanyName
    Write-Host "FileBuildPart     ： "    $VersionInfo.FileBuildPart
    Write-Host "FileDescription   ： "    $VersionInfo.FileDescription
    Write-Host "FileMajorPart     ： "    $VersionInfo.FileMajorPart
    Write-Host "FileMinorPart     ： "    $VersionInfo.FileMinorPart
    Write-Host "FileName          ： "    $VersionInfo.FileName
    Write-Host "FilePrivatePart   ： "    $VersionInfo.FilePrivatePart
    Write-Host "FileVersion       ： "    $VersionInfo.FileVersion
    Write-Host "InternalName      ： "    $VersionInfo.InternalName
    Write-Host "IsDebug           ： "    $VersionInfo.IsDebug
    Write-Host "IsPatched         ： "    $VersionInfo.IsPatched
    Write-Host "IsPreRelease      ： "    $VersionInfo.IsPreRelease
    Write-Host "IsPrivateBuild    ： "    $VersionInfo.IsPrivateBuild
    Write-Host "IsSpecialBuild    ： "    $VersionInfo.IsSpecialBuild
    Write-Host "Language          ： "    $VersionInfo.Language
    Write-Host "LegalCopyright    ： "    $VersionInfo.LegalCopyright
    Write-Host "LegalTrademarks   ： "    $VersionInfo.LegalTrademarks
    Write-Host "OriginalFilename  ： "    $VersionInfo.OriginalFilename
    Write-Host "PrivateBuild      ： "    $VersionInfo.PrivateBuild
    Write-Host "ProductBuildPart  ： "    $VersionInfo.ProductBuildPart
    Write-Host "ProductMajorPart  ： "    $VersionInfo.ProductMajorPart
    Write-Host "ProductMinorPart  ： "    $VersionInfo.ProductMinorPart
    Write-Host "ProductName       ： "    $VersionInfo.ProductName
    Write-Host "ProductPrivatePart： "    $VersionInfo.ProductPrivatePart
    Write-Host "ProductVersion    ： "    $VersionInfo.ProductVersion
    Write-Host "SpecialBuild      ： "    $VersionInfo.SpecialBuild
    Write-Host "FileVersionRaw    ： "    $VersionInfo.FileVersionRaw
    Write-Host "ProductVersionRaw ： "    $VersionInfo.ProductVersionRaw
    Write-Host
    Write-Host "------------------"
    Write-Host "Security Descriptor"
    Write-Host "------------------"
    Write-Host "CentralAccessPolicyId  : " $ACL.CentralAccessPolicyId
    Write-Host "CentralAccessPolicyName: " $ACL.CentralAccessPolicyName
    Write-Host "Group                  : " $ACL.Group
    Write-Host "Owner                  : " $ACL.Owner
    Write-Host "Path                   : " $ACL.Path
    Write-Host "AccessRightType        : " $ACL.AccessRightType
    Write-Host "AccessRuleType         : " $ACL.AccessRuleType
    Write-Host "AreAccessRulesCanonical: " $ACL.AreAccessRulesCanonical
    Write-Host "AreAccessRulesProtected: " $ACL.AreAccessRulesProtected
    Write-Host "AreAuditRulesCanonical : " $ACL.AreAuditRulesCanonical
    Write-Host "AreAuditRulesProtected : " $ACL.AreAuditRulesProtected
    Write-Host "AuditRuleType          : " $ACL.AuditRuleType
    Write-Host "PSChildName            : " $ACL.PSChildName
    Write-Host "PSParentPath           : " $ACL.PSParentPath
    Write-Host "PSPath                 : " $ACL.PSPath
    Write-Host "PSProvider             : " $ACL.PSProvider
    Write-Host "AuditToString          : " $ACL.AuditToString

    Write-Host
    Write-Host "------------------"
    Write-Host "Security Descriptor Access"
    Write-Host "------------------"

    $Access | Format-List
    Write-Host "==========================="
}
else
{
    Write-Host "File Not Found: " $FilePath
}