@ECHO OFF
CLS
REM #############################################################
REM ##########################-VMDISK-###########################
REM #############################################################
REM #                                                           #
REM #                                                           #
REM #############################################################
REM #############################################################

REM Benodigde apps definiëren.
SET virtualDiskManager=c:\Utilities\VMWare Diskmanager\vdiskmanager.exe
SET schijf=d:\Virtual Machines\Windows Server 2016\Windows Server 2016.vmdk

:: Uitvragen van de benodigde gegevens
set invoer=
set /P invoer=Geef de map van de Virtuele Machine op     : [] 
if not "%invoer%"=="" set VMDir=%invoer%


:diskDefrag
"%virtualDiskManager%" -d "%schijf%"

:diskShrink
"%virtualDiskManager%" -k "%schijf%"

:ControleApps
SET errorDependencies=0
IF NOT EXIST %virtualDiskManager% (
    ECHO      %virtualDiskManager% Niet gevonden!
    SET errorDependencies=1
)
IF NOT EXIST %schijf% (
    ECHO      %schijf% Niet gevonden!
    SET errorDependencies=1
)
IF %errorDependencies% EQU 1 (
    ECHO.
    ECHO Druk op een toets.
    PAUSE > NUL
    GOTO EoS
)
EXIT /B

:EoS
CLS
ECHO.
ECHO Het script is afgesloten.
ECHO.
EXIT