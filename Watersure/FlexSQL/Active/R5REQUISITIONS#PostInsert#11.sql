DECLARE 
	@evnt nvarchar(30),
	@Wmrc nvarchar(20),
    @mrc nvarchar(20);

BEGIN
	SELECT @evnt = REQ_EVENT
		  ,@mrc = REQ_UDFCHAR11
		FROM R5REQUISITIONS 
		WHERE REQ_SQLIDENTITY = :rowid;

	IF @evnt <> ' ' 
	BEGIN
		SELECT  @Wmrc = EVT_MRC
		FROM R5EVENTS 
		WHERE EVT_CODE = @evnt;
				
		IF @mrc IS NULL 
			SET @mrc = @Wmrc;
	END	

	IF @mrc <> @Wmrc AND @evnt IS NOT NULL 
		BEGIN	--Raise error when Requisition Department does not match WO Department
		RAISERROR('Requisition Department does not match WO department.',16,1);
		END

    UPDATE R5REQUISITIONS
    SET 
    REQ_UDFCHAR20 = NULL, --Group A Approver
    REQ_UDFCHAR21 = NULL, --Group B Approver
    REQ_UDFCHAR22 = NULL, --Group C Approver
    REQ_ORIGIN = COALESCE(REQ_ORIGIN, REQ_ENTEREDBY),
    REQ_UDFCHAR09 = COALESCE(REQ_ORIGIN, REQ_ENTEREDBY),
    REQ_UDFCHAR10 = REQ_STATUS,
    REQ_UDFCHKBOX01 = '-', --Group A Approved
    REQ_UDFCHKBOX02 = '-', --Group B Approved
    REQ_UDFCHKBOX03 = '-',  --Group C Approved
    REQ_UDFCHAR08 = (SELECT COM_UDFCHAR01 FROM R5COMPANIES WHERE COM_CODE = REQ_FROMCODE),
    REQ_UDFCHAR11 = @mrc
    WHERE REQ_SQLIDENTITY=:rowid

END
