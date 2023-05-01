
:SET_PATHS_FROM_ARGS
set RetailDbName=%1

:SET_SERVER_LOGGER
SetLogger DEBUG Receipt_Appender DEBUG

:EXECUTE_SQL
sqlcmd -S localhost -d %RetailDbName% -E -i receiptdebug_off.sql

:IISRESET
iisreset

