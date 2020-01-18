@ECHO OFF
CLS
REM #############################################################
REM ##########################-BACKUP-###########################
REM #############################################################
REM #                                                           #
REM # Soorten backup                                            #
REM #  - Netwerk (Bronnen van netwerk naar standaard backup     #
REM #    locatie kopiëren).                                     #
REM #  - Systeem (Gebruikersdata van betr. systeem naar         #
REM #    standaard locatie kopiëren).                           #
REM #  - Van standaard naar definitief (Gegevens verplaatsen    #
REM #    van standaard locatie naar verwisselbaar medium).      #
REM #  - Software (Het software archief moet bijgewerkt worden, #
REM #    (niets verwijderd).                                    #
REM #                                                           #
REM # Strategie:                                                #
REM # - Bepalen welk type backup moet draaien a.d.h. van een    #
REM #   keuzemenu.                                              #
REM # - Zo efficient mogelijk data transporteren.               #
REM # - Data comprimeren.                                       #
REM # - Op gewenst moment naar verwisselbare medium verplaatsen.#
REM #                                                           #
REM #############################################################
REM #############################################################

REM Benodigde apps definiëren.
SET copyTool=\\SARgE-DOMAIN\Backup\_scriptAndTools\FastCopy
SET compressieTool=\\SARgE-DOMAIN\Backup\_scriptAndTools\7zip

CALL :DatumTijdOpmaak

REM Benodigde variabelen definiëren.
SET systemName=%COMPUTERNAME%
SET source=Wordt bepaald na keuzemenu.
SET target=Wordt bepaald na keuzemenu.
SET basisPad=%~dp0
SET basisPad=%basisPad:~0,-1%
SET scriptFile=%~nx0
SET scriptVersie=0.0.9

REM Logbestand bepalen.
IF NOT EXIST "%basisPad%\log" MKDIR "%basisPad%\log"

SET logFile=%basisPad%\log\%ActionDate%-Logbestand.log

ECHO ##### Starten script %scriptFile% versie %scriptVersie%. > %logFile%
ECHO       Script gestart op %dd%-%mm%-%yyyy% om %hh%:%min% uur. >> %logFile%
CALL :ControleApps

:menu
REM Menu tonen.
CLS
COLOR 02
ECHO.
ECHO Scriptversie: %ScriptVersie%
ECHO.
ECHO Dit script bedoeld om in alle backup behoeften te voldoen.
ECHO.
ECHO Kies de gewenste vorm van backup en deze zal worden uitgevoerd.
ECHO.

:Continue
ECHO KEUZE            BESCHRIJVING                                             DUUR
ECHO 1. Netwerk     : De verschillende netwerkbronnen worden geback-upt.       3 uur
ECHO 2. Systeem     : Alle gegevens op het huidige systeem worden geback-upt.  Niet beschbaar
ECHO 3. Verplaatsen : De backup zal naar veilig medium verplaatst worden.      In onderhoud
ECHO 4. Software    : Alle beschikbare software wordt gearchiveerd.            Niet beschbaar
ECHO.
IF EXIST informatie.txt (
    ECHO I. Informatie  : Informatie over de backup weergeven.
) ELSE (
    ECHO. >> %logFile%
    ECHO      Informatie bestand niet gevonden. >> %logFile%
)
ECHO Q. Afsluiten   : Backup afsluiten.

:CHOICE
SET /P C=[1,2,3,4,Q,q,I,i]? > NUL

IF "%C%"=="1" GOTO Netwerk
IF "%C%"=="2" GOTO Systeem
IF "%C%"=="3" GOTO Opslaan
IF "%C%"=="4" GOTO Software

IF /I "%C%"=="I" GOTO Informatie
IF /I "%C%"=="Q" GOTO EoS

:Netwerk
CLS
COLOR 05
ECHO. >> %logFile%
ECHO ##### Netwerk script gekozen. >> %logFile%
ECHO.
ECHO Netwerk
ECHO.
REM _Shares sectie
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
SET source=\\SARgE-DOMAIN\Server
SET target=\\sarge-domain\Backup\Systemen\SARgE-DOMAIN\_Shares\Server
CALL :ExecuteBackUp
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
SET source=\\SARgE-DOMAIN\SARgE
SET target=\\sarge-domain\Backup\Systemen\SARgE-DOMAIN\_Users\SARgE
CALL :ExecuteBackUp
REM Thirza
SET source=\\SARgE-DOMAIN\Thirza
SET target=\\sarge-domain\Backup\Systemen\SARgE-DOMAIN\_Users\Thirza
CALL :ExecuteBackUp
ECHO.
ECHO Gereed.
ECHO Logbestand: %logfile%
ECHO.
ECHO Druk op een toets om door te gaan.
PAUSE > NUL
GOTO EoS

:Systeem
COLOR 03
CLS
ECHO.
ECHO Systeem
ECHO.
ECHO Druk op een toets om door te gaan.
PAUSE > NUL
GOTO EoS

