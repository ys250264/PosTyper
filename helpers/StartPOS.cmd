
:SET_PATHS_FROM_ARGS
set PosFullPath=%1

:KILL_OTHERS
taskkill /F /IM PayClient.exe

:START_POS
start %PosFullPath%
