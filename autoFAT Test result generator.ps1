
if ($env:COMPUTERNAME = "SGSI11-59FKK13") {
    set-variable -name "path" -value "S:\RHID"
        } else {set-variable -name "path" -value "E:\RHID"}
 $sn = read-host "Enter Insutrment Serial Number, enter again to paste folder path"

if ($sn -eq '') {
  ($sn = read-host "Enter Folder Path") -and (set-variable -name "serverdir" -value "$sn")
} else {
    (set-variable -name "serverdir" -value "$path-$sn")
}

Write-Host "config" 6>$null
function config {
    Get-ChildItem "$serverdir" -I  MachineConfig.xml -R | Select-String "MachineName", "HWVersion", "MachineConfiguration", "DataServerUploadPath", "FluidicHomeOffset", 
    "PreMixHomeOffset", "DiluentHomeOffset", "SyringePumpStallCurrent", "SyringePumpResetCalibration", "LastBEC_TagID", "double", "RunsSinceLastGelFill", "DeliveredSamples", "LaserHours"
}

Write-Host "tc" 6>$null
function tc {
    Get-ChildItem "$serverdir" -I TC_Calibration.xml -R | Select-String "<Offsets>"
}

Write-Host "d" 6>$null
function d {
Get-ChildItem "$serverdir" -I  storyboard*.* -R | Select-String "SBH3","SBH4","BV2"
}

Write-Host "v" 6>$null
function v {
Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Estimated gel void volume"
}


Write-Host "p" 6>$null
function p {
Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Lysis Heater FAT", "DN FAT", "PCR FAT", "Optics Heater FAT", "Gel Cooling FAT","Ambient FAT", 
"SCI Sensor/CAM FAT", "FRONT END FAT", "MEZZ test", "LP FAT", "HP FAT", "Anode Motor FAT", "BEC Interlock FAT", "Bring Up: Gel Antenna", "Syringe Stallout FAT", "Mezzboard FAT",
 "Piezo FAT", "HV FAT", "Laser FAT", "Bring Up: Verify Raman" , "Bring Up: Lysate Pull Test" , "Bolus Devliery Test", "Lysis Volume", "Bring Up: Water Prime", "Bring Up: Buffer Prime"
}

config;tc
"Enter 'd' to show Critical Diagnostic Code"
"Enter 'v' to show Gel Void Volume"
"Enter 'p' to show Test Progress"   
"Enter d;p;v (with semi colon) to show all"


<#
Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Cartridge Type:     RHID_GFEControlCartridgePLUS",
"Cartridge Type:     RHID_NGMSampleCartridgePLUS","Cartridge Type:     RHID_GFESampleCartridgePLUS"
#>
<#$commands = {

    Write-Host "do some work"

    $again = Read-Host "again?"
    if ($again -eq "y"){
        &$commands
    } else {
        Write-Host "end"    
    }
}

&$commands #>
