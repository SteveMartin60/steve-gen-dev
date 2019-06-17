@{

# Script module or binary module file associated with this manifest.
RootModule = 'Environment.psm1'

# Version number of this module.
ModuleVersion = '1.0.4'

# ID used to uniquely identify this module
GUID = 'fa42d62c-3f2a-426e-bb36-e1c6be2ff2e1'

# Author of this module
Author = 'Joel Bennett'

# Company or vendor of this module
CompanyName = 'HuddledMasses.org'

# Copyright statement for this module
Copyright = '(c) 2016 Joel Bennett. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Provides Trace-Message, and functions for working with Environment and Path variables'

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('Add-Path','Get-SpecialFolder','Select-UniquePath','Set-AliasToFirst','Set-EnvironmentVariable','Trace-Message')

FileList = @('.\Environment.psd1','.\Environment.psm1','.\en-US\about_Environment.help.txt')

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('Environment','Trace','Message')

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}




