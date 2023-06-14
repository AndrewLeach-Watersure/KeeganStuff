--removed, noconformities aren't used, will reinstate when use again.

DECLARE
    @wo NVARCHAR(80)
    ,@object NVARCHAR(80)
    ,@sqlid nvarchar(8)
    ,@noco nvarchar(8)
    ,@notes NVARCHAR(1000)
    ,@recorded NVARCHAR(80)
    ,@recordedBy NVARCHAR(80);

BEGIN

    SELECT
        @wo = NCO_WORKORDER
        ,@sqlid = :rowid
        ,@noco = NCO_PK
        ,@object = NCF_OBJECT
    FROM R5NONCONFORMOBSERVATIONS
    LEFT OUTER JOIN R5NONCONFORMITIES ON NCF_CODE = NCO_CODE
    WHERE NCO_SQLIDENTITY = :rowid


    SELECT 
        @notes = COALESCE(@notes + ',', '') + ACK_NOTES --@notes isn't retrieved earlier and there is no update version of this, 
        ,@recorded = max(ACK_UPDATED)
        ,@recordedBy = max(ACK_UPDATEDBY)
    FROM R5ACTCHECKLISTS
    WHERE ACK_EVENT = @wo
        AND ACK_OBJECT = @object
        AND ACK_NONCONFORMITYFOUND = '+'
    GROUP BY ACK_NOTES,ACK_UPDATEDBY
    ORDER BY ACK_UPDATEDBY

    UPDATE R5NONCONFORMOBSERVATIONS
    SET NCO_NOTE = @notes
        ,NCO_RECORDED = @recorded
        ,NCO_RECORDEDBY = @recordedBy
    WHERE NCO_SQLIDENTITY = @sqlid
END
