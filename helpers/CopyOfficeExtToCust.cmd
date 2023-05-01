@echo off
cls


:SET_PATHS_FROM_ARGS
set OfficeDebugCustPath=%1
set OfficeDebugExtPath=%2

:IISSTOP
Echo **********   Stopping IIS
C:\Windows\System32\iisreset.exe /stop
Echo **********   Stopping IIS done

:COPY
xcopy %OfficeDebugExtPath%\Output\Debug\Extensions\*.* %OfficeDebugCustPath%\Src\Web\Extensions\ /y /e

:IISSTART
Echo **********   Starting IIS
C:\Windows\System32\iisreset.exe /start
Echo **********   Starting IIS done

:END
pause
