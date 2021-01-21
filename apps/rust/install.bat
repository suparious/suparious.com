@echo off
echo Starting Server Installation...
steamcmd\steamcmd.exe +login anonymous +force_install_dir "C:\Users\Administrator\Downloads" +app_update 258550 +quit
echo --Done--
pause
