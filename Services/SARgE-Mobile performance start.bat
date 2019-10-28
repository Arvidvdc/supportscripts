@echo off
echo.
echo Starting services for performance...
echo.


REM HP
    sc start "HP Comm Recover"
    sc start "HPJumpStartBridge"
    sc start "HPSupportSolutionsFrameworkService"
    sc start "HPWMISVC"
    
REM Itarian
    sc start "ITSMService"
    sc start "RmmService"
    
REM Proton
    sc start "ProtonVPN Service"
    
REM Teamviewer
    sc start "TeamViewer"
    
REM Realtek
    sc start "RtkBtManServ"
    
REM Real Networks
    sc start "RealPlayerUpdateSvc"
    sc start "RealTimes Desktop Service"

echo.
echo "Done..."
echo.
pause >null