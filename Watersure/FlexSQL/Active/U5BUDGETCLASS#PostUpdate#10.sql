DECLARE
@v_id integer,
@user nvarchar(30),
@strat nvarchar(30),
@bdgClass nvarchar(30),
@class nvarchar(30),
@owner nvarchar(30),
@delegate nvarchar(30),
@role nvarchar(30),
@assetMan nvarchar(30);

EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;
EXECUTE @v_id = O7SESS_CUR_ROLE @role OUTPUT;

    SELECT
        @strat = STR_CODE
        ,@owner = STR_OWNER
        ,@delegate = STR_DELEGATE
        ,@assetMan = STR_ASSETMAN
    FROM U5BUDGETCLASS
    LEFT OUTER JOIN U5STRATEGY ON BCL_STRATEGY = STR_CODE
    WHERE U5BUDGETCLASS.SQLIDENTITY = :rowid

IF( @user NOT IN (@owner,@assetMan) AND @role <> 'WTS-ADMIN')
    BEGIN
        RAISERROR('You cannot update this Budget Class please raise a helpdesk request.',16,1);
    END
