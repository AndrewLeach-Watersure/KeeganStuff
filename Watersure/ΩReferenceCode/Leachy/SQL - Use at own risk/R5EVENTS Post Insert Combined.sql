DECLARE
	@v_id   integer,
	@user   nvarchar(100),
	@dept  nvarchar(8),
	@type nvarchar(10);

EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;

BEGIN 
	SELECT 
		@dept = EVT_MRC
	   ,@type = EVT_JOBTYPE
	FROM R5EVENTS 
	WHERE EVT_SQLIDENTITY = :rowid;

	IF ( @dept = '*' AND @type != 'MEC')
		BEGIN
			RAISERROR('You need to select a department.                    Note: Changing the Equipment will cause the department to reset', 16, 1);
		END
END
			/* Code to get Execution Team from PM when PM is created */
DECLARE
	@pm   nvarchar(100),
	@exec  nvarchar(8),	
	@evnt nvarchar(10);
BEGIN
	SELECT 
		 @evnt = EVT_CODE
		,@pm = EVT_PPM 
	FROM R5EVENTS 
	WHERE EVT_SQLIDENTITY = :rowid

IF (@pm IS NOT NULL)
	BEGIN
		SELECT 
			@exec = PPM_UDFCHAR04 
		FROM R5PPMS 
		WHERE @pm = PPM_CODE
			
		UPDATE R5EVENTS
		SET EVT_UDFCHAR21 = @exec 
		WHERE EVT_SQLIDENTITY = :rowid;
	END
END

