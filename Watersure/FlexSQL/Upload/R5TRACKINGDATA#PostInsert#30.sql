DECLARE
    @transcode nvarchar(80),
    @pd1 nvarchar(80),
    @pd2 nvarchar(80),
    @pd3 nvarchar(80),
    @pd4 nvarchar(80),
    @pd5 nvarchar(80),
    @i nvarchar(1);

BEGIN
SELECT
@pd1 = tkd_promptdata1,
@pd2 = tkd_promptdata2,
@pd3 = tkd_promptdata3,
@pd4 = tkd_promptdata4,
@pd5 = tkd_promptdata5,
@transcode = tkd_trans

FROM R5TRACKINGDATA
WHERE tkd_sqlidentity = :rowid
AND tkd_trans = 'UPLO' AND tkd_promptdata1 = 'DAE';

IF (@transcode = 'UPLO' AND @pd1 = 'DAE')
    BEGIN
    SELECT @i = COUNT(*) FROM R5DOCENTITIES WHERE DAE_DOCUMENT = @pd2 AND DAE_CODE = @pd4

     IF (@i = 0)
        BEGIN
        INSERT INTO R5DOCENTITIES(DAE_DOCUMENT,DAE_ENTITY,DAE_RENTITY,DAE_TYPE,DAE_RTYPE,DAE_CODE,DAE_COPYTOWO,DAE_PRINTONWO,DAE_COPYTOPO,DAE_PRINTONPO)
        VALUES( @pd4,@pd2,@pd2,@pd3,@pd3,@pd5,'-','-','-','-')
        END
    END

DELETE FROM r5trackingdata
WHERE tkd_sqlidentity = :rowid AND tkd_trans = 'UPLO' AND @pd1 = 'DAE' ;

END;

