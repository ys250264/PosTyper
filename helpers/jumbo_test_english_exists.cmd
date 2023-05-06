@echo off
:SET_PATHS_FROM_ARGS
set "RetailDbName=%RETAIL_DB_NAME_TEMP_VAR%"

:EXECUTE_SQL
sqlcmd -S localhost -d %RetailDbName% -E -i jumbo_test_english_exists.sql -h-1 -o output.txt

:DELETE_TEMP_ENV_VAR
RETAIL_DB_NAME_TEMP_VAR=

:RESULT_TO_VAR
set /P exists= < output.txt
del output.txt

:TRIM_VAR
set exists=%exists: =%

:RETURN_VALUE_TO_CALLER
exit /b %exists%