:Opslaan
CLS
COLOR 06
ECHO. >> %logFile%
ECHO ##### verplaats script gekozen. >> %logFile%
ECHO.
ECHO Verplaatsen
ECHO.
ECHO.
ECHO Kies welke backup naar de backup schijf verplaatst moet worden:
ECHO.
ECHO KEUZE                 BESCHRIJVING
IF EXIST \\sarge-domain\Backup\Systemen\SARgE-DOMAIN\*.7z (
    ECHO 0. Netwerk          : Beschikbare netwerk backup verplaatsen.
)
IF EXIST \\sarge-domain\Backup\Systemen\Lisanne\*.7z (
    ECHO 1. Lisanne          : Lisanne backup verplaatsen.
)
IF EXIST \\sarge-domain\Backup\Systemen\SARgE-CHILL\*.7z (
    ECHO 2. SARgE-CHILL      : SARgE-CHILL backup verplaatsen.
)
IF EXIST \\sarge-domain\Backup\Systemen\SARgE-KODI\*.7z (
    ECHO 3. SARgE-KODI       : SARgE-KODI backup verplaatsen.
)
IF EXIST \\sarge-domain\Backup\Systemen\SARgE-MOBILE\*.7z (
    ECHO 4. SARgE-CHILL      : SARgE-CHILL backup verplaatsen.
)
IF EXIST \\sarge-domain\Backup\Systemen\SARgE-CHILL\*.7z (
    ECHO 5. SARgE-MOBILE     : SARgE-MOBILE backup verplaatsen.
)
IF EXIST \\sarge-domain\Backup\Systemen\SARgE-WORK-II\*.7z (
    ECHO 6. SARgE-WORK-II    : SARgE-WORK-II backup verplaatsen.
)

ECHO.
ECHO O. Overigen         : Zelf een map opgeven.
ECHO T. Terug            : Terug naar vorig menu.
ECHO Q. Afsluiten        : Backup afsluiten.

SET /P C=[0,1,2,3,4,Q,q,O,o,T,t,EXTRA]? > NUL

IF /I "%C%"=="T" (
    ECHO. >> %logFile%
    ECHO ##### Terug naar menu. >> %logFile%
    GOTO menu
)
IF /I "%C%"=="O" GOTO Overigen
IF /I "%C%"=="EXTRA" (
    ECHO EXTRA
    PAUSE
    GOTO Opslaan
) 
IF /I "%C%"=="Q" GOTO EoS
GOTO EoS

:Software
CLS
COLOR 09
ECHO.
ECHO Software
ECHO.
ECHO Druk op een toets om door te gaan.
PAUSE > NUL
GOTO EoS

:Informatie
CLS
ECHO. >> %logFile%
ECHO ##### Informatie opgevraagd. >> %logFile%
ECHO.
type informatie.txt 2>> %logFile%
ECHO.
ECHO Druk op een toets.
PAUSE > NUL
GOTO menu

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

:DatumTijdOpmaak
REM Bepaal datum
FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET CDATE=%%B
FOR /F "TOKENS=1,2 eol=/ DELIMS=- " %%A IN ('DATE/T') DO SET dd=%%B
FOR /F "TOKENS=1,2 DELIMS=- eol=/" %%A IN ('ECHO %CDATE%') DO SET mm=%%B
FOR /F "TOKENS=2,3 DELIMS=- " %%A IN ('ECHO %CDATE%') DO SET yyyy=%%B

REM Bepaal de tijd
FOR /F "TOKENS=1 DELIMS= " %%A in ('TIME/T') DO SET CTIME=%%A
FOR /F "TOKENS=1,2 DELIMS=: eol=/" %%A IN ('ECHO %CTIME%') DO SET hh=%%A
FOR /F "TOKENS=1,2 DELIMS=: eol=/" %%A IN ('ECHO %CTIME%') DO SET min=%%B
SET ActionDate=%yyyy%%mm%%dd%-%hh%%min%
EXIT /B

:ControleApps
ECHO. >> %logFile%
ECHO ##### Afhankelijkheden controle >> %logFile%
SET errorDependencies=0
IF EXIST %copyTool% (
    ECHO      %copyTool% gevonden. >> %logFile%
) ELSE (
    ECHO      %copyTool% niet gevonden. >> %logFile%
    ECHO.
    ECHO      %copyTool% Niet gevonden!
    SET errorDependencies=1
)
IF EXIST %CompressieTool% (
    ECHO      %CompressieTool% gevonden. >> %logFile%
) ELSE (
    ECHO      %CompressieTool% niet gevonden. >> %logFile%
    ECHO.
    ECHO      %CompressieTool% Niet gevonden!
    SET errorDependencies=1
)
ECHO      Dependencies check finished. >> %logFile%
IF %errorDependencies% EQU 1 (
    COLOR 04
    ECHO.
    ECHO Druk op een toets.
    PAUSE > NUL
    GOTO EoS
)
EXIT /B

:EoS
CLS
COLOR
ECHO. >> %logFile%
CALL :DatumTijdOpmaak
ECHO ##### Einde script op %dd%-%mm%-%yyyy% om %hh%:%min% uur. >> %logFile%
ECHO.
ECHO Het script is afgesloten.
ECHO.
EXIT