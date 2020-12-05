@echo off
setlocal

if exist "%JAVA_HOME%\bin\javac.exe" goto execute
@rem echo No JDK found in JAVA_HOME

if not defined GRADLE_USER_HOME (
    set GRADLE_USER_HOME=%userprofile%\.gradle
)

set JAVA_HOME=%GRADLE_USER_HOME%\jdks\jdk-15.0.1+9
if exist "%JAVA_HOME%\bin\javac.exe" goto execute
@rem echo No JDK found in %GRADLE_USER_HOME%

@rem Installs AdoptOpenJdk into JAVA_HOME
echo This may take several minutes depending on your internet connection...
echo ...
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0install_adopt_open_jdk.ps1' -DestinationPath \"%GRADLE_USER_HOME%\jdks\""

:execute
cd "%~dp0..\app"
call gradlew.bat %*

endlocal
