<#
Powershell AutoFAT test result generator
version: v0.2
Revision Date: 08 APR 2022
#>

<# check the computer name and set correct path #>
if (
$env:COMPUTERNAME -eq "SGSI11-59FKK13"
) {
set-variable -name "path" -value "S:\RHID"
}
else {
set-variable -name "path" -value "U:\RHID"
}
$sn = read-host "
Enter Insutrment Serial Number, format should be 0###, eg, 0485
Enter again to search local folder E:\RapidHIT ID test result, should use within Instrument only
Enter 1 to paste folder path"


<# if instrument serial numer leave empty, paste direct folder path #>
if (
$sn -eq '1'
) {
  (
  $sn = read-host "Enter Folder Path"
  ) -and (
  set-variable -name "serverdir" -value "$sn"
  )
}
elseif (
$sn -eq ''
)
{set-variable -name "serverdir" -value "E:\RapidHIT ID"}
else 
{set-variable -name "serverdir" -value "$path-$sn"}

<# text string searching/filtering #>
Write-Host "d" 6>$null
function d {
Get-ChildItem "$serverdir" -I  storyboard*.* -R | Select-String "Critical diagnostics code"
}

Write-Host "v" 6>$null
function v {
    Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String  "Estimated gel void volume"
}
Write-Host "v2" 6>$null
function v2 {
    Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String  "Gel syringe record" , "Cartridge Type" , "ID Number" , "Estimated gel void volume"
}

<#"Cartridge Type" , "ID Number"#>
Write-Host "p" 6>$null
function p {
Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Lysis Heater FAT", "DN FAT", "PCR FAT", "Optics Heater FAT", "Gel Cooling FAT","Ambient FAT", 
"SCI Sensor/CAM FAT", "FRONT END FAT", "MEZZ test", "LP FAT", "HP FAT", "Anode Motor FAT", "BEC Interlock FAT", "Bring Up: Gel Antenna", "Syringe Stallout FAT", "Mezzboard FAT",
 "Piezo FAT", "HV FAT", "Laser FAT", "Bring Up: Verify Raman" , "Bring Up: Lysate Pull Test" , "Lysis Volume", "Bring Up: Water Prime", "Bring Up: Buffer Prime"
}

Write-Host "pd" 6>$null
function pd {
Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Lysis Heater FAT: PASS", "DN FAT: PASS", "PCR FAT: PASS", "Optics Heater FAT: PASS", "Gel Cooling FAT","Ambient FAT", 
"SCI Sensor/CAM FAT", "FRONT END FAT", "MEZZ test", "LP FAT", "HP FAT", "Anode Motor FAT", "BEC Interlock FAT", "Bring Up: Gel Antenna", "Syringe Stallout FAT", "Mezzboard FAT",
 "Piezo FAT", "HV FAT", "Laser FAT", "Bring Up: Verify Raman" , "Bring Up: Lysate Pull Test" , "Lysis Volume", "Bring Up: Water Prime", "Bring Up: Buffer Prime"
}

Write-Host "c" 6>$null
function c {
    $env:COMPUTERNAME
    Get-ChildItem "$serverdir" -I  MachineConfig.xml, TC_Calibration.xml -R | Select-String "MachineName", "HWVersion", "MachineConfiguration", "DataServerUploadPath", "<HP_HardstopZeroForce_mm>","<HP_Hardstop100Percent_mm>","FluidicHomeOffset", 
    "PreMixHomeOffset", "DiluentHomeOffset", "SyringePumpStallCurrent", "SyringePumpResetCalibration", "LastBEC_TagID", "double", "RunsSinceLastGelFill", "DeliveredSamples", "LaserHours", "<Offsets>"
}

Write-Host "e" 6>$null
function e {
      ($custom = read-host "Enter specific text to search, for example 'Q-mini serial number: 2531','Optics Monitor'") -and (set-variable -name "custom" -value "$custom")
    Get-ChildItem "$serverdir"  -I  storyboard*.* , MachineConfig.xml, TC_Calibration.xml -R | Select-String "$custom"
}

Write-Host "b" 6>$null
function b {
    Get-ChildItem "$serverdir\*Bolus Delivery*"  -I  storyboard*.* -R | Select-String "Bolus Devliery Test","% in DN","Volume  =","Bolus Current"
}



c
"
Enter 'e'  to search specific text,
Enter 'd'  to show Critical Diagnostic Code,
Enter 'v'  to show Gel Void Volume,
Enter 'v2' to show Gel Void Volume with BEC ID,
Enter 'p'  to show Test Progress,
Enter 'b'  to show Bolus test result,
Enter d;v;p;c (semi colon included) to show all,

d;c;p;v does not have to be in order
"
