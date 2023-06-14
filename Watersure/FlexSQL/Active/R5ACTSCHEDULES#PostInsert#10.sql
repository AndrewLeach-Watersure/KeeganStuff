DECLARE 
    @evnt NVARCHAR(30),
    @resp NVARCHAR(30);

BEGIN
        SET @evnt = ' ';

        SELECT  @resp = ACS_RESPONSIBLE
                ,@evnt = ACS_EVENT 
        FROM R5ACTSCHEDULES 
        WHERE ACS_SQLIDENTITY = :rowid;

        IF @evnt <> ' ' 
        BEGIN
            UPDATE R5EVENTS 
            SET EVT_PERSON = COALESCE(EVT_PERSON,@resp)
            WHERE EVT_CODE = @evnt;
        END
END
