
:SET_PATHS_FROM_ARGS
set RetailDbName=%1

:EXECUTE_SQL
sqlcmd -S localhost -d %RetailDbName% -E -i jumbo_update_to_english.sql

:IISRESET
iisreset

