@Echo off
REM Clear screen
cls

REM setting variables
set scriptVersion=1.0
set logFile=%~dp0%~n0.log

Echo.
Echo.
Echo Starting SeriesTool with nodemon...
Echo.
Echo Using log file: %logFile%
Echo.
Echo.  >> %logFile%
Echo %date% - %time% >> %logFile%
Echo Changeing directory...
cd s:\documenten\github\SeriesTool >> %logFile%
Echo.
Echo current directory: %cd% >> %logFile%
Echo starting nodemon...
start /wait "Nodemom" /min /REALTIME "nodemon" >> %logFile% >> %logFile%
REM start /wait "Nodemom" "nodemon" >> %logFile% >> %logFile%
