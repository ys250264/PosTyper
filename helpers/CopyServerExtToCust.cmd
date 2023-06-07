@echo off
cls

:SET_PATHS_FROM_ARGS
set ServerDebugCustPath=%1
set ServerDebugExtPath=%2
set LoyaltyDebugExtPath=%3

:IISSTOP
Echo **********   Stopping IIS
C:\Windows\System32\iisreset.exe /stop
Echo **********   Stopping IIS done

:COPY_LOY_TO_EXT
IF not exist %LoyaltyDebugExtPath%\StoreServer\App\Output\Debug\Product\ goto COPY_EXT_TO_CUST
xcopy %LoyaltyDebugExtPath%\StoreServer\App\Output\Debug\Product\*.* %ServerDebugExtPath%\App\Output\Debug\Product\ /y /e

:COPY_EXT_TO_CUST
xcopy %ServerDebugExtPath%\App\Output\Debug\Product\*.* %ServerDebugCustPath%\App\Src\ServiceHost\GPOSWebService\Extensions\ /y /e

:IISSTART
Echo **********   Starting IIS
C:\Windows\System32\iisreset.exe /start
Echo **********   Starting IIS done

:END
pause
