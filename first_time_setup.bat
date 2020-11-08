@ECHO OFF
REM Runs 'internal.ps1' located in the same folder as this batch file
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0internal.ps1'"
PAUSE
