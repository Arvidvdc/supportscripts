@echo off

cls

REM Defaults
set basicFolder=s:\Documenten\GitHub\

echo.
set /P destFolder=Wich folder should open? : || Set destFolder=NothingChosen
echo.

If "%destFolder%"=="NothingChosen" goto sub_error

echo.
echo Changing folder to: %basicFolder%%destFolder%
echo.
For %%G in ("%basicFolder%%destFolder%") do set _drive=%%~dG
For %%G in ("%basicFolder%%destFolder%") do set _folder=%%~pG
%_drive%
cd %_folder%
echo.
echo.
echo Current folder: %cd%

goto eof

:sub_error
echo.
echo %basicFolder%
echo.

:eof
