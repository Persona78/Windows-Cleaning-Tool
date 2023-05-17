@echo off
title =Cleanning Tool=
setlocal EnableDelayedExpansion

rem BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    @echo. & @echo. & @echo [1m[31m	No Administrative rights, Execute as Administrator[0m
	@echo  Exiting in 5 Seconds
	TIMEOUT -T 5 /nobreak >nul
    exit /b
) else ( goto gotAdmin )
	
:gotAdmin

cls
CD /d "%~dp0"
@echo.
@echo [1m[32mStart Cleanning tool.[0m
@echo.
for %%a in (%systemdrive%\Users) do (
powershell.exe Clear-DnsClientCache
@echo [1m[33mClosing and restarting Explorer, Shutdown Locked files by restarting Windows Explorer.[0m
Taskkill /f /im Explorer.exe >nul
Start Explorer.exe >nul
Taskkill /f /im msedge.exe >nul
rem @echo Y|%systemroot%\System32\cleanmgr.exe /VERYLOWDISK >nul
@echo. [36m
@echo Creating cleanmgr new entries to clean. & @echo off
powershell.exe New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches' -Name 'Prefetch' -ErrorAction SilentlyContinue >nul
powershell.exe New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches' -Name 'EdgeCache' -ErrorAction SilentlyContinue >nul
@echo y|REG IMPORT "%~dp0reg.reg" >nul

@echo R|powershell.exe -File "%~dp01.ps1"

del /F /S /Q "%userprofile%\AppData\Local\Microsoft\Edge\User Data\Default\Cache\Cache_Data\*" >nul
del /F /S /Q "%SystemDrive%\temp\*" >nul
del /F /S /Q "%systemroot%\temp\*" >nul
del /F /S /Q "%systemroot%\Prefetch\*" >nul
del /f /s /q "%systemdrive%\*\*.tmp" >nul
del /f /s /q "%systemdrive%\*\*\*.tmp" >nul
del /f /s /q "%systemdrive%\*\*\*\*.tmp" >nul
del /f /s /q "%systemdrive%\*\*\*\*\*.tmp" >nul
del /f /s /q "%systemdrive%\*\*\*\*\*\*.tmp" >nul
del /f /s /q "%systemdrive%\*\*\*\*\*\*\*.tmp" >nul
del /f /s /q "%systemdrive%\*\*\*\*\*\*\*\*.tmp" >nul
del /F /S /Q "%temp%\*" >nul
del /F /S /Q "%temp%\*\*" >nul
del /F /S /Q "%temp%\*\*\*" >nul
del /F /S /Q "%temp%\*\*\*\*" >nul
del /F /S /Q "%temp%\*\*\*\*\*" >nul
del /F /S /Q "%temp%\*\*\*\*\*\*" >nul
)

endlocal
exit /b
