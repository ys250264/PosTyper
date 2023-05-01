
UPDATE
       Receipt_LayoutLineTemplate
SET
       Layout = REPLACE(
       Layout,
       '<Lines><Line Align="Center"><TextContainer><TextElement>*** ' +
       LineDefinitionName +
       ' ***</TextElement></TextContainer></Line>',
       '<Lines>' 
       )
WHERE
       Layout LIKE '%*** ' +
       LineDefinitionName + 
        ' ***%';
