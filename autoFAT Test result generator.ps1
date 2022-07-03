<#
Powershell AutoFAT test result generator
version: v0.3
Revision Date: 12 JUN 2022
#>

$name = $env:COMPUTERNAME
${get-date} = Get-date
${nlc} = Test-Path -Path "Non-linearity Calibration $name.PNG" -PathType Leaf
${waves} = Test-Path -Path "Waves $name.PNG" -PathType Leaf
${tc} = Test-Path -Path "TC_verification $name.TXT" -PathType Leaf


clear-host
if (
    $name -eq "SGSI11-59FKK13"
    )
{
    set-variable -name "path" -value "S:\RHID"
} else {
    set-variable -name "path" -value "U:\RHID"
}

$sn = read-host "
RapidHIT ID Powershell tools, v0.3,
Enter Insutrment Serial Number, format should be 0###, eg, 0485,
Enter again to search local folder E:\RapidHIT ID test result, should use within Instrument only,
Enter 1 to Paste folder path, can be folder in server or instrument local folder,
Enter 2 to Check production server Boxprep HIDAutolite License key,
Enter 3 to Check archived U.S. server Boxprep HIDAutolite License key,
Enter 4 to Create placeholder files to record TC temp data, Waves and Non-Linearity screenshots,
Enter 5 to Backup Instrument config and calibrated TC data to Local server,
Enter 6 to Backup Instrument runs data to server, for Pre-Boxprep or Backup before re-imaging the instrument,
Enter number to proceed"

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
    $sn -eq '2'
) {
    
        ($sn2 = read-host "Checking SG Productiom server Boxprep SoftGenetics License key, Enter Instrument Serial number"
            ) -and (
        set-variable -name "serverdir" -value "S:\Dano Planning\Test Data\RHID-$sn2"
            )
    
}
elseif (
    $sn -eq '3'
) {
    
        ($sn2 = read-host "Checking archived U.S. server Boxprep SoftGenetics License key, Enter Instrument Serial number"
            ) -and (
        set-variable -name "serverdir" -value "Y:\Dano Planning\Test Data\RHID-$sn2"
        )
}
elseif (
    $sn -eq '4'
) {
    Set-Location "E:\RapidHIT ID\Results"
    if ($nlc -eq $False) 
             {New-Item -Path "Non-linearity Calibration $name.PNG" -ItemType File
             Write-host "Created new file: Non-linearity Calibration $name.PNG"}
             else {
             Write-Host "File: 'Non-linearity Calibration $name.PNG' exists, skipping"
             Write-host File size is: (Get-Item "Non-linearity Calibration $name.PNG" | % {[math]::ceiling($_.length/1KB)}) KB
             }
    if ($waves -eq $False) 
             {New-Item -Path "Waves $name.PNG" -ItemType File
             Write-host "Created new file: Waves $name.PNG"}
             else {Write-Host "File: 'Waves $name.PNG' exists, skipping"
             Write-host File size is: (Get-Item "Waves $name.PNG" | % {[math]::ceiling($_.length/1KB)}) KB
             }
    if ($tc -eq $False) 
            {Write-Output "Instrument SN: $env:COMPUTERNAME
    ${get-date}
    Ambient + Probe:   °C,    °C
    Temp + Humidity:   °C,    %
    TC Probe ID: M
    Stage 1:   °C
    Stage 2:   °C
    Stage 3:   °C
    Stage 4:   °C
    Airleak Test: NA/Passed
    " >> "TC_verification $name.TXT"
    Write-host "Created new file: TC_verification $name.TXT"}
    else {Write-Host "File: 'TC_verification $name.TXT' exists, skipping"}
    notepad.exe "TC_verification $name.TXT"
    #%windir%\system32\SnippingTool.exe
    #C:\"Program Files (x86)\RGB Lasersystems"\Waves\Waves.exe
}
elseif (
    $sn -eq '5'
) {
    mkdir U:\"$name\Internal\RapidHIT ID"\Results\
    Copy-Item E:\"RapidHIT ID"\*.xml U:\"$name\Internal\RapidHIT ID"\
    Copy-Item E:\"RapidHIT ID"\Results\*.PNG , E:\"RapidHIT ID"\Results\*.TXT U:\"$name\Internal\RapidHIT ID"\Results\
}
elseif (
    $sn -eq '6'
) {
    mkdir U:\"$name\Internal\RapidHIT ID"\Results\
    Copy-Item -Force -Recurse -Exclude "System Volume Information","*RECYCLE.BIN","bootsqm.dat" "E:\*" -Destination U:\"$name"\Internal\
}
elseif (
    $sn -eq ''
)
{ set-variable -name "serverdir" -value "E:\RapidHIT ID" }
else 
{ set-variable -name "serverdir" -value "$path-$sn" }

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
    Get-ChildItem "$serverdir" -I storyboard*.* -R | Select-String  "Gel syringe record" , "Cartridge Type" , "ID Number" , "Estimated gel void volume"
}

<#"Cartridge Type" , "ID Number"#>
Write-Host "p" 6>$null
function p {
    Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Lysis Heater FAT", "DN FAT", "PCR FAT", "Optics Heater FAT", "Gel Cooling FAT", "Ambient FAT", 
    "SCI Sensor/CAM FAT", "FRONT END FAT", "Bring Up: FE Motor Calibration", "Bring Up: FE Motor Test", "Bring Up: Homing Error Test", "Bring Up: FL Homing Error w/CAM Test", "SCI Antenna Test",
    "MEZZ test", "LP FAT", "HP FAT", "Anode Motor FAT", "BEC Interlock FAT", "Bring Up: Gel Antenna", "Syringe Stallout FAT", "Mezzboard FAT",
    "Piezo FAT", "HV FAT", "Laser FAT", "Bring Up: Verify Raman" , "Bring Up: Lysate Pull Test", "Lysis Volume", "Bring Up: Water Prime", " Bring Up: Lysis Prime", "Bring Up: Buffer Prime", "Bring Up: Capillary Gel Prime"
}

