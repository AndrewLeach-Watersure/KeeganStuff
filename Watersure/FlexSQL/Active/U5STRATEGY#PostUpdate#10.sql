

DECLARE
@v_id integer,
@user nvarchar(30),
@team nvarchar(30),
@bdgClass nvarchar(30),
@class nvarchar(30),
@owner nvarchar(30),
@delegate nvarchar(30),
@role nvarchar(30),
@assetMan nvarchar(30);

EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;
EXECUTE @v_id = O7SESS_CUR_ROLE @role OUTPUT;

SELECT
@team = STR_TEAM 
,@owner = STR_OWNER
,@delegate = STR_DELEGATE
,@assetMan = STR_ASSETMAN

FROM U5STRATEGY
WHERE U5STRATEGY.SQLIDENTITY = :rowid

IF( @owner is null)
    BEGIN
        RAISERROR('Owner cannot be null',16,1);
    END
IF( @assetMan is null)
    BEGIN
        RAISERROR('Asset Manager cannot be null',16,1);
    END
IF( @team is null)
    BEGIN
        RAISERROR('Team cannot be null',16,1);
    END
IF( @user NOT IN (@owner,@assetMan,'GBAUD') AND @role <> 'WTS-ADMIN')
    BEGIN
        RAISERROR('You cannot update this Strategy',16,1);
    END
