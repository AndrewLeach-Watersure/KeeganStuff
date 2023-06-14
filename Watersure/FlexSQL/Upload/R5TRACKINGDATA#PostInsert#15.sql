DECLARE
@v_id   integer,
@transcode nvarchar(80),
@PD1 nvarchar(80),
@PD2 nvarchar(80),
@PD5 nvarchar(80),
@PD8 nvarchar(80),
@PD11 nvarchar(80),
@PD13 nvarchar(80),
@PD15 nvarchar(80),
@PD17 nvarchar(80),
@PD18 nvarchar(80),
@PD20 datetime,
@PD21 nvarchar(80),
@PD22 nvarchar(80),
@user nvarchar(80);

EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;

BEGIN
SELECT
@PD1 = tkd_promptdata1,
@PD2 = tkd_promptdata2,
@PD8 = tkd_promptdata8,
@PD5 = tkd_promptdata5,
@PD11 = tkd_promptdata11,
@PD13 = tkd_promptdata13,
@PD15 = tkd_promptdata15,
@PD17 = tkd_promptdata17,
@PD18 = tkd_promptdata18,
@PD20 = tkd_promptdata20,
@PD21 = tkd_promptdata21,
@PD22 = tkd_promptdata22
FROM R5TRACKINGDATA
WHERE tkd_sqlidentity = :rowid
AND tkd_trans = 'UPLO' and tkd_promptdata1 = 'CHOP';

IF(@PD1 = 'CHOP')
BEGIN
UPDATE R5actchecklists
SET      ACK_COMPLETED = CASE WHEN @PD8 = '01' THEN @PD11 ELSE NULL END
        ,ACK_YES = CASE WHEN @PD8 = '02' AND @PD11 = '+' THEN '+'
                        WHEN @PD8 = '02' AND @PD11 = '-' THEN '-'
                        ELSE NULL END
        ,ACK_NO = CASE WHEN @PD8 = '02' AND @PD11 = '-' THEN '+'
                       WHEN @PD8 = '02' AND @PD11 = '+' THEN '-'
                       ELSE NULL END
        ,ACK_GOOD = CASE WHEN @PD8 = '08' AND @PD11 = '+' THEN '+'
                        WHEN @PD8 = '08' AND @PD11 = '-' THEN '-'
                        ELSE NULL END
        ,ACK_POOR = CASE WHEN @PD8 = '08' AND @PD11 = '-' THEN '+'
                        WHEN @PD8 = '08' AND @PD11 = '+' THEN '-'
                        ELSE NULL END
        ,ACK_OK = CASE WHEN @PD8 IN ('07','09','10','11','12') AND @PD11 = '+' THEN '+'
                       WHEN @PD8 IN ('07','09','10','11','12') AND @PD11 = '-' THEN '-'
                       ELSE NULL END
        ,ACK_REPAIRSNEEDED = CASE WHEN @PD8 = '07' AND @PD11 = '-' THEN '+'
                                  WHEN @PD8 = '07' AND @PD11 = '+' THEN '-'
                                  ELSE NULL END
        ,ACK_ADJUSTED = CASE WHEN @PD8  IN ('09','10') AND @PD11 = '-' THEN '+'
                             WHEN @PD8 IN ('09','10') AND @PD11 = '+' THEN '-'
                                  ELSE NULL END
        ,ACK_NONCONFORMITYFOUND = CASE WHEN @PD8  IN ('11','12') AND @PD11 = '-' THEN '+'
                                       WHEN @PD8 IN ('11','12') AND @PD11 = '+' THEN '-'
                                       ELSE NULL END
        ,ACK_FINDING = CASE WHEN @PD8  IN ('03','06') THEN @PD13
                            ELSE NULL END
        ,ACK_RESOLUTION = CASE WHEN @PD8 = '07' THEN @PD13
                            ELSE NULL END
        ,ACK_VALUE = CASE WHEN ACK_TYPE IN ('04','05','06','10','12') THEN @PD15
              ELSE null END
        ,ACK_NOTES = @PD17
        ,ACK_FOLLOWUP = @PD18
        ,ACK_UPDATEDBY = @user
        ,ACK_UPDATED = COALESCE(@PD20, GETDATE())
        ,ACK_EVENT = @PD21
        ,ACK_ACT = @PD22
WHERE ACK_CODE = @PD2
END 
IF(@PD1 = 'CHOP')
BEGIN
UPDATE R5OPERATORCHECKLISTS 
SET OCK_RSTATUS = 'C',
OCK_STATUS = 'C',
OCK_ENDDATE = COALESCE(@PD20, GETDATE())
WHERE OCK_CODE = @PD5
END

DELETE FROM r5trackingdata
WHERE tkd_sqlidentity = :rowid AND tkd_trans = 'UPLO' and tkd_promptdata1 = 'CHOP' ;
END
