@echo off
setlocal

set JAVA_HOME="%userprofile%\.gradle\jdks\jdk-15.0.1+9"

if exist "%JAVA_HOME%\bin\java.exe" goto execute

@rem Installs AdoptOpenJdk into JAVA_HOME
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0scripts\install_adopt_open_jdk.ps1'"

:execute
cd app
call gradlew.bat run

endlocal
pause
