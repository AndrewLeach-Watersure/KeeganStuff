BEGIN
    DECLARE
        @v_id integer,
        @user nvarchar(30),
        @class nvarchar(6),
        @bdgclass nvarchar(6),
        @strat nvarchar(6),
        @owner nvarchar(16),
        @delegate nvarchar(16),
        @assetMan nvarchar(16),
        @rowid nvarchar(20);

    EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;

    SELECT
        @class = OCD_CLASS
        ,@bdgclass = OCD_UDFCHAR01
        ,@strat = OCD_UDFCHAR02
        ,@owner = OCD_UDFCHAR03
    FROM R5ASSETCLASSDEFINITION
    WHERE OCD_SQLIDENTITY = :rowid

    SELECT
        @owner = STR_OWNER
        ,@delegate = STR_DELEGATE
        ,@assetMan = STR_ASSETMAN
    FROM  U5STRATEGY
    WHERE STR_CODE = @strat

     IF (@class LIKE '%-X')
        BEGIN
            RAISERROR('Class can only have positions, please make changes and upload again',16,1);
        END 

   IF(@bdgclass is null)
        BEGIN
            RAISERROR('Budget class cannot be null',16,1);
        END

    IF(@strat is null)
        BEGIN
            RAISERROR('Strategy cannot be null',16,1);
        END

    IF(@owner is null)
        BEGIN
            RAISERROR('Owner cannot be null',16,1);
        END
        
    IF(@user NOT IN (@owner,@assetMan,'GBAUD','ALEACH','MALI'))
        BEGIN
            RAISERROR('You cannot update this Class definition, please raise a helpdesk request.',16,1);
        END

END

