@echo off
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set path=.\server\rsm\logs\%YYYY%-%MM%-%DD%\
if not exist %path% mkdir %path%
set fileName=%HH%-%Min%-%Sec%.txt
cls
echo Starting Server...
RustDedicated.exe -batchmode -nographics -silent-crashes ^
+server.ip 0.0.0.0 ^
+server.port 28015 ^
+rcon.ip 0.0.0.0 ^
+rcon.port 28016 ^
+rcon.password "NOFAGS" ^
+app.port 28082 ^
+server.identity "rsm" ^
+server.level "Procedural Map" ^
+server.seed 7880972 ^
+server.worldsize 6000 ^
-LogFile "%path%%fileName%"
-silent-crashes
