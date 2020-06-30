cls

$characters = 'ABCDEFGHKLMNPRSTUVWXYZ12345678901234567890'
$length     = 4

#..............................................................................

#..............................................................................
Function Get-RandomCharacters
{ 
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length } 

    $private:ofs="" 

    return [String]$characters[$random]
}
#..............................................................................

#..............................................................................
Function Scramble-String([string]$inputString)
{     
    $characterArray = $inputString.ToCharArray()   

    $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     

    $outputString = -join $scrambledStringArray

    return $outputString 
}
#..............................................................................

#..............................................................................
function GetPassword
{
    $string = ""

    $Password1 = RandomCharacters
    $Password2 = RandomCharacters

    $Password1S = Scramble-String($Password1)
    $Password2S = Scramble-String($Password2)

    $Password = "$Password1S-$Password2S"

    RETURN $Password
}
#..............................................................................

#..............................................................................


$Password = GetPassword

Set-Clipboard -Value $Password

echo "Password: $Password has been copied to the clipboard"
