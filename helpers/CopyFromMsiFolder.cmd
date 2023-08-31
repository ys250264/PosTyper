@echo off
cls

:SET_PATHS_FROM_ARGS
set ServerPath=%1
set PosPath=%2
set OfficePath=%3
set PosDebugExtPath=%4

:SET_PATHS_FROM_ARGS
set MsiBasePath=C:\Retalix\StoreServices
set MsiServerPath=%MsiBasePath%\Server\PosService
set MsiPosPath=%MsiBasePath%\PosClient
set MsiOfficePath=%MsiBasePath%\OfficeClient\Web


:COPY_TO_SERVER
IF not exist %MsiServerPath%\ goto COPY_TO_POS
Echo:
Echo ********** Copy Server **********************************************************************************************************************************
xcopy %MsiServerPath%\WebLoggerConfig.xml %ServerPath%\ /y

:COPY_TO_POS
IF not exist %MsiPosPath%\ goto COPY_TO_OFFICE
Echo:
Echo ********** Copy POS *************************************************************************************************************************************
xcopy %MsiPosPath%\LoggerConfig.xml %PosPath%\ /y
xcopy %MsiPosPath%\LoggerConfig.xml %PosDebugExtPath%\Src\Retalix.Jumbo.Client.Logger.Configuration\ /y

:COPY_TO_OFFICE
IF not exist %MsiOfficePath%\ goto END
Echo:
Echo ********** Copy Office **********************************************************************************************************************************
xcopy %MsiOfficePath%\bin\Retalix.StoreOfficeClient.Globalization.Services.dll %OfficePath%\bin\ /y

:END
Echo:
Echo:
IF %ERRORLEVEL% NEQ 0 pause
rem pause
