"Instrument Name: $env:COMPUTERNAME"
set-variable -name "serverdir" -value "E:\RapidHIT ID"


Write-Host "config" 6>$null
function config {
    Get-ChildItem "$serverdir" -I  MachineConfig.xml, TC_Calibration.xml -R | Select-String "MachineName", "HWVersion", "MachineConfiguration", "DataServerUploadPath", "FluidicHomeOffset", 
    "PreMixHomeOffset", "DiluentHomeOffset", "SyringePumpStallCurrent", "SyringePumpResetCalibration", "LastBEC_TagID", "double", "RunsSinceLastGelFill", "DeliveredSamples", "LaserHours", "Offsets"
}

Write-Host "d" 6>$null
function d {
    Get-ChildItem "$serverdir" -I  storyboard*.* -R | Select-String "Critical diagnostics code"
}

Write-Host "v" 6>$null
function v {
    Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Estimated gel void volume"
}

Write-Host "p" 6>$null
function p {
    Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Lysis Heater FAT", "DN FAT", "PCR FAT", "Optics Heater FAT", "Gel Cooling FAT", "Ambient FAT", 
    "SCI Sensor/CAM FAT", "FRONT END FAT","Bring Up: FE Motor Calibration","Bring Up: FE Motor Test","Bring Up: Homing Error Test","Bring Up: FL Homing Error w/CAM Test","SCI Antenna Test", "MEZZ test", "LP FAT", "HP FAT", "Anode Motor FAT", "BEC Interlock FAT", "Bring Up: Gel Antenna", "Syringe Stallout FAT", "Mezzboard FAT",
    "Piezo FAT", "HV FAT", "Laser FAT", "Bring Up: Verify Raman" , "Bring Up: Lysate Pull Test" , "Bolus Devliery Test", "Lysis Volume", "Bring Up: Water Prime", "Bring Up: Buffer Prime"
}
config
"Enter 'd' to show Critical Diagnostic Code"
"Enter 'v' to show Gel Void Volume"
"Enter 'p' to show Test Progress"
"Enter d;p;v (semi colon included) to show all "

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