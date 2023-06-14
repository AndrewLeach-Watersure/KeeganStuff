BEGIN
    DECLARE
        @class nvarchar(6),
        @bdgclass nvarchar(6),
        @strat nvarchar(6),
        @owner nvarchar(16),
        @rowid nvarchar(20);

    SELECT
        @class = OCD_CLASS
        ,@bdgclass = OCD_UDFCHAR01
        ,@strat = OCD_UDFCHAR02
        ,@owner = OCD_UDFCHAR03
    FROM R5ASSETCLASSDEFINITION
    WHERE OCD_SQLIDENTITY = :rowid


    IF( @bdgclass is null)
        BEGIN
            RAISERROR('Budget class cannot be null',16,1);  
        END

    IF( @strat is null)
        BEGIN
        RAISERROR('Strategy cannot be null',16,1);
        END
    IF( @owner is null)
        BEGIN
            RAISERROR('Owner cannot be null',16,1);
        END

END
