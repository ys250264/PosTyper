@echo off
cls


:SET_PATHS_FROM_ARGS
set PosDebugCustPath=%1
set PosDebugExtPath=%2

:KILL_POS
Echo:
Echo ********** Kill POS **********************************************************************************************************************************
call .\helpers\killPOS.cmd

:COPY_COMMON_TO_CUST_AND_EXT
rem call .\helpers\CopyPosCommonToCustAndExt.cmd %1 %2

:COPY_EXT_TO_CUST
Echo:
Echo ********** Copy Ext to Cust **************************************************************************************************************************
xcopy %PosDebugExtPath%\Output\Debug\Product\*.* %PosDebugCustPath%\Output\Debug\Product\ /y /s /e 
Echo:
Echo ********** Copy Simulator to Plugin ******************************************************************************************************************
xcopy %PosDebugExtPath%\Src\EPS\Retalix.Jumbo.Client.EPS.Simulator\obj\Debug\Retalix.Jumbo.Client.EPS.Simulator.dll %PosDebugCustPath%\Output\Debug\Product\Plugins\ /y
Echo:
Echo ********** Copy SafePay to Cust ******************************************************************************************************************
xcopy %PosDebugExtPath%\..\Tools\Libs\SafePay\ccc*.dll %PosDebugCustPath%\Output\Debug\Product\ /y
Echo:


:END
Echo:
Echo:
IF %ERRORLEVEL% NEQ 0 pause
rem pause

