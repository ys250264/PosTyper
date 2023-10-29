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
xcopy %CommonDebugCustPath%\%ClientCommon%.dll %PosDebugCustPath%\SharedLibs\ClientCommon\ /y | findstr /v "1 File(s) copied" 
xcopy %CommonDebugCustPath%\%ClientCommon%.pdb %PosDebugCustPath%\SharedLibs\ClientCommon\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientNet%.dll %PosDebugCustPath%\SharedLibs\ClientCommon\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientNet%.pdb %PosDebugCustPath%\SharedLibs\ClientCommon\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.dll %PosDebugCustPath%\SharedLibs\ClientCommon\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.pdb %PosDebugCustPath%\SharedLibs\ClientCommon\ /y | findstr /v "1 File(s) copied"

:COPY_COMMON_MyEventLog_TO_EXT_SRC
Echo:
Echo ********** Copy Common to Ext Src **************************************************************************************************************************
xcopy %CommonDebugCustPath%\%ClientCommon%.dll %PosDebugExtPath%\Libs\Retalix\POSClient\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientCommon%.pdb %PosDebugExtPath%\Libs\Retalix\POSClient\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientNet%.dll %PosDebugExtPath%\Libs\Retalix\POSClient\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientNet%.pdb %PosDebugExtPath%\Libs\Retalix\POSClient\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.dll %PosDebugExtPath%\Libs\Retalix\POSClient\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.pdb %PosDebugExtPath%\Libs\Retalix\POSClient\ /y | findstr /v "1 File(s) copied"

:COPY_COMMON_MyEventLog_TO_OUTPUT
Echo:
Echo ********** Copy Common to Cust Output **************************************************************************************************************************
xcopy %CommonDebugCustPath%\%ClientCommon%.dll %PosDebugCustPath%\Output\Debug\Product\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientCommon%.pdb %PosDebugCustPath%\Output\Debug\Product\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientCommon%.dll %PosDebugCustPath%\Output\Debug\Product\Plugins\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientCommon%.pdb %PosDebugCustPath%\Output\Debug\Product\Plugins\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientNet%.dll %PosDebugCustPath%\Output\Debug\Product\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientNet%.pdb %PosDebugCustPath%\Output\Debug\Product\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientNet%.dll %PosDebugCustPath%\Output\Debug\Product\Plugins\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientNet%.pdb %PosDebugCustPath%\Output\Debug\Product\Plugins\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.dll %PosDebugCustPath%\Output\Debug\Product\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.pdb %PosDebugCustPath%\Output\Debug\Product\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.dll %PosDebugCustPath%\Output\Debug\Product\Plugins\ /y | findstr /v "1 File(s) copied"
xcopy %CommonDebugCustPath%\%ClientPresentationCore%.pdb %PosDebugCustPath%\Output\Debug\Product\Plugins\ /y | findstr /v "1 File(s) copied"

:END
rem pause

