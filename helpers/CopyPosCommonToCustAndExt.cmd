@echo off

:SET_PATHS_FROM_ARGS
set PosDebugCustPath=%1
set PosDebugExtPath=%2

:SET_MyEventLog_Vars
set CommonDebugCustPath=%PosDebugCustPath%\..\ClientCommon\Output\Debug\Product
set ClientCommon=Retalix.Client.Common
set ClientNet=Retalix.Client.Net
set ClientPresentationCore=Retalix.Client.Presentation.Core

:COPY_COMMON_MyEventLog_TO_CUST_SRC
Echo:
Echo ********** Copy Common to Cust Src **************************************************************************************************************************
xcopy %CommonDebugCustPath%\%ClientCommon%.dll %PosDebugCustPath%\SharedLibs\ClientCommon\ /y
xcopy %CommonDebugCustPath%\%ClientCommon%.pdb %PosDebugCustPath%\SharedLibs\ClientCommon\ /y
xcopy %CommonDebugCustPath%\%ClientNet%.dll %PosDebugCustPath%\SharedLibs\ClientCommon\ /y
xcopy %CommonDebugCustPath%\%ClientNet%.pdb %PosDebugCustPath%\SharedLibs\ClientCommon\ /y
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.dll %PosDebugCustPath%\SharedLibs\ClientCommon\ /y
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.pdb %PosDebugCustPath%\SharedLibs\ClientCommon\ /y

:COPY_COMMON_MyEventLog_TO_EXT_SRC
Echo:
Echo ********** Copy Common to Ext Src **************************************************************************************************************************
xcopy %CommonDebugCustPath%\%ClientCommon%.dll %PosDebugExtPath%\Libs\Retalix\POSClient\ /y
xcopy %CommonDebugCustPath%\%ClientCommon%.pdb %PosDebugExtPath%\Libs\Retalix\POSClient\ /y
xcopy %CommonDebugCustPath%\%ClientNet%.dll %PosDebugExtPath%\Libs\Retalix\POSClient\ /y
xcopy %CommonDebugCustPath%\%ClientNet%.pdb %PosDebugExtPath%\Libs\Retalix\POSClient\ /y
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.dll %PosDebugExtPath%\Libs\Retalix\POSClient\ /y
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.pdb %PosDebugExtPath%\Libs\Retalix\POSClient\ /y

:COPY_COMMON_MyEventLog_TO_OUTPUT
Echo:
Echo ********** Copy Common to Cust Output **************************************************************************************************************************
xcopy %CommonDebugCustPath%\%ClientCommon%.dll %PosDebugCustPath%\Output\Debug\Product\ /y
xcopy %CommonDebugCustPath%\%ClientCommon%.pdb %PosDebugCustPath%\Output\Debug\Product\ /y
xcopy %CommonDebugCustPath%\%ClientCommon%.dll %PosDebugCustPath%\Output\Debug\Product\Plugins\ /y
xcopy %CommonDebugCustPath%\%ClientCommon%.pdb %PosDebugCustPath%\Output\Debug\Product\Plugins\ /y
xcopy %CommonDebugCustPath%\%ClientNet%.dll %PosDebugCustPath%\Output\Debug\Product\ /y
xcopy %CommonDebugCustPath%\%ClientNet%.pdb %PosDebugCustPath%\Output\Debug\Product\ /y
xcopy %CommonDebugCustPath%\%ClientNet%.dll %PosDebugCustPath%\Output\Debug\Product\Plugins\ /y
xcopy %CommonDebugCustPath%\%ClientNet%.pdb %PosDebugCustPath%\Output\Debug\Product\Plugins\ /y
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.dll %PosDebugCustPath%\Output\Debug\Product\ /y
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.pdb %PosDebugCustPath%\Output\Debug\Product\ /y
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.dll %PosDebugCustPath%\Output\Debug\Product\Plugins\ /y
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.pdb %PosDebugCustPath%\Output\Debug\Product\Plugins\ /y

:END
rem pause

