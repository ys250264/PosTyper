@echo off
cls

:SET_VARS
set SourceRoot=.\root
set TargetRoot=..\..\..\..
set AutomationFlow=automation\flows
set Items=items

:DELETE_SOURCE
del %TargetRoot%\%AutomationFlow% /s /q
del %TargetRoot%\%Items% /s /q

:COPY_TARGET
xcopy %SourceRoot%\%AutomationFlow%\*.* %TargetRoot%\%AutomationFlow%\ /y 
xcopy %SourceRoot%\%Items%\*.* %TargetRoot%\%Items%\ /y 
copy %SourceRoot%\POStyper_Release.ini %TargetRoot%\POStyper.ini

:END
Echo:
Echo:
IF %ERRORLEVEL% NEQ 0 pause
rem pause