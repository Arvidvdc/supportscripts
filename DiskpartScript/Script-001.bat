@ECHO OFF
CLS
REM
REM Change workpath
cd "c:\Utilities\SARgE Scripts\DiskpartScript"

echo.
FOR /F "TOKENS=3,4 DELIMS= " %%A IN ('DIR ^| FIND /I "Directory of"') DO ECHO Working dir: %%A %%B

REM
REM Setting temp variables
set ListFile=VOLLIST.txt
set TempFile=VOLTEMP.txt
set ExtFile=VOLEXT.txt
set LogFile=LogFile.cro

REM
REM GET LIST OF VOLUMES AND EXPORT TO TEXT FILE TO BE RUN AS SCRIPT BY DISKPART
ECHO LIST volume>%ListFile%

REM
REM RUN TEXT FILE AS SCRIPT WITH DISKPART THEN EXPORT RESULTS TO NEW TEXT FILE
DISKPART /S %ListFile%>%TempFile%

REM
REM REMOVE THAT FIRST TEXT FILE WE CREATED
DEL %ListFile%

REM
REM Displays the results so you can enter desired volume
type %TempFile%
echo.

REM
REM Asks for volume and drive label
set /p strVolume=Geef volume op    : 
set /p strLabel=Geef een label op : 

REM TAKE THE LIST OF VOLUMES AND GET THE ONE YOU NEED WITH THE FIND COMMAND (MODIFY AS NEEDED)
REM THEN USE THE TOKENS/DELIMS TO GRAB JUST THE VOLUME NUMBER YOU WANT
REM AND CREATE ANOTHER TEXT FILE CONTAINING THE FINAL SCRIPT TO EXTEND THE VOLUME YOU WANT
FOR /F "TOKENS=2 DELIMS= " %%A IN ('TYPE %TempFile% ^| FIND /I "volume %strVolume%"') DO ECHO SELECT VOLUME %%A>%ExtFile%
FOR /F "TOKENS=3 DELIMS= " %%A IN ('TYPE %TempFile% ^| FIND /I "volume %strVolume%"') DO set strDriveLetter=%%A

REM
REM Information for the user
CLS
echo.
echo.
echo Your commands are executed...
echo.
echo.

REM
REM REMOVE THE SECOND TEXT FILE
DEL %TempFile%

REM
REM Adds aditional commands for DISKPART
ECHO CLEAN>>%ExtFile%
echo CREATE PARTITION PRIMARY>>%ExtFile%
echo FORMAT FS=NTFS LABEL="%strLabel%" QUICK>>%ExtFile%
echo ASSIGN LETTER=%strDriveLetter%>>%ExtFile%
ECHO EXIT>>%ExtFile%

REM
REM RUN DISKPART USING THE FINAL TEXT FILE AS THE SCRIPT
DISKPART /S %ExtFile%>%LogFile%
REM
REM REMOVE THE FINAL TEXT FILE SO NOTHING IS LEFT BEHIND AFTER SCRIPT EXECUTION
DEL %ExtFile%

REM
REM Copies the desierd autorun information to the new disk
echo. >>%LogFile%
xcopy auto* %strDriveLetter%: /H /E /Y>>%LogFile%
echo. >>%LogFile%
xcopy autorun\* %strDriveLetter%:\autorun /H /E /Y>>%LogFile%

ECHO All done.
ECHO View logfile: "%LogFile%"
PAUSE>nul