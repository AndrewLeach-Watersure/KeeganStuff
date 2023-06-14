DECLARE
@v_id integer,
@user nvarchar(100),
@group nvarchar(100),
@transcode nvarchar(80),
@promptdata1 nvarchar(80),
@wo NVARCHAR(80),
@project NVARCHAR(80),
@projbud NVARCHAR(80),
@status NVARCHAR(80),
@jobtype NVARCHAR(80),
@type NVARCHAR(80),
@desc NVARCHAR(80),
@ppmrev NVARCHAR(80),
@pm NVARCHAR(80);


EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;
SELECT @group = USR_GROUP FROM R5USERS WHERE USR_CODE = @user;

BEGIN

SELECT
    @promptdata1 = tkd_promptdata1,
    @wo = tkd_promptdata2,
    @project = COALESCE(tkd_promptdata3,EVT_PROJECT),
    @projbud = COALESCE(tkd_promptdata4,EVT_PROJBUD),
    @status = COALESCE(tkd_promptdata5,EVT_STATUS),
    @jobtype = COALESCE(tkd_promptdata6,EVT_JOBTYPE),
    @pm = COALESCE(tkd_promptdata7,EVT_PPM),
    @type = COALESCE(tkd_promptdata8,EVT_TYPE),
    @ppmrev = COALESCE(tkd_promptdata9,EVT_PPMREV),
    @desc = COALESCE(tkd_promptdata10,EVT_DESC),
    @transcode = tkd_trans

FROM R5TRACKINGDATA
LEFT OUTER JOIN R5EVENTS ON EVT_CODE = tkd_promptdata2
WHERE tkd_sqlidentity = :rowid
AND tkd_trans = 'UPLO' AND tkd_promptdata1 = 'WO_Update';

IF(@group <> 'ADMIN' AND @transcode = 'UPLO' AND @promptdata1 = 'WO_Update')
BEGIN
RAISERROR('Admin Only Upload, send to service desk.',16,1)
END

IF (@transcode = 'UPLO' AND @promptdata1 = 'WO_Update')
  BEGIN
    UPDATE R5EVENTS
        SET EVT_PROJECT = @project,
            EVT_PROJBUD = @projbud,
            EVT_STATUS = @status,
            EVT_JOBTYPE = @jobtype,
            EVT_PPM = @pm,
            EVT_TYPE = @type,
            EVT_RTYPE = @type,
            EVT_PPMREV = @ppmrev,
            EVT_DESC = @desc
    WHERE EVT_CODE = @wo
END

DELETE FROM r5trackingdata
WHERE tkd_sqlidentity = :rowid AND tkd_trans = 'UPLO' AND @promptdata1 = 'WO_Update' ;

END;
