@echo off
cls

:SET_PATHS_FROM_ARGS
set Source=%1
set ServerDebugExtPath=%2
set RTIsPath=%3
set Target=%ServerDebugExtPath%\%RTIsPath%

:COPY_RTIS
IF not exist %Source% GOTO:REMOVE_ECOM_RTI
xcopy %Source%\*.* %Target%\ /y /s

:REMOVE_ECOM_RTI
set FileToRemove=%Target%\1_Configuration\028_ConfigurationEntry\*.RUN_ON_ECOMM_ONLY
if exist %FileToRemove% del /f /q %FileToRemove%

:END
Echo:
Echo:
IF %ERRORLEVEL% NEQ 0 pause
