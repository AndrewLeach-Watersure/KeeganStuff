DECLARE
  @dept  nvarchar(8),
  @team nvarchar(8),
  @type nvarchar(10),
  @pm   nvarchar(100),
  @exec  nvarchar(8),
  @portfolio nvarchar(32),
  @evnt nvarchar(10),
  @pri nvarchar(5),
  @proj nvarchar(80),
  @status nvarchar(5);
BEGIN

  	SELECT
		@dept = EVT_MRC,
		@type = EVT_JOBTYPE,
		@team = EVT_UDFCHAR21,
		@evnt = EVT_CODE,
		@pm = EVT_PPM,
    	@pri = EVT_PRIORITY,
    	@status = EVT_STATUS,
		@proj = EVT_UDFCHAR08
	FROM R5EVENTS
	WHERE EVT_SQLIDENTITY = :rowid;

	IF ( @dept = '*' AND @type != 'MEC')
   	BEGIN
     		RAISERROR('You need to select a department.                    Note: Changing the Equipment will cause the department to reset', 16, 1);
    	END
	ELSE IF (@pm IS NULL AND @team IS NULL and @type != 'MEC')
	BEGIN
     		RAISERROR('You need to select an Execution Team.', 16, 1); --Why is this exclusive to Insert of non-PM WO's
	END
	ELSE
	BEGIN
		IF (@proj IS NOT NULL)
		BEGIN
			UPDATE R5EVENTS
			SET
				EVT_PROJECT = @proj
				,EVT_PROJBUD = (SELECT TOP 1 PCL_PROJBUD FROM R5PROJBUDCLASSES WHERE PCL_PROJECT = @proj)
				,EVT_UDFCHAR08 = NULL
			WHERE EVT_SQLIDENTITY = :rowid;
		END
	END
  IF (@pri = 'BD' AND @team NOT IN ('EI','MECH'))
    BEGIN
      RAISERROR('Only EI and Mech are setup to respond to breakdowns. Change Execution team to EI or Mech or contact control room.', 16, 1);
    END

END
