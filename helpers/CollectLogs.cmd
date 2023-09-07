cls 
@echo off
@echo.

for /f "skip=8 tokens=2,3,4,5,6,7,8 delims=:, " %%D in ('robocopy /l * \ \ /ns /nc /ndl /nfl /np /njh /XF * /XD *') do (

    set "YY=%%G"
    set "MM=%%E"
    set "DD=%%F"
    set "hh=%%H"
    set "mi=%%I"
    set "ss=%%J"
)


:SET_PATHS_FROM_ARGS
set CollectedLogsFolder=%1
set ServerPath=%2
set POSPath=%3
set OfficePath=%4
set DmsPath=%5
set ArsGatewayPath=%6
set RetailGatewayPath=%7
set StoreGatewayPath=%8
set WinEPTSPath=%9

rem echo %CollectedLogsFolder%
rem echo %ServerPath%
rem echo %POSPath%
rem echo %OfficePath%
rem echo %DmsPath%
rem echo %ArsGatewayPath%
rem echo %RetailGatewayPath%
rem echo %StoreGatewayPath%
rem echo %WinEPTSPath%



:CREATE_DESTINATIONS
set dest=%CollectedLogsFolder%\LOGS_%YY%%MM%%DD%_%hh%%mi%%ss%
set ServerDest=%dest%\01_SERVER
set LmsDest=%dest%\02_LMS
set RtiDest=%dest%\03_RTI
set TlogDest=%dest%\04_TLOG
set PosDest=%dest%\05_POS
set EpsDest=%dest%\06_EPS
set OfficeDest=%dest%\07_OFFICE
set DmsDest=%dest%\08_DMS
set RgwDest=%dest%\09_RGW
set WinEptsDest=%dest%\10_WINEPTS
set SgwDest=%dest%\11_SGW
set AgwDest=%dest%\12_AGW


:CREATE_SUB_PATHS
set ServerLogsPath=%ServerPath%\Logs
set ServerExtensionsPath=%ServerPath%\Extensions
set ServerTLogsPath=%ServerPath%\Log
set ServerRTIsPath=%ServerLogsPath%\RTI\POS(null)_Message
set POSLogsPath=%POSPath%\Logs
set POSEpsLogsPath=%POSPath%\Logs\EPS
set OfficeLogsPath=%OfficePath%\Logs
set DmsLogsPath=%DmsPath%\DMSLog
set ArsGatewayLogsPath=%ArsGatewayPath%\Logs
set RetailGatewayLogsPath=%RetailGatewayPath%\gatewaylogs
set StoreGatewayLogsPath=%StoreGatewayPath%\Logs
set WinEPTSLogsPath=%WinEPTSPath%\traces

set FindStr=findstr /l /v "File(s) copied"


:SERVER
if not exist %ServerLogsPath%\ goto LMSLOG
echo:
echo ********** Server Logs *************************************************************************************************************************
if not exist %ServerDest%\ mkdir %ServerDest%\
del /Q %ServerDest%\*.*
cd /D  %ServerLogsPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 4 goto SERVER_DONE
    xcopy /y "%%b" %ServerDest% | %FindStr%
)
:SERVER_DONE
cd /D %ServerExtensionsPath%
if exist *.txt xcopy /y *.txt %ServerDest% | %FindStr%
cd /D %ServerPath%
if exist Server.txt xcopy /y Server.txt %ServerDest% | %FindStr%


:LMSLOG
if not exist %ServerLogsPath%\CustomerAndMarketing\LoyaltyProMessages\ goto RTI
echo:
echo ********** Server LMS Logs *********************************************************************************************************************
if not exist %LmsDest%\ mkdir %LmsDest%\
del /Q %LmsDest%\*.*
cd /D %ServerLogsPath%\CustomerAndMarketing\LoyaltyProMessages
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 10 goto LMSLOG_DONE
    xcopy /y "%%b" %LmsDest% | %FindStr%
)
:LMSLOG_DONE


:RTI
if not exist %ServerRTIsPath%\ goto TLOG
echo:
echo ********** Server RTIs *************************************************************************************************************************
if not exist %RtiDest%\ mkdir %RtiDest%\
del /Q %RtiDest%\*.*
cd /D %ServerRTIsPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    xcopy /y "%%b" %RtiDest%\ | %FindStr%
	echo %%b | findstr /c:"IDMRequest_IdmLogin" >nul 2>&1
	if not errorlevel 1  goto RTI_DONE
)
:RTI_DONE


:TLOG
if not exist %ServerTLogsPath%\ goto POS
echo:
echo ********** TLogs *******************************************************************************************************************************
if not exist %TlogDest%\ mkdir %TlogDest%\
del /Q %TlogDest%\*.*
cd /D %ServerTLogsPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b Retail* ^| findstr /n "^"') do (
    if %%a gtr 3 goto TLOG_DONE
    xcopy /y "%%b" %TlogDest%\ | %FindStr%
)
:TLOG_DONE


