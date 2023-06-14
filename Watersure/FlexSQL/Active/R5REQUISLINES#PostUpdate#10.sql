DECLARE	
    @code nvarchar(30),
	@evnt nvarchar(30),
	@Wmrc nvarchar(20),
	@mrc nvarchar(20);

BEGIN  
	SELECT  @code = RQL_REQ
			,@evnt = RQL_EVENT
			,@mrc = RQL_UDFCHAR05
			,@Wmrc = NULL
                  
		FROM R5REQUISLINES 
		WHERE RQL_SQLIDENTITY = :rowid;

    IF @evnt <> ' ' --If there is a WO get Cost center from WO, if cost center is blank overwrite is with WO
        BEGIN
            SELECT @Wmrc = EVT_MRC FROM R5EVENTS WHERE EVT_CODE = @evnt;
            IF @mrc IS NULL SET @mrc = @Wmrc;	
            UPDATE R5REQUISLINES SET RQL_UDFCHAR05 = @mrc WHERE RQL_SQLIDENTITY = :rowid;
        END	

    IF @mrc <> @Wmrc AND @evnt IS NOT NULL
            BEGIN	--Raise error when Requisition Department does not match WO Department
            RAISERROR('Requisition Line Department does not match WO department. No Updates Allowed',16,1);
            END

    UPDATE R5REQUISLINES  --Get Ordering GL Code for Stock Part orders
        SET RQL_COSTCODE = PAR_UDFCHAR03
        FROM R5REQUISLINES 
        LEFT OUTER JOIN R5PARTS ON RQL_PART = PAR_CODE
        WHERE RQL_TYPE = 'PS' AND RQL_STATUS = 'U' AND RQL_SQLIDENTITY = :rowid


END
