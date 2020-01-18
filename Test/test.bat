@echo off

goto Netwerk

:Test001
SET target=\\sarge-domain\Backup\Systemen\SARgE-DOMAIN\_Shares\Images
For %%A in ("%target%") do (
    Set zipFile=%%~nA
)

echo %target%\%zipFile%.7z

:Netwerk
SET logFile=Test001.log
SET copyTool=\\SARgE-DOMAIN\Backup\_scriptAndTools\FastCopy
SET compressieTool=\\SARgE-DOMAIN\Backup\_scriptAndTools\7zip

ECHO       _Shares sectie. >> %logFile%
ECHO Verwerken _Shares...
REM Images
SET source=\\SARgE-DOMAIN\images
SET target=\\sarge-domain\Backup\Systemen\SARgE-DOMAIN\_Shares\Images
CALL :ExecuteBackUp
REM Public
SET source=\\SARgE-DOMAIN\Public
SET target=\\sarge-domain\Backup\Systemen\SARgE-DOMAIN\_Shares\Public
CALL :ExecuteBackUp
REM SerieTool
SET source=\\SARgE-DOMAIN\SerieTool
SET target=\\sarge-domain\Backup\Systemen\SARgE-DOMAIN\_Shares\SerieTool
CALL :ExecuteBackUp
REM Server
REM SET source=\\SARgE-DOMAIN\Server
REM SET target=\\sarge-domain\Backup\Systemen\SARgE-DOMAIN\_Shares\Server
REM CALL :ExecuteBackUp
REM wwwroot
SET source=\\SARgE-DOMAIN\wwwroot
SET target=\\sarge-domain\Backup\Systemen\SARgE-DOMAIN\_Shares\wwwroot
CALL :ExecuteBackUp
REM SYSVOL
SET source=\\SARgE-DOMAIN\SYSVOL
SET target=\\sarge-domain\Backup\Systemen\SARgE-DOMAIN\_Shares\SYSVOL
CALL :ExecuteBackUp

REM _Homefolders
ECHO       _Homefolders sectie. >> %logFile%
REM Administrator
SET source=\\SARgE-DOMAIN\Administrator
SET target=\\sarge-domain\Backup\Systemen\SARgE-DOMAIN\_Users\Administrator
CALL :ExecuteBackUp
REM Kodi
SET source=\\SARgE-DOMAIN\Kodi
SET target=\\sarge-domain\Backup\Systemen\SARgE-DOMAIN\_Users\Kodi
CALL :ExecuteBackUp
REM Lisanne
SET source=\\SARgE-DOMAIN\Lisanne
SET target=\\sarge-domain\Backup\Systemen\SARgE-DOMAIN\_Users\Lisanne
CALL :ExecuteBackUp
REM SARgE
REM SET source=\\SARgE-DOMAIN\SARgE
REM SET target=\\sarge-domain\Backup\Systemen\SARgE-DOMAIN\_Users\SARgE
CALL :ExecuteBackUp
REM Thirza
SET source=\\SARgE-DOMAIN\Thirza
SET target=\\sarge-domain\Backup\Systemen\SARgE-DOMAIN\_Users\Thirza
CALL :ExecuteBackUp
GOTO EoS

:ExecuteBackUp
ECHO      %source% >> %logFile%
ECHO      ##### Kopieren bestanden. >> %logFile%
ECHO      Kopieren %source%...
START /w "FastCopy %source%" %copyTool%\FastCopy /bufsize=512 /error_stop=FALSE /estimate /force_close /no_ui /logfile=%LogFile% "%source%\*" /to="%target%"
ECHO. >> %logFile%
ECHO      ##### Comprimeren bestanden. >> %logFile%
ECHO      Comprimeren...
%CompressieTool%\7z.exe a -mx9 "%target%.7z" "%target%" -r -y >> %logFile%
ECHO. >> %logFile%
ECHO      ##### Verwijderen bestanden. >> %logFile%
ECHO      Opruimen tijdelijke bestanden...
START /w "Fastcopy delete %source%" %copyTool%\FastCopy /cmd=delete /bufsize=512 /error_stop=FALSE /estimate /force_close /no_ui /logfile=%LogFile% "%target%\*"
EXIT /B
:EoS
ECHO.
ECHO Het script is afgesloten.
ECHO.