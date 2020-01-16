@ECHO OFF
CLS
echo.
echo.


ECHO 1.Restart
ECHO 2.Shutdown
ECHO 3.Close all Windows
ECHO 4.Log off
ECHO 5.Switch User
ECHO.

CHOICE /C 12345 /M "Enter your choice:"

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 5 GOTO SwitchUser
IF ERRORLEVEL 4 GOTO Logoff
IF ERRORLEVEL 3 GOTO CloseAllWindows
IF ERRORLEVEL 2 GOTO Shutdown
IF ERRORLEVEL 1 GOTO Restart

:Restart
ECHO Restart (put your restart code here)
GOTO End


:End