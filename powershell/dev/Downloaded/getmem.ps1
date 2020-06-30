# Script name: getmem.ps1
# Author: Jeff Mason aka tnjman aka bitdoctor - Aug 9, 2013
# ORIGINAL CREDIT for base script to Jesse Hamrick at: http://www.powershellpro.com/dimm-witt/200/
# I modified & enhanced it, including correcting the 'ForEach' methods and cleaner formatting with blank lines + summary info
# PowerShell script to list Memory Slot Information & Detailed and Summary Memory Information for a remote computer, 
# including:
# 1) Total # of memory slots in the system
# 2) Each non-empty Memory Slot ID, along with Amount of Memory in the slot (in GB)
# [I added cleaner formatting via write-host "" (blank lines), plus output Computer name (strComputer) in various output]
# [I added all the items under #3]
# 3) Summary of Memory Slots populated, 
#   a) # of Total Slots remaining Available (open/unused)
#   b) # of Total Slots Filled (Used/unavailable)
#   c) Total Memory Populated/Installed (in GB)

write-host ""
$strComputer = Read-Host "Enter Computer Name to list memory slot information"
$colSlots = Get-WmiObject -Class "win32_PhysicalMemoryArray" -namespace "root\CIMV2" -computerName $strComputer
$colRAM = Get-WmiObject -Class "win32_PhysicalMemory" -namespace "root\CIMV2" -computerName $strComputer
$NumSlots = 0

write-host ""
$colSlots | ForEach {
      “Total Number of Memory Slots: ” + $_.MemoryDevices
      $NumSlots = $_.MemoryDevices
}

write-host ""
Read-Host "Press Enter to continue"

$SlotsFilled = 0
$TotMemPopulated = 0

$colRAM | ForEach {
       “Memory Installed: ” + $_.DeviceLocator
       “Memory Size: ” + ($_.Capacity / 1GB) + ” GB”       
       $SlotsFilled = $SlotsFilled + 1
       $TotMemPopulated = $TotMemPopulated + ($_.Capacity / 1GB)
#      if ($_.Capacity = 0)
#      {write-host "found free slot"}

}

write-host ""
write-host "=== Summary Memory Slot Info for computer:" $strComputer "==="
write-host ""
If (($NumSlots - $SlotsFilled) -eq 0)
   {
   write-host "ALL Slots Filled, NO EMPTY SLOTS AVAILABLE!"
   }
write-host ($NumSlots - $SlotsFilled) " of " $NumSlots " slots Open/Available (Unpopulated)"
write-host ($SlotsFilled) " of " $NumSlots " slots Used/Filled (Populated)."  
write-host ""
write-host "Total Memory Populated = " $TotMemPopulated "GB"

#