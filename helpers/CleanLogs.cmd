@echo off


:SET_PATHS_FROM_ARGS
set ServerPath=%1
set POSPath=%2
set OfficePath=%3
set DmsPath=%4
set ArsGatewayPath=%5
set RetailGatewayPath=%6
set StoreGatewayPath=%7
set WinEPTSPath=%8

:IISSTOP
Echo **********   Stopping IIS
C:\Windows\System32\iisreset.exe /stop
Echo **********   Stopping IIS done

:SRVLOG
IF not exist %ServerPath%\Logs\*.log goto SRVLOGE
echo Clean Server Logs ...
del /S %ServerPath%\Logs\*.log*
:SRVLOGE

:STRGWLOG
IF not exist %StoreGatewayPath%\Logs\*.log goto STRGWLOGE
echo Clean StoreGateway Logs ...
del /S %StoreGatewayPath%\Logs\*.log*
:STRGWLOGE


:OFFLOG
IF not exist %OfficePath%\Logs\*.log* goto OFFLOGE
echo Clean OfficeClient Logs ...
del /S %OfficePath%\Logs\*.log*
:OFFLOGE


:POSLOG
IF not exist %POSPath%\Logs\*.log* goto POSLOGE
echo Clean POS Logs...
del %POSPath%\Logs\*.log*
del %POSPath%\Logs\EPS\*.log*
del %POSPath%\Logs\*.stf*
:POSLOGE

:EPSLOG
IF not exist %WinEPTSPath%\traces\*.txt goto EPSLOGE
echo Clean EPS Logs...
del %WinEPTSPath%\traces\*.txt
:EPSLOGE


:IISSTART
Echo **********   Starting IIS
C:\Windows\System32\iisreset.exe /start
Echo **********   Starting IIS done

:END
