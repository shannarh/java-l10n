@echo off

call .\gradle.bat clean --no-daemon
call .\gradle.bat --stop

pause
