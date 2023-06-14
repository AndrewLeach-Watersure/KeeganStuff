DECLARE
	@v_id integer,
	@user nvarchar(30),
	@class nvarchar(6),
	@bdgclass nvarchar(6),
	@strat nvarchar(6),
	@owner nvarchar(16),
	@type nvarchar(6),
	@rowid nvarchar(20),
	@delegate nvarchar(30),
	@status nvarchar(30),
	@assetMan nvarchar(30);

EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;

BEGIN

	SELECT
		@strat = OBJ_UDFCHAR39
		,@type = OBJ_OBTYPE
		,@class = OBJ_CLASS
		,@bdgclass = OBJ_UDFCHAR34
		,@owner = OBJ_UDFCHAR32
		,@status = OBJ_STATUS
	FROM R5OBJECTS
	WHERE OBJ_SQLIDENTITY = :rowid

	SELECT
		@owner = STR_OWNER
		,@delegate = STR_DELEGATE
		,@assetMan = STR_ASSETMAN
	FROM  U5STRATEGY
	WHERE STR_CODE = @strat


	IF( @bdgclass is null AND @type IN ('P','GP','SP','S') AND @status <> 'D')
			BEGIN
			RAISERROR('Budget class cannot be null',16,1);
			END
	IF( @class is null AND @type IN ('P','GP','SP','S') AND @status <> 'D')
			BEGIN
			RAISERROR('Class cannot be null',16,1);
			END
	IF( @strat is null AND @type IN ('P','GP','SP','S') AND @status <> 'D')
			BEGIN
			RAISERROR('Strategy cannot be null',16,1);
			END
	IF( @owner is null AND @type IN ('P','GP','SP','S') AND @status <> 'D')
			BEGIN
			RAISERROR('Owner cannot be null',16,1);
			END
END
