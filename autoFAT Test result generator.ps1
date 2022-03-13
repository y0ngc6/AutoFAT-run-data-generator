$sn = read-host "Please enter serial number"
set-variable -name "serverdir" -value "E:\RHID-$sn"

Write-Host "config" -InformationAction Ignore
function config() {
Get-ChildItem "$serverdir"  -I  MachineConfig.xml, TC_Calibration.xml -R | Select-String "MachineName", "HWVersion", "MachineConfiguration", "DataServerUploadPath", "FluidicHomeOffset", 
    "PreMixHomeOffset", "DiluentHomeOffset", "SyringePumpStallCurrent", "SyringePumpResetCalibration", "LastBEC_TagID", "double", "Signature", "IsLinesPrimed", "LaserHours", "Offsets", "Water", "LysisBuffer", "LastGelPurgeOK", "DeliveredSamples"
}
Write-Host "essential" -InformationAction Ignore
function essential() {
Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Lysis Volume", "Ambient FAT"
}
Write-Host "d" -InformationAction Ignore
function d() {
    Get-ChildItem "$serverdir" -I  storyboard*.* -R | Select-String "Critical diagnostics code"
}

Write-Host "v" -InformationAction Ignore
function v() {
    Get-ChildItem "$serverdir" -I  storyboard*.* -R | Select-String "Estimated gel void volume"
}

Write-Host "p" -InformationAction Ignore
function p() {
    Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Lysis Heater FAT", "DN FAT", "PCR FAT", "Optics Heater FAT", "Gel Cooling FAT", 
    "SCI Sensor/CAM FAT", "FRONT END FAT", "MEZZ test", "LP FAT", "HP FAT", "Anode Motor FAT", "BEC Interlock FAT", "Bring Up: Gel Antenna", "Syringe Stallout FAT", "Mezzboard FAT",
    "Piezo FAT", "HV FAT", "Laser FAT", "Bring Up: Verify Raman" , "Bring Up: Lysate Pull Test" , "Bolus Devliery Test"
}
config;essential
<#set-Alias -Scope global -name diag -Value d
Set-Alias -Scope global -name void -Value v
Set-Alias -Scope global -name progress -Value p
config-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Cartridge Type:     RHID_GFEControlCartridgePLUS",
vCarvoidge Type:     RHID_NGMSampleCartridgePLUS","Cartridge Type:     RHID_GFESampleCartridgePLUS"
#>