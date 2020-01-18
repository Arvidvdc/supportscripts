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


"%virtualDiskManager%" -d "%schijf%"
"%virtualDiskManager%" -k "%schijf%"