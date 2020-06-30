CLS

#..............................................................................

#..............................................................................
Function ShowMessageBoxYesNo
{
   Param(
             [parameter(Mandatory=$True, Position=0)][string]$Message,
             [parameter(Mandatory=$True, Position=1)][string]$Title
        )

    $Result = [System.Windows.MessageBox]::Show($Message, $Title, [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Question)

    return $Result
}
#..............................................................................

#..............................................................................
Function ShowMessageBoxYesNoCancel
{
   Param(
             [parameter(Mandatory=$True, Position=0)][string]$Message,
             [parameter(Mandatory=$True, Position=1)][string]$Title
        )

    $Result = [System.Windows.MessageBox]::Show($Message, $Title, [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Question)

    return $Result
}
#..............................................................................

#..............................................................................
Function ShowMessageBoxInformation
{
   Param(
             [parameter(Mandatory=$True, Position=0)][string]$Message,
             [parameter(Mandatory=$True, Position=1)][string]$Title
        )

    $Result = [System.Windows.MessageBox]::Show($Message, $Title, [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Information)

    return $Result
}
#..............................................................................

#..............................................................................
Function ShowMessageBoxError
{
   Param(
             [parameter(Mandatory=$True, Position=0)][string]$Message,
             [parameter(Mandatory=$True, Position=1)][string]$Title
        )

    $Result = [System.Windows.MessageBox]::Show($Message, $Title, [System.Windows.MessageBoxButton]::Ok, [System.Windows.MessageBoxImage]::Error)

    return $Result
}
#..............................................................................

#..............................................................................

$MessageTitle = "Use Default Paths"
$MessageBody  = 'Would you like to use the default paths?' + "`r`n" + "Select '" 
$MessageBody  = 'Would you like to use the default paths?' + "`r`n" + "`r`n" + 'Select "No" to select a new SourcePath and a new Report Path' 

ShowMessageBoxYesNo $MessageBody $MessageTitle

