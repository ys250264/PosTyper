
:SET_PATHS_FROM_ARGS
set PosPath=%1

:KILL_OTHERS
taskkill /F /IM PayClient.exe

:SAVE_CWD
set cwd=%CD%

:START_POS
cd %PosPath%
start Retalix.Client.POS.Shell.exe

:FINISH
cd %cwd%
