@echo off
cls

:SET_PATHS_FROM_ARGS
set ServerDebugExtPath=%1
set RTIsPath=%2
set TargetBase=%ServerDebugExtPath%\%RTIsPath%

:SET_MORE_VARS:
set SourceBase=.\helpers
set Configuration=1_Configuration
set LabSpecific=3_Lab_IL_Specific

:COPY_RTIS_WITH_MACHINE_NAME
xcopy %SourceBase%\%LabSpecific%\*.* %TargetBase%\%LabSpecific%\ /y /s

:REMOVE_ECOM_RTI
del /f /q %TargetBase%\%Configuration%\028_ConfigurationEntry\*.RUN_ON_ECOMM_ONLY

:END
pause
