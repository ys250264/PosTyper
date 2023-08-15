@echo off
cls


:SET_PATHS_FROM_ARGS
set OfficeAppPool=%1
set OfficeDebugCustPath=%2
set OfficeDebugExtPath=%3

:SET_MORE_PATHS
rem set UseIISReset=
set FullPathAppCmd=C:\Windows\System32\inetsrv\appcmd


:APPPOOLS_STOP
IF DEFINED UseIISReset GOTO:IISREST_STOP
Echo:
Echo ********** Stopping AppPools *************************************************************************************************************************
%FullPathAppCmd% stop apppool /apppool.name:%OfficeAppPool%
GOTO:APPPOOLS_STOP_END
:IISREST_STOP
Echo:
Echo ********** Stopping IISRESET *************************************************************************************************************************
C:\Windows\System32\iisreset.exe /stop
:APPPOOLS_STOP_END


:COPY_EXT_TO_CUST
Echo:
Echo ********** Copy Ext to Cust **************************************************************************************************************************
xcopy %OfficeDebugExtPath%\Output\Debug\Extensions\*.* %OfficeDebugCustPath%\Src\Web\Extensions\ /y /e


:APPPOOLS_START
IF DEFINED UseIISReset GOTO:IISREST_START
Echo:
Echo ********** Stopping AppPools *************************************************************************************************************************
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
