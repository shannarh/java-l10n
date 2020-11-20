@echo off
setlocal

set JAVA_HOME="%userprofile%\.gradle\jdks\jdk-15.0.1+9"

if exist "%JAVA_HOME%\bin\java.exe" goto execute

@rem Runs 'internal.ps1' located in the same folder as this batch file
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0internal.ps1'"

:execute
cd java
call gradlew.bat run

endlocal
pause
