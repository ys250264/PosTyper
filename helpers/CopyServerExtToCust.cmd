@echo off
cls

:SET_PATHS_FROM_ARGS
set ServerDebugCustPath=%1
set ServerDebugExtPath=%2

:IISSTOP
Echo **********   Stopping IIS
C:\Windows\System32\iisreset.exe /stop
Echo **********   Stopping IIS done

:COPY
xcopy %ServerDebugExtPath%\App\Output\Debug\Product\*.* %ServerDebugCustPath%\App\Src\ServiceHost\GPOSWebService\Extensions\ /y /e

:IISSTART
Echo **********   Starting IIS
C:\Windows\System32\iisreset.exe /start
Echo **********   Starting IIS done

:END
pause
