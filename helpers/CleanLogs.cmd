@echo off


:SET_PATHS_FROM_ARGS
set ServerAppPool=%1
set OfficeAppPool=%2
set ServerPath=%3
set POSPath=%4
set OfficePath=%5
set DmsPath=%6
set ArsGatewayPath=%7
set RetailGatewayPath=%8
set StoreGatewayPath=%9
set WinEPTSPath=%10

:SET_MORE_PATHS
rem set UseIISReset=
set FullPathAppCmd=C:\Windows\System32\inetsrv\appcmd


:APPPOOLS_STOP
IF DEFINED UseIISReset GOTO:IISREST_STOP
Echo:
Echo ********** Stopping AppPools *************************************************************************************************************************
%FullPathAppCmd% stop apppool /apppool.name:%OfficeAppPool%
%FullPathAppCmd% stop apppool /apppool.name:%ServerAppPool%
GOTO:APPPOOLS_STOP_END
:IISREST_STOP
Echo:
Echo ********** Stopping IISRESET *************************************************************************************************************************
C:\Windows\System32\iisreset.exe /stop
:APPPOOLS_STOP_END


:SRVLOG
IF not exist %ServerPath%\Logs\*.log GOTO:SRVLOG_END
Echo:
Echo ********** Clean Server Logs *************************************************************************************************************************
del /S /F /Q %ServerPath%\Logs\*.log*
:SRVLOG_END


:STRGWLOG
IF not exist %StoreGatewayPath%\Logs\*.log GOTO:STRGWLOG_END
Echo:
Echo ********** Clean StoreGateway Logs *******************************************************************************************************************
del /S /F /Q %StoreGatewayPath%\Logs\*.log*
:STRGWLOG_END


:OFFLOG
IF not exist %OfficePath%\Logs\*.* GOTO:OFFLOG_END
Echo:
Echo ********** Clean OfficeClient Logs *******************************************************************************************************************
del /S /F /Q %OfficePath%\Logs\*.*
:OFFLOG_END


:POSLOG
IF not exist %POSPath%\Logs\*.* GOTO:POSLOG_END
Echo:
Echo ********** Clean POS Logs ****************************************************************************************************************************
del %POSPath%\Logs\*.log*
del %POSPath%\Logs\EPS\*.log*
del %POSPath%\Logs\EPS\*.xml*
del %POSPath%\Logs\*.stf*
:POSLOG_END


:EPSLOG
IF not exist %WinEPTSPath%\traces\*.txt GOTO:EPSLOG_END
Echo:
Echo ********** Clean EPS Logs ****************************************************************************************************************************
del %WinEPTSPath%\traces\*.txt
:EPSLOG_END


:APPPOOLS_START
IF DEFINED UseIISReset GOTO:IISREST_START
Echo:
Echo ********** Stopping AppPools *************************************************************************************************************************
%FullPathAppCmd% start apppool /apppool.name:%ServerAppPool%
%FullPathAppCmd% start apppool /apppool.name:%OfficeAppPool%
GOTO:APPPOOLS_START_END
:IISREST_START
Echo:
Echo ********** Stopping IISRESET 8************************************************************************************************************************
C:\Windows\System32\iisreset.exe /start
:APPPOOLS_START_END


:END
Echo:
Echo:
IF %ERRORLEVEL% NEQ 0 pause
