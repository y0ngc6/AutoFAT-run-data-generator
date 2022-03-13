$env:COMPUTERNAME
set-variable -name "serverdir" -value "E:\RapidHIT ID"
Get-ChildItem "$serverdir" -I storyboard*.* -R | Select-String "Critical diagnostics code"
PAUSE
Get-ChildItem "$serverdir"  -I  MachineConfig.xml -R | Select-String "MachineName", "HWVersion", "MachineConfiguration", "DataServerUploadPath", "FluidicHomeOffset",
"PreMixHomeOffset", "DiluentHomeOffset", "SyringePumpStallCurrent", "SyringePumpResetCalibration", "LastBEC_TagID", "SpectrometerCalibration"
Pause
Get-ChildItem "$serverdir"  -I  TC_Calibration.xml -R | Select-String "<Offsets>GFE", "<Offsets>NGM"
Pause
Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Lysis Heater FAT", "DN FAT", "PCR FAT", "Optics Heater FAT", "Gel Cooling FAT", "Ambient FAT",
"SCI Sensor/CAM FAT", "FRONT END FAT", "MEZZ test", "LP FAT", "HP FAT", "Anode Motor FAT", "BEC Interlock FAT", "Bring Up: Gel Antenna", "Syringe Stallout FAT", "Mezzboard FAT",
"Piezo FAT", "HV FAT", "Laser FAT", "Bring Up: Verify Raman" , "Bring Up: Lysate Pull Test" , "Bolus Devliery Test", "Lysis Volume"
pause
Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Estimated gel void volume"
pause
<#
Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Cartridge Type:     RHID_GFEControlCartridgePLUS",
"Cartridge Type:     RHID_NGMSampleCartridgePLUS", "Cartridge Type:     RHID_GFESampleCartridgePLUS"
pause
#>