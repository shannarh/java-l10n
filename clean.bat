@echo off

call scripts\gradle.bat clean
call scripts\gradle.bat --stop

pause
