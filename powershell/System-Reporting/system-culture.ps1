CLS

#..............................................................................

#..............................................................................

$Culture = Get-Culture

$Today = Get-Date -UFormat "%Y-%m-%d %H:%M:%S"

$Languages    = @()

$CultureInfo  = New-Object Object
$Languages    = Get-WinUserLanguageList

$CultureInfoTemp = @{}

$CultureInfo = {$CultureInfoTemp}.Invoke()

$CultureInfo.Add("========================================"                                   )
$CultureInfo.Add("Computer Culture Report"                                                    )
$CultureInfo.Add("========================================"                                   )
$CultureInfo.Add(""                                                                           )
$CultureInfo.Add("========================================"                                   )
$CultureInfo.Add("Report Summary"                                                             )
$CultureInfo.Add("----------------------------------------"                                   )
$CultureInfo.Add("Computer Name: " + $Env:COMPUTERNAME                                            )
$CultureInfo.Add("Command      : Get-Culture"                                                 )
$CultureInfo.Add("Report Date  : " + $Today                                                   )
$CultureInfo.Add("----------------------------------------"                                   )
$CultureInfo.Add(""                                                                           )
$CultureInfo.Add("Parent                        : " +  $Culture.Parent                        )
$CultureInfo.Add("LCID                          : " +  $Culture.LCID                          )
$CultureInfo.Add("Keyboard Layout Id            : " +  $Culture.KeyboardLayoutId              )
$CultureInfo.Add("Name                          : " +  $Culture.Name                          )
$CultureInfo.Add("IETF Language Tag             : " +  $Culture.IetfLanguageTag               )
$CultureInfo.Add("Display Name                  : " +  $Culture.DisplayName                   )
$CultureInfo.Add("Native Name                   : " +  $Culture.NativeName                    )
$CultureInfo.Add("English Name                  : " +  $Culture.EnglishName                   )
$CultureInfo.Add("Two Letter ISO Language       : " +  $Culture.TwoLetterISOLanguageName      )
$CultureInfo.Add("Three Letter ISO Language     : " +  $Culture.ThreeLetterISOLanguageName    )
$CultureInfo.Add("Three Letter Windows Language : " +  $Culture.ThreeLetterWindowsLanguageName)
$CultureInfo.Add("Compare Info                  : " +  $Culture.CompareInfo                   )
$CultureInfo.Add("Text Info                     : " +  $Culture.TextInfo                      )
$CultureInfo.Add("Is Neutral Culture            : " +  $Culture.IsNeutralCulture              )
$CultureInfo.Add("Culture Types                 : " +  $Culture.CultureTypes                  )
$CultureInfo.Add("Number Format                 : " +  $Culture.NumberFormat                  )
$CultureInfo.Add("Date-Time Format              : " +  $Culture.DateTimeFormat                )
$CultureInfo.Add("Calendar                      : " +  $Culture.Calendar                      )
$CultureInfo.Add("Optional Calendars            : " +  $Culture.OptionalCalendars             )
$CultureInfo.Add("Use User Override             : " +  $Culture.UseUserOverride               )
$CultureInfo.Add("Is Read Only                  : " +  $Culture.IsReadOnly                    )
$CultureInfo.Add(""                                   )
$CultureInfo.Add("--------------------------"                                   )
$CultureInfo.Add("Languages"                                                 )
$CultureInfo.Add("--------------------------"                                   )

foreach($Language in $Languages)
{
    $CultureInfo.Add($Language)
}

$CultureInfo | Out-File "system-culture.txt"
