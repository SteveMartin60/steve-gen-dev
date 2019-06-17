CLS 

#..............................................................................

#..............................................................................

$DiacriticString = ""

#..............................................................................

#..............................................................................
function Remove-StringDiacritic
{
	[CMdletBinding()]
	param
	(
		[ValidateNotNullOrEmpty()]
		[Alias('Text')]
		[System.String[]]$String,
		[System.Text.NormalizationForm]$NormalizationForm = "FormD"
	)
	
	foreach ($StringValue in $String)
	{
		Write-Verbose -Message "$StringValue"
		try
		{	
			# Normalize the String
			$Normalized = $StringValue.Normalize($NormalizationForm)
			$NewString = New-Object -TypeName System.Text.StringBuilder
			
			# Convert the String to CharArray
			$normalized.ToCharArray() |
			ForEach-Object -Process {
				if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($psitem) -ne [Globalization.UnicodeCategory]::NonSpacingMark)
				{
					[void]$NewString.Append($psitem)
				}
			}

			#Combine the new string chars
			Write-Output $($NewString -as [string])
		}
		Catch
		{
			Write-Error -Message $Error[0].Exception.Message
		}
	}
}
#..............................................................................

#..............................................................................

$DiacriticsRemoved = Remove-StringDiacritic $DiacriticString

Remove-StringDiacritic "Amy Fāng"
Remove-StringDiacritic "Cathy Sūn"
Remove-StringDiacritic "Dennis Shào"
Remove-StringDiacritic "Eric Mă"
Remove-StringDiacritic "Kevin Zhāng"
Remove-StringDiacritic "Kristine Xú"
Remove-StringDiacritic "Leeyons Lǐ"
Remove-StringDiacritic "Leo Steiner"
Remove-StringDiacritic "Lisa Lǐ"
Remove-StringDiacritic "Léi Bīn"
Remove-StringDiacritic "Lí Qìng Wěi"
Remove-StringDiacritic "Mayo Yáng"
Remove-StringDiacritic "Monica Mò"
Remove-StringDiacritic "Nick Martin"
Remove-StringDiacritic "Peggie Shén"
Remove-StringDiacritic "Qín Chūn Huá"
Remove-StringDiacritic "Róng Lóng Jié"
Remove-StringDiacritic "Shén Jiàn"
Remove-StringDiacritic "Steve Martin"
Remove-StringDiacritic "Wáng Jiā"
Remove-StringDiacritic "Zhāng Wén Jìn"
Remove-StringDiacritic "Zōu Qìng Yǒu"

