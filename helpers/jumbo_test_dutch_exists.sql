select max
	(
		case
		when table_schema = 'dbo' and table_name = 'GLB_LocalizedResourceData_dutch'
			then 1
			else 0
		end
	) as TableExists
from information_schema.tables;

