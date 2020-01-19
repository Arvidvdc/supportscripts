@ECHO OFF
CLS
REM #############################################################
REM ##########################-VMDISK-###########################
REM #############################################################
REM #                                     script version v1.0.0 #
REM #                                                           #
REM # v1.0.0 Arivd:                                             #
REM # This script simplifies de-fragmentation and shrinking of  #
REM # VNWare's virtual disks.                                   #
REM # 1) Make a choice, only defrag, only shrink if both.       #
REM # 2)Enter path and filename and hit enter.                  #
REM #                                                           #
REM # BE AWARE:                                                 #
REM # * Both defrag and shrinking consumes lots of time         #
REM #   depending the VMDisk's size.                            #
REM # * Both processes need at least equal free disk space as   #
REM #   the size of the VMDisk.                                 #
REM #                                                           #
REM #############################################################
REM #############################################################

REM Setting variables
SET virtualDiskManager=c:\Utilities\VMWare Diskmanager\vdiskmanager.exe
SET disk=Asked lateron in script.

:menu
REM Menu
SET skip=0
CLS
ECHO.
ECHO    OPTION             DESCRIPTION
ECHO -----------------------------------------------------------------
ECHO 1. Defrag           : Defrags the VMDisk.
ECHO 2. Shrink           : Shrinks the VMDisk.
ECHO 3. Complete         : Defrags the VMDisk before shrinking it.
ECHO.
ECHO Q. Quit             : End script.

SET /P C=[0,1,2,3,Q,q]? > NUL

IF "%C%"=="0" GOTO skip
IF /I "%C%"=="Q" GOTO EoS
CALL :requestDisk
IF "%C%"=="1" GOTO diskDefrag
IF "%C%"=="2" GOTO diskShrink
IF "%C%"=="3" (
    SET skip=1
    GOTO diskComplete
)

:skip
ECHO.
ECHO Display variables value:
ECHO virtualDiskManager : %virtualDiskManager%
ECHO disk               : %disk%
ECHO skip               : %skip%
ECHO errorDependencies  : %errorDependencies%
ECHO.
PAUSE
GOTO menu

:diskDefrag
REM Defragging disk
ECHO.
ECHO Defragmentation:
"%virtualDiskManager%" -d "%disk%"
IF %skip%==1 EXIT /B
ECHO.
PAUSE
GOTO menu

:diskShrink
REM Shrinking disk
ECHO.
ECHO Shrinking:
"%virtualDiskManager%" -k "%disk%"
IF %skip%==1 EXIT /B
ECHO.
PAUSE
GOTO menu

:diskComplete
REM Both defrag and shrink disk
CALL :diskDefrag
CALL :diskShrink
ECHO.
PAUSE
GOTO menu

:ControleApps
REM Dependencies check
SET errorDependencies=0
IF NOT EXIST %virtualDiskManager% (
    ECHO      NOT FOUND: %virtualDiskManager%
    SET errorDependencies=1
)
IF NOT EXIST %disk% (
    ECHO      NOT FOUND: %disk%
    SET errorDependencies=1
)
IF %errorDependencies% EQU 1 (
    ECHO.
    PAUSE
    GOTO EoS
)
EXIT /B

:requestDisk
REM Retrieve target path and filename
ECHO.
set submit=
set /P submit=Enter the name of the VMDisk and it's path     : [] 
if not "%submit%"=="" set disk=%submit%
EXIT /B

:EoS
ECHO.
ECHO Script finished.
ECHO.
EXIT