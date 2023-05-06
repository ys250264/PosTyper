
UPDATE [GLB_LocalizedResourceData]
SET DATA = (
	SELECT DATA FROM [GLB_LocalizedResourceData_english]
	WHERE [GLB_LocalizedResourceData].ID = [GLB_LocalizedResourceData_english].ID
	);

UPDATE [MenuItemDescription]
SET VALUE = (
	SELECT VALUE FROM [MenuItemDescription_english]
    WHERE [MenuItemDescription].MenuItemFk = [MenuItemDescription_english].MenuItemFk
	AND [MenuItemDescription].Culture = [MenuItemDescription_english].Culture
	);