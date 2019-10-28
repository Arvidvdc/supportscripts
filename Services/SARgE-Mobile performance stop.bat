@echo off
echo.
echo "Stopping services for performance..."
echo.


REM HP
    sc stop "HP Comm Recover"
    sc stop "HPJumpStartBridge"
    sc stop "HPSupportSolutionsFrameworkService"
    sc stop "HPWMISVC"
    
REM Itarian
    sc stop "ITSMService"
    sc stop "RmmService"
    
REM Proton
    sc stop "ProtonVPN Service"
    
REM Teamviewer
    sc stop "TeamViewer"
    
REM Realtek
    sc stop "RtkBtManServ"
    
REM Real Networks
    sc stop "RealPlayerUpdateSvc"
    sc stop "RealTimes Desktop Service"

echo.
echo "Done..."
echo.
pause >null