CLS

$FilePath = "C:\Program Files\Mozilla Firefox\firefox.exe"

$Arguments =  "-silent -nosplash -setDefaultBrowser"

Start-Process -FilePath $FilePath -ArgumentList $Arguments