:POS
if not exist %POSLogsPath%\ goto POS_EPS
echo:
echo ********** POS Logs ****************************************************************************************************************************
if not exist %PosDest%\ mkdir %PosDest%\
del /Q %PosDest%\*.*
cd /D %POSLogsPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 15 goto POS_DONE
    xcopy /y "%%b" %PosDest% | %FindStr%
)
:POS_DONE
cd /D %POSPath%
if exist *.txt xcopy /y *.txt %PosDest% | %FindStr%


:POS_EPS
if not exist %POSLogsPath%\ goto OFFICE
echo:
echo ********** POS EPS Logs ************************************************************************************************************************
if not exist %EpsDest% mkdir %EpsDest%
del /Q %EpsDest%\*.*
cd /D %POSEpsLogsPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 4 goto POS_EPS_DONE
    xcopy /y "%%b" %EpsDest% | %FindStr%
)
:POS_EPS_DONE


:OFFICE
if not exist %OfficeLogsPath%\ goto DMS
if not exist %OfficeLogsPath%\*.log* goto DMS
echo:
echo ********** Office Logs *************************************************************************************************************************
if not exist %OfficeDest%\ mkdir %OfficeDest%\
del /Q %OfficeDest%\*.*
cd /D %OfficeLogsPath%
if not exist *.log* goto OFFICE_DONE
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 3 goto OFFICE_DONE
    xcopy /y "%%b" %OfficeDest% | %FindStr%
)
:OFFICE_DONE
rem if not exist %OfficePath%\Extensions\Coop_Italia goto DMS
rem cd /D %OfficePath%\Extensions\Coop_Italia
rem xcopy /y *.txt %OfficeDest% | %FindStr%
if not exist %OfficePath% goto DMS
cd /D %OfficePath%
xcopy /y *.txt %OfficeDest% | %FindStr%


:DMS
if not exist %DmsLogsPath%\ goto RETAIL_GATEWAY
echo:
echo ********** DMS Logs ****************************************************************************************************************************
if not exist %DmsDest%\ mkdir %DmsDest%\
del /Q %DmsDest%\*.*
cd /D %DmsLogsPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 5 goto DMS_DONE
    xcopy /y "%%b" %DmsDest%\ | %FindStr%
)
:DMS_DONE



:RETAIL_GATEWAY
if not exist %RetailGatewayLogsPath%\ goto WINEPTS
echo:
echo ********** RetailGateway Logs ******************************************************************************************************************
if not exist %RgwDest%\ mkdir %RgwDest%\
del /Q %RgwDest%\*.*
cd /D %RetailGatewayLogsPath%\
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 3 goto RETAIL_GATEWAY_DONE
    xcopy /y "%%b" %RgwDest% | %FindStr%
)
:RETAIL_GATEWAY_DONE



:WINEPTS
if not exist %WinEPTSLogsPath%\ goto STORE_GATEWAY
echo:
echo ********** WinEPTS Logs ************************************************************************************************************************
if not exist %WinEptsDest%\ mkdir %WinEptsDest%\
del /Q %WinEptsDest%\*.*
cd /D %WinEPTSPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 3 goto WINEPTS_DONE
    xcopy /y "%%b" %WinEptsDest% | %FindStr%
)
:WINEPTS_DONE


:STORE_GATEWAY
if not exist %StoreGatewayLogsPath%\ goto ARS_GATEWAY
echo:
echo ********** StoreGateway Logs *******************************************************************************************************************
if not exist %SgwDest%\ mkdir %SgwDest%\
del /Q %SgwDest%\*.*
cd /D %StoreGatewayLogsPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 3 goto STORE_GATEWAY_DONE
    xcopy /y "%%b" %SgwDest% | %FindStr%
)
:STORE_GATEWAY_DONE
cd /D %StoreGatewayPath%
xcopy /y *.txt %SgwDest% | %FindStr%


:ARS_GATEWAY
if not exist %ArsGatewayLogsPath%\ goto END
echo:
echo ********** ArsGateway Logs *********************************************************************************************************************
if not exist %AgwDest%\ mkdir %AgwDest%\
del /Q %AgwDest%\*.*
cd /D %ArsGatewayLogsPath%\
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 3 goto ARS_GATEWAY_DONE
    xcopy /y "%%b" %AgwDest% | %FindStr%
)
:ARS_GATEWAY_DONE



:END
echo:
echo:
if %ERRORLEVEL% NEQ 0 pause


:COMPRESS
powershell Compress-Archive -Path %dest% -CompressionLevel Optimal -DestinationPath %dest%.zip
start %dest%.zip
