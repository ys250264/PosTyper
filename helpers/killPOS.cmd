
:KILL_SIMULATOR
set Simulator=Retalix.Jumbo.Client.EPS.SimulatorGUI.exe
tasklist /fi "ImageName eq %Simulator%" /fo csv 2>NUL | find /I "%Simulator%">NUL
if "%ERRORLEVEL%"=="0" (taskkill /F /IM %Simulator%) ELSE (ECHO IGNORE : %Simulator% is not running)

:KILL_POS
set POS=Retalix.Client.POS.Shell.exe
tasklist /fi "ImageName eq %POS%" /fo csv 2>NUL | find /I "%POS%">NUL
if "%ERRORLEVEL%"=="0" (taskkill /F /IM %POS%) ELSE (ECHO IGNORE : %POS% is not running)
