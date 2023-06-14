DECLARE
@v_id integer,
@user nvarchar(100),
@group nvarchar(100),
@transcode nvarchar(80),
@promptdata1 nvarchar(80),
@evt NVARCHAR(80),
@mrc NVARCHAR(80),
@i nvarchar(1);

EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;
SELECT @group = USR_GROUP FROM R5USERS WHERE USR_CODE = @user;

BEGIN

SELECT
@promptdata1 = tkd_promptdata1,
@evt = tkd_promptdata2,
@mrc = tkd_promptdata3,
@transcode = tkd_trans

FROM R5TRACKINGDATA
WHERE tkd_sqlidentity = :rowid
AND tkd_trans = 'UPLO' AND tkd_promptdata1 = 'WOCC';

IF(@group <> 'ADMIN' AND @transcode = 'UPLO' AND @promptdata1 = 'WOCC')
BEGIN
RAISERROR('Admin Only Upload, send to service desk.',16,1)
END

IF (@transcode = 'UPLO' AND @promptdata1 = 'WOCC')
  BEGIN
      UPDATE R5EVENTS
        SET EVT_MRC = @mrc,
            EVT_UDFCHAR45 = @mrc
        WHERE EVT_CODE = @evt 

    END

DELETE FROM r5trackingdata
WHERE tkd_sqlidentity = :rowid AND tkd_trans = 'UPLO' AND @promptdata1 = 'WOCC' ;

END;

