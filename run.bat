@echo off
setlocal
set JAVA_HOME="%~dp0\jdk-15.0.1+9
cd java
call gradlew.bat
endlocal
pause
