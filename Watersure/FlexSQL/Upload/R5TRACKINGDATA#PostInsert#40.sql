DECLARE
@v_id   integer,
@transcode nvarchar(80),
@promptdata1 nvarchar(80),
@WKD_DATE nvarchar(80),
@WKD_MRC nvarchar(80),
@WKD_JOBTYPE nvarchar(80),
@WKD_ISSUED nvarchar(80),
@WKD_CLOSED nvarchar(80),
@WKD_TODATEOVERDUE nvarchar(80),
@i nvarchar(1),
@user nvarchar(80);

EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;

BEGIN

SELECT
@promptdata1 = tkd_promptdata1,
@WKD_DATE = tkd_promptdata2,
@WKD_MRC = tkd_promptdata3,
@WKD_JOBTYPE = tkd_promptdata4,
@WKD_ISSUED = tkd_promptdata5,
@WKD_CLOSED = tkd_promptdata6,
@WKD_TODATEOVERDUE = tkd_promptdata7,
@transcode = tkd_trans

FROM R5TRACKINGDATA
WHERE tkd_sqlidentity = :rowid
AND tkd_trans = 'UPLO' AND tkd_promptdata1 = 'WKD';

IF (@transcode = 'UPLO' AND @promptdata1 = 'WKD')
  BEGIN
  SELECT @i = COUNT(*) FROM U5U5EVENTKPI WHERE WKD_DATE = @WKD_DATE AND @WKD_MRC = WKD_MRC AND @WKD_JOBTYPE = WKD_JOBTYPE
  IF (@i = 1)
      BEGIN
      UPDATE U5U5EVENTKPI
      SET WKD_ISSUED = @WKD_ISSUED
      ,WKD_CLOSED = @WKD_CLOSED
      ,WKD_TODATEOVERDUE = @WKD_TODATEOVERDUE
      WHERE WKD_DATE = @WKD_DATE AND @WKD_MRC = WKD_MRC AND @WKD_JOBTYPE = WKD_JOBTYPE
      END
  IF (@i = 0)
      BEGIN
            INSERT INTO U5U5EVENTKPI(WKD_DATE,WKD_MRC,WKD_JOBTYPE,WKD_ISSUED,WKD_CLOSED,WKD_TODATEOVERDUE,CREATEDBY,CREATED,LASTSAVED)
      VALUES(@WKD_DATE,@WKD_MRC,@WKD_JOBTYPE,@WKD_ISSUED,@WKD_CLOSED,@WKD_TODATEOVERDUE,@user,GETDATE(),GETDATE())
      END
  END

DELETE FROM r5trackingdata
WHERE tkd_sqlidentity = :rowid AND tkd_trans = 'UPLO' AND @promptdata1 = 'WKD' ;

END;
