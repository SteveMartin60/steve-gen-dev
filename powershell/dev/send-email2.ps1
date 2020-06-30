CLS

#..............................................................................

#..............................................................................
Function SendEmail
{
    $MyService = @()
    $EmailFrom = @()
    $Subject   = @()
    $Body      = @()

    $SMTPServer      = "smtp.sendgrid.net"
    $SMTPUsername    = "ShanghaiSteve"
    $SMTPPassword    = "multiply-Melodic-inks-972"
    $SMTPPort        = 587
    $AttachmentType  = "text/plain"
    $EmailFrom       = "system-reports@mesheven.com"
    $EmailTo         = "steve.martin@mesheven.com"
    $Subject         = "System Threat Report: " + $Computer
    $EmailAttachment = $ReportFile

    $Computer   =  $Env:COMPUTERNAME
    $SMTPServer = "smtp.sendgrid.net"
    $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)

    $SMTPClient.EnableSsl = $false

    $SMTPClient.Credentials = New-Object System.Net.NetworkCredential("ShanghaiSteve", "multiply-Melodic-inks-972");

    $EmailFrom = "system-reports@mesheven.com"
    $EmailTo   = "steve.martin@mesheven.com"
    $Subject   = "System Threat Report: " + $Computer
    $Body      = $EmailBody
    $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
}

SendEmail
