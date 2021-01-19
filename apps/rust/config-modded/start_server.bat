@echo off
:start
cls
echo Starting Server...
RustDedicated.exe -batchmode -nographics -silent-crashes ^
+server.headerimage "http://suparious.com/images/suparious_logo.png" ^
+server.url "https://suparious.com/" ^
+server.ip 0.0.0.0 ^
+server.port 28015 ^
+rcon.ip 0.0.0.0 ^
+rcon.port 28016 ^
+rcon.password "NOFAGS" ^
+app.port 28082 ^
+server.identity "rsm" ^
+server.level "Procedural Map" ^
+server.seed 280 ^
+server.worldsize 4500 ^
+server.saveinterval 300 ^
-LogFile "server\rsm\serverlog.log"
