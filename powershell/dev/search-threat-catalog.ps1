CLS

$ThreatCatalog = Get-MpThreatCatalog

$ThreatCatalog | Where-Object CategoryID -eq 33 | Select-Object ThreatName | Sort-Object ThreatName

$ThreatCatalog | Measure

$ThreatCatalog | Group-Object CategoryID | Sort-Object Count