Write-Host "pd" 6>$null
function pd {
    Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Lysis Heater FAT: PASS", "DN FAT: PASS", "PCR FAT: PASS", "Optics Heater FAT: PASS", "Gel Cooling FAT", "Ambient FAT", 
    "SCI Sensor/CAM FAT", "FRONT END FAT", "MEZZ test", "LP FAT", "HP FAT", "Anode Motor FAT", "BEC Interlock FAT", "Bring Up: Gel Antenna", "Syringe Stallout FAT", "Mezzboard FAT",
    "Piezo FAT", "HV FAT", "Laser FAT", "Bring Up: Verify Raman" , "Bring Up: Lysate Pull Test" , "Lysis Volume", "Bring Up: Water Prime", " Bring Up: Lysis Prime", "Bring Up: Buffer Prime", "Bring Up: Capillary Gel Prime"
}

Write-Host "c" 6>$null
function c {
    "Instrument S/N: $env:COMPUTERNAME"
    Get-ChildItem "$serverdir" -I  MachineConfig.xml, TC_Calibration.xml -R | Select-String "MachineName", "HWVersion", "MachineConfiguration", "DataServerUploadPath", "<HP_HardstopZeroForce_mm>", "<HP_Hardstop100Percent_mm>",
    "FluidicHomeOffset", "PreMixHomeOffset", "DiluentHomeOffset", "SyringePumpStallCurrent", "SyringePumpResetCalibration", "LastBEC_TagID", "double", "RunsSinceLastGelFill", "DeliveredSamples", "LaserHours", "<Offsets>"
    Get-ChildItem "$serverdir\Internal\RapidHIT ID" -I  TC_verification*.* -R  | Select-String "Temp" , "Ambient" , "TC Probe ID", "Stage", "Airleak"
}

Write-Host "e" 6>$null
function e {
      ($custom = read-host "Enter specific text to search, for example 'Q-mini serial number: 2531',
Optics Monitor, Raman line Gaussian fit, etc, seach range limited to Storyboard, MachineConfig, TC Calibation and Boxpreplog") -and (set-variable -name "custom" -value "$custom")
    Get-ChildItem "$serverdir"  -I  storyboard*.* , MachineConfig.xml, TC_Calibration.xml, *BoxPrepLog_RHID* -R | Select-String "$custom"
}

Write-Host "b" 6>$null
function b {
    Get-ChildItem "$serverdir"  -I  storyboard*.* -R | Select-String "Bolus Devliery Test", "% in DN", "Volume  =", "Timing =", "Bolus Current"
}

Write-Host "b2" 6>$null
function b2 {
    Get-ChildItem "$serverdir\*Bolus Delivery Test*"  -I  storyboard*.* -R | Select-String "Bolus Devliery Test", "% in DN", "Volume  =", "Timing =", "Bolus Current"
}
Write-Host "t" 6>$null
function t {
    Get-ChildItem "$serverdir"  -I DannoGUIState.xml -R | Select-String "<UserName>", "<RunStartAmbientTemperatureC>", "<RunEndAmbientTemperatureC>", "<RunStartRelativeHumidityPercent>", "<RunEndRelativeHumidityPercent>"
}

Write-Host "i" 6>$null
function i {
    Get-ChildItem "$serverdir"  -I execution_withLadders.log -R | Select-String "Error", "Your trial has"
}

Write-Host "j" 6>$null
function j {
    Get-ChildItem "$serverdir"  -I *BoxPrepLog_RHID* -R  -Exclude "*.log" | Select-String "SoftGenetics License number provided is"
}

Write-Host "w" 6>$null
function w {
    Get-WmiObject Win32_BaseBoard
    Get-WmiObject win32_physicalmemory | Format-Table Manufacturer,Banklabel,Configuredclockspeed,Devicelocator,Capacity,Serialnumber -autosize
    Get-Timezone
}

Write-Host "h2" 6>$null
function h2 {
    Clear-Host
    Write-Host "
Enter 'e'  to search specific text,
Enter 'd'  to show Critical Diagnostic Code,
Enter 'v'  to show Gel Void Volume,
Enter 'v2' to show Gel Void Volume with BEC ID,
Enter 'p'  to show Test Progress,
Enter 'b'  to show only Bolus test result in server,
Enter 'b2' to show all Bolus test result,
Enter 't'  to show temp and humidity data fron DannoGUI,
Enter 'i'  to show HIDAuto Lite 2.9.5 for IntegenX trail license status,
Enter 'j'  to show Boxprep SoftGenetics License activation status,
Enter 'w'  to show Istrument hardware info, Timezone setting,

Enter 'h2' to clear screen and show this list of commands

Getting data from folder $serverdir"
}

Write-host "Enter h2 to show list of commands"

<#
RHID_GFESampleCartridgePLUS = PURPLE CARTRIDGE
RHID_GFEControlCartridgePLUS = BLUE CARTRIDGE / ALLELIC LADDER
RHID_NGMSampleCartridgePLUS = GREEN CARTRIDGE
RHID_PrimaryCartridge_V4 = BEC
RHID_GelSyringe = GEL

$commands = {

    Write-Host "do some work"

    $again = Read-Host "again?"
    if ($again -eq "y"){
        &$commands
    } else {
        Write-Host "end"    
    }
}

&$command #>
