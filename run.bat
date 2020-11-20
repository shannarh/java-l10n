@echo off
setlocal

set JAVA_HOME="%~dp0\jdk-15.0.1+9"
set JAVA_EXE=%JAVA_HOME%/bin/java.exe

if exist "%JAVA_EXE%" goto execute

call first_time_setup.bat

:execute
cd java
call gradlew.bat run

endlocal
pause
