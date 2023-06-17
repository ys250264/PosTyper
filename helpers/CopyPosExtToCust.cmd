@echo off
cls


:SET_PATHS_FROM_ARGS
set PosDebugCustPath=%1
set PosDebugExtPath=%2

:KILL_POS
call .\helpers\killPOS.cmd

:COPY
xcopy %PosDebugExtPath%\Output\Debug\Product\*.* %PosDebugCustPath%\Output\Debug\Product\ /y /e 
xcopy %PosDebugExtPath%\Output\Debug\Product\Plugins\*.* %PosDebugCustPath%\Output\Debug\Product\Plugins\ /y /e 
xcopy %PosDebugExtPath%\Src\EPS\Retalix.Jumbo.Client.EPS.Simulator\obj\Debug\Retalix.Jumbo.Client.EPS.Simulator.dll %PosDebugCustPath%\Output\Debug\Product\Plugins\ /y

:END
pause
