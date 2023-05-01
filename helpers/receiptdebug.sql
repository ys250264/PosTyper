
UPDATE
       Receipt_LayoutLineTemplate
SET
       Layout = REPLACE(
       Layout,
       '<Lines>', 
       '<Lines><Line Align="Center"><TextContainer><TextElement>*** ' +
       LineDefinitionName +
       ' ***</TextElement></TextContainer></Line>'
       )
WHERE
       Layout NOT LIKE '%*** ' +
       LineDefinitionName + 
        ' ***%';
