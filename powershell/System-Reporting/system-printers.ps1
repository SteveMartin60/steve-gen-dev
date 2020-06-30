CLS

Get-WMIObject -Class Win32_PrinterConfiguration | Select-Object Name, Caption, PrintQuality, DriverVersion, PaperSize | Format-Table | Out-File "Printers.txt"