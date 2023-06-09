﻿#Requires -RunAsAdministrator

$SageSet = "StateFlags0099"
$Base = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\"
$Locations= @(
    "Active Setup Temp Folders"
    "BranchCache"
	"Content Indexer Cleaner"
	"Diagnostic Data Viewer database files"
    "Downloaded Program Files"
	"DownloadsFolder"
    "GameNewsFiles"
    "GameStatisticsFiles"
    "GameUpdateFiles"
	"Feedback Hub Archive log files"
    "Internet Cache Files"
    "Memory Dump Files"
	"Language Pack"
    "Offline Pages Files"
    "Old ChkDsk Files"
    "D3D Shader Cache"
    "Delivery Optimization Files"
    "Previous Installations"
    "Recycle Bin"
    "Service Pack Cleanup"
	"RetailDemo Offline Content"
    "Setup Log Files"
    "System error memory dump files"
    "System error minidump files"
    "Temporary Files"
    "Temporary Setup Files"
    "Temporary Sync Files"
    "Thumbnail Cache"
    "Update Cleanup"
    "Upgrade Discarded Files"
    "User file versions"
    "Windows Defender"
    "Windows Error Reporting Archive Files"
    "Windows Error Reporting Queue Files"
    "Windows Error Reporting System Archive Files"
    "Windows Error Reporting System Queue Files"
    "Windows ESD installation files"
    "Windows Upgrade Log Files"
	"Windows Reset Log Files"
	"Prefetch"
	"EdgeCache"
)

# -ea silentlycontinue will supress error messages
ForEach($Location in $Locations) {
    Set-ItemProperty -Path $($Base+$Location) -Name $SageSet -Type DWORD -Value 2 -ea silentlycontinue | Out-Null
}

# Do the clean-up. Have to convert the SageSet number
$Args = "/sagerun:$([string]([int]$SageSet.Substring($SageSet.Length-4)))"
Start-Process -Wait "$env:SystemRoot\System32\cleanmgr.exe" -ArgumentList $Args

# Remove the Stateflags
ForEach($Location in $Locations)
{
    Remove-ItemProperty -Path $($Base+$Location) -Name $SageSet -Force -ea silentlycontinue | Out-Null
}
