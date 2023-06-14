DECLARE
@v_id   integer,
@transcode nvarchar(80),
@uploadCode nvarchar(80),
@OBS_POSITION nvarchar(80),
@OBS_SETTINGID nvarchar(80),
@OBS_NAME nvarchar(80),
@OBS_UNIT nvarchar(80),
@OBS_DEFAULT_VALUE nvarchar(80),
@OBS_CURRENT_VALUE nvarchar(80),
@user nvarchar(80),
@Delete nvarchar(80);

EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;

BEGIN
SELECT
@uploadCode = tkd_promptdata1,
@OBS_POSITION = tkd_promptdata2,
@OBS_SETTINGID = tkd_promptdata3,
@OBS_NAME = tkd_promptdata4,
@OBS_UNIT = tkd_promptdata5,
@OBS_DEFAULT_VALUE = tkd_promptdata6,
@OBS_CURRENT_VALUE = tkd_promptdata7,
@Delete = tkd_promptdata8

FROM R5TRACKINGDATA
WHERE tkd_sqlidentity = :rowid
AND tkd_trans = 'UPLO' and tkd_promptdata1 = 'SETT';

IF(@uploadCode = 'SETT' AND @Delete IS NULL)
BEGIN
  UPDATE U5OBJSETTINGS
  SET OBS_NAME = @OBS_NAME,
  OBS_UNIT = @OBS_UNIT,
  OBS_DEFAULT_VALUE = @OBS_DEFAULT_VALUE,
  OBS_CURRENT_VALUE = @OBS_CURRENT_VALUE
  WHERE OBS_POSITION =  @OBS_POSITION AND OBS_SETTINGID = @OBS_SETTINGID
  IF ((SELECT COUNT(SQLIDENTITY) FROM U5OBJSETTINGS WHERE OBS_POSITION =  @OBS_POSITION AND OBS_SETTINGID = @OBS_SETTINGID) = 0)
      BEGIN
      INSERT INTO U5OBJSETTINGS(OBS_POSITION,OBS_SETTINGID,OBS_NAME,OBS_UNIT,OBS_DEFAULT_VALUE,OBS_CURRENT_VALUE,CREATEDBY,CREATED,LASTSAVED)
      VALUES(@OBS_POSITION,@OBS_SETTINGID,@OBS_NAME,@OBS_UNIT,@OBS_DEFAULT_VALUE,@OBS_CURRENT_VALUE,@user,GETDATE(),GETDATE())
      END
END
IF(@uploadCode = 'SETT' AND @Delete IS NOT NULL AND @user IN ('BLEE','DFRISWELL','ALEACH'))
BEGIN
DELETE FROM U5OBJSETTINGS
WHERE OBS_POSITION =  @OBS_POSITION AND OBS_SETTINGID = @OBS_SETTINGID
END

DELETE FROM r5trackingdata
WHERE tkd_sqlidentity = :rowid AND tkd_trans = 'UPLO' and @uploadCode = 'SETT' ;
END
