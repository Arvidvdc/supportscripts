@Echo off
REM Clear screen
cls

REM setting variables
set scriptVersion=1.0
set logFile="%~dp0%~n0.log"
set errFile="%~dp0%~n0.err"
set nodemon="c:\Users\Administrator\AppData\Roaming\npm\nodemon.cmd"
Echo.
Echo.
Echo Starting SeriesTool with nodemon...
Echo.
Echo Using log file: %logFile%
Echo Using error file: %errFile%
Echo.
Echo.  >> %logFile%
Echo %date% - %time% >> %logFile%
Echo.  >> %errFile%
Echo %date% - %time% >> %errFile%
echo path: %path% >> %logFile%
echo nodemon.cmd: %nodemon% >> %logFile%

Echo Changeing directory...
z: 
cd \_Shares\wwwroot\nodejs\seriestool >> %logFile% 2>> %errFile% 
Echo.
Echo current directory: %cd% >> %logFile%
Echo starting nodemon...
start /wait "Nodemon" /min /REALTIME %nodemon% >> %logFile% 2>> %errFile%
REM start /wait "Nodemom" "nodemon" >> %logFile% >> %logFile%
