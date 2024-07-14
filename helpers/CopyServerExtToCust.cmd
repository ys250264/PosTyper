@echo off
cls

:SET_PATHS_FROM_ARGS
set ServerAppPool=%1
set ServerDebugCustPath=%2
set ServerDebugExtPath=%3
set LoyaltyDebugExtPath=%4


:SET_MORE_PATHS
rem set UseIISReset=
set FullPathAppCmd=C:\Windows\System32\inetsrv\appcmd


:APPPOOLS_STOP
IF DEFINED UseIISReset GOTO:IISREST_STOP
Echo:
Echo ********** Stopping AppPool *************************************************************************************************************************
%FullPathAppCmd% stop apppool /apppool.name:%ServerAppPool%
GOTO:APPPOOLS_STOP_END
:IISREST_STOP
Echo:
Echo ********** Stopping IISRESET ************************************************************************************************************************
C:\Windows\System32\iisreset.exe /stop
:APPPOOLS_STOP_END


:COPY_LOY_TO_EXT
Echo:
Echo ********** Copy Loyalty to Ext **********************************************************************************************************************
IF not exist %LoyaltyDebugExtPath%\StoreServer\App\Output\Debug\Product\ goto COPY_EXT_TO_CUST
xcopy %LoyaltyDebugExtPath%\StoreServer\App\Output\Debug\Product\*.* %ServerDebugExtPath%\App\Output\Debug\Product\ /y /e


:COPY_EXT_TO_CUST
Echo:
Echo ********** Copy Ext to Cust *************************************************************************************************************************
xcopy %ServerDebugExtPath%\App\Output\Debug\Product\*.* %ServerDebugCustPath%\App\Src\ServiceHost\GPOSWebService\Extensions\ /y /e

:DELETE_FUEL_COMPONENTS_CASTLE_FILE
IF not exist %ServerDebugCustPath%\App\Src\ServiceHost\GPOSWebService\Extensions\ConfigAdditions\FuelComponents.xml goto APPPOOLS_START
Echo:
Echo ********** Delete Extensions\ConfigAdditions\FuelComponents.xml *************************************************************************************
del /S /F /Q %ServerDebugCustPath%\App\Src\ServiceHost\GPOSWebService\Extensions\ConfigAdditions\FuelComponents.xml
Echo:

:APPPOOLS_START
IF DEFINED UseIISReset GOTO:IISREST_START

Echo:
Echo ********** Stopping AppPools ************************************************************************************************************************
%FullPathAppCmd% start apppool /apppool.name:%ServerAppPool%
GOTO:APPPOOLS_START_END

:IISREST_START
Echo:
Echo ********** Stopping IISRESET 8***********************************************************************************************************************
C:\Windows\System32\iisreset.exe /start
:APPPOOLS_START_END


:END
Echo:
Echo:
IF %ERRORLEVEL% NEQ 0 pause

rem pause
