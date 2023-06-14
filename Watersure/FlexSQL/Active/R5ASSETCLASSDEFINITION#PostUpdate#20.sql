DECLARE
    @class nvarchar(15),
    @designlife nvarchar(30),
    @rowid nvarchar(20);

SELECT
    @class = OCD_CLASS
    ,@designlife = OCD_SERVICELIFE
FROM R5ASSETCLASSDEFINITION
WHERE OCD_SQLIDENTITY = :rowid

UPDATE TOP(500) R5OBJECTS
    SET OBJ_UDFNUM01 = @designlife
    WHERE OBJ_CLASS = @class  
        AND (OBJ_UDFNUM01 <> @designlife 
                OR OBJ_UDFNUM01 IS NULL)

