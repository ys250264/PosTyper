
UPDATE [GLB_LocalizedResourceData]
SET DATA = (
	SELECT DATA FROM [GLB_LocalizedResourceData_dutch]
	WHERE [GLB_LocalizedResourceData].ID = [GLB_LocalizedResourceData_dutch].ID
	);

UPDATE [MenuItemDescription]
SET VALUE = ( 
	SELECT VALUE FROM [MenuItemDescription_dutch]
    WHERE [MenuItemDescription].MenuItemFk = [MenuItemDescription_dutch].MenuItemFk
    AND [MenuItemDescription].Culture = [MenuItemDescription_dutch].Culture
	);
