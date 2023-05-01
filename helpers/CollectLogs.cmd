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

rem C:\Windows\System32\iisreset.exe /stop

set R10drive=C:
rem IF exist E:\Retalix\StoreServices\Server\ set R10drive=E:

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

set dest=%CollectedLogsFolder%\LOGS_%YY%%MM%%DD%_%hh%%mi%%ss%


:CREATE_SUB_PATHS
set ServerLogsPath=%ServerPath%\Logs
set ServerExtensionsPath=%ServerPath%\Extensions
set ServerTLogsPath=%ServerPath%\Log
set ServerRTIsPath=%ServerPath%\RtiServices
set POSLogsPath=%POSPath%\Logs
set OfficeLogsPath=%OfficePath%\Logs
set DmsLogsPath=%DmsPath%\DMSLog
set ArsGatewayLogsPath=%ArsGatewayPath%\Logs
set RetailGatewayLogsPath=%RetailGatewayPath%\gatewaylogs
set StoreGatewayLogsPath=%StoreGatewayPath%\Logs
set WinEPTSLogsPath=%WinEPTSPath%\traces


:LMSLOG
IF not exist %ServerLogsPath%\CustomerAndMarketing\LoyaltyProMessages\ goto SRVLOG
IF not exist %dest%\LMSMSG\ mkdir %dest%\LMSMSG\
del /Q %dest%\LMSMSG\*.*
cd /D %ServerLogsPath%\CustomerAndMarketing\LoyaltyProMessages
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 10 goto done
    copy /y "%%b" %dest%\LMSMSG
)
:done

:SRVLOG
IF not exist %ServerLogsPath%\ goto TLOG
IF not exist %dest%\SRVLOG\ mkdir %dest%\SRVLOG\
del /Q %dest%\SRVLOG\*.*
cd /D  %ServerLogsPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 3 goto done
    copy /y "%%b" %dest%\SRVLOG
)

:done
cd /D %ServerExtensionsPath%
copy /y *.txt %dest%\SRVLOG
cd /D %ServerPath%
copy /y Server.txt %dest%\SRVLOG

:TLOG
IF not exist %ServerTLogsPath%\ goto RTI
IF not exist %dest%\TLOG\ mkdir %dest%\TLOG\
del /Q %dest%\TLOG\*.*
cd /D %ServerTLogsPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 3 goto done
    copy /y "%%b" %dest%\TLOG\
)
:done

:RTI
IF not exist %ServerRTIsPath%\ goto DMS
IF not exist %dest%\RTI\ mkdir %dest%\RTI\
del /Q %dest%\RTI\*.*
cd /D %ServerRTIsPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 2 goto done
    copy /y "%%b" %dest%\RTI\
)
:done

:DMS
IF not exist %DmsLogsPath%\ goto POS
IF not exist %dest%\DMS\ mkdir %dest%\DMS\
del /Q %dest%\DMS\*.*
cd /D %DmsLogsPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 5 goto done
    copy /y "%%b" %dest%\DMS\
)
:done


:POS
IF not exist %POSLogsPath%\ goto WE
IF not exist %dest%\POSLOG\ mkdir %dest%\POSLOG\
del /Q %dest%\POSLOG\*.*
cd /D %POSLogsPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 10 goto done
    copy /y "%%b" %dest%\POSLOG
)

:done
cd /D %POSPath%
copy /y *.txt %dest%\POSLOG


:WE
IF not exist %WinEPTSLogsPath%\ goto ARSGW
IF not exist %dest%\WINEPTS\ mkdir %dest%\WINEPTS\
del /Q %dest%\WINEPTS\*.*
cd /D %WinEPTSPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 3 goto done
    copy /y "%%b" %dest%\WINEPTS
)
:done

:ARSGW
IF not exist %ArsGatewayLogsPath%\ goto ARSGW
IF not exist %dest%\ARSLOG\ mkdir %dest%\ARSLOG\
del /Q %dest%\ARSLOG\*.*
cd /D %ArsGatewayLogsPath%\
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 3 goto done
    copy /y "%%b" %dest%\ARSLOG
)
:done

:ARSGW
IF not exist %RetailGatewayLogsPath%\ goto STOGW
IF not exist %dest%\ARSLOG\ mkdir %dest%\RGWLOG\
del /Q %dest%\RGWLOG\*.*
cd /D %RetailGatewayLogsPath%\
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 3 goto done
    copy /y "%%b" %dest%\RGWLOG
)
:done

:STOGW
IF not exist %StoreGatewayLogsPath%\ goto OFFICE
IF not exist %dest%\STOGWLOG\ mkdir %dest%\STOGWLOG\
del /Q %dest%\STOGWLOG\*.*
cd /D %StoreGatewayLogsPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 3 goto done
    copy /y "%%b" %dest%\STOGWLOG
)
:done
cd /D %StoreGatewayPath%
copy /y *.txt %dest%\STOGWLOG


:OFFICE
IF not exist %OfficeLogsPath%\ goto END
IF not exist %dest%\OFFICELOG\ mkdir %dest%\OFFICELOG\
del /Q %dest%\OFFICELOG\*.*
cd /D %OfficeLogsPath%
for /f "tokens=1,* delims=:" %%a in ('dir /o-d /a-d-h /b * ^| findstr /n "^"') do (
    if %%a gtr 3 goto done
    copy /y "%%b" %dest%\OFFICELOG
)
:done
cd /D %OfficePath%\Extensions\Coop_Italia
copy /y *.txt %dest%\OFFICELOG
cd /D %OfficePath%
copy /y *.txt %dest%\OFFICELOG


:END

:COMPRESS
powershell Compress-Archive -Path %dest% -CompressionLevel Optimal -DestinationPath %dest%.zip
start %dest%.zip

rem C:\Windows\System32\iisreset.exe /start