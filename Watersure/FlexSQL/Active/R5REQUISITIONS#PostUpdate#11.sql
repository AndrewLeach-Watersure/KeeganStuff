DECLARE @v_id INTEGER
      , @user NVARCHAR(100)
      , @org NVARCHAR(15)
      , @status NVARCHAR(4)
      , @oldstatus NVARCHAR(4) 
      , @role NVARCHAR(30)
      , @requestedby NVARCHAR(15)
      , @oldrequested NVARCHAR(80)
      , @linemgr NVARCHAR(30)
      , @reqorg NVARCHAR(15)
      , @reqnum NVARCHAR(30)
      , @topapprgrp NVARCHAR(8)
      , @usrapprgrp NVARCHAR(8)
      , @apprlimit NUMERIC(24, 6)
      , @limitlevel NVARCHAR(1)
      , @reqvalue NUMERIC(24, 6)
      ,	@evnt nvarchar(30)
      ,	@Wmrc nvarchar(20)
      , @mrc nvarchar(20);

EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;
EXECUTE @v_id = O7SESS_CUR_ROLE @role OUTPUT;

BEGIN
SELECT  @org = REQ_ORG
      , @status = REQ_STATUS
      , @oldstatus = REQ_UDFCHAR10
      , @requestedby = REQ_ORIGIN
      , @oldrequested = REQ_UDFCHAR09
      , @reqorg = req_org
      , @reqnum = req_code
      , @evnt = REQ_EVENT
	    , @mrc = REQ_UDFCHAR11
FROM R5REQUISITIONS
WHERE REQ_SQLIDENTITY = :rowid;

IF ( @user NOT IN ( SELECT USR_CODE FROM R5USERORGANIZATION, R5AUTH, R5USERS
                       WHERE UOG_GROUP=AUT_GROUP AND UOG_USER=USR_CODE
                         AND UOG_ORG=@org AND USR_CLASS IS NOT NULL AND AUT_ENTITY='REQ'
                         AND AUT_TYPE='+' AND AUT_STATUS='R' AND AUT_STATNEW='APPR'
                      UNION ALL
                      SELECT AUT_USER FROM R5AUTH WHERE AUT_ENTITY='REQ' AND AUT_TYPE='-'
                         AND AUT_STATUS='R' AND AUT_STATNEW='APPR'
                      UNION ALL
                      SELECT USR_CODE FROM R5USERORGANIZATION, R5USERS
                       WHERE UOG_USER=USR_CODE AND UOG_ORG = @org AND USR_CLASS IS NOT NULL
                         AND UOG_GROUP = 'STOREMGR')
       AND @oldstatus='R' )
    RAISERROR('You do not have security rights to edit Authorised requisitions.', 16, 1);

IF (@role <> 'WTS-FINANCE' AND @oldstatus = 'AUTH' AND @status != 'RQST') 
    BEGIN 
      RAISERROR ('You do not have security rights to edit Authorised requisitions.', 16, 1);
    END

IF (@role <> 'WTS-FINANCE'
  AND (@requestedby != @oldrequested OR @requestedby IS NULL)
  AND @oldrequested IS NOT NULL AND @status NOT IN ('RQST')) 
    BEGIN
      RAISERROR ('You do not have security rights to edit the Requested By field.', 16, 1);
    END

------------------Main Approval Process------------------------------------------------

IF (@status = 'APPR') 
BEGIN

  SELECT  @usrapprgrp = USR_CLASS
        , @linemgr = USR_UDFCHAR01
        , @topapprgrp = 'GROUP A'
    FROM R5USERS
    WHERE USR_CODE = @user;

  SELECT @apprlimit = ISNULL(MAX(UOG_REQAUTHAPPVLIMIT), 0)
    FROM R5USERORGANIZATION
    WHERE UOG_USER = @user AND UOG_ORG = @reqorg;

  SELECT @limitlevel = INS_DESC FROM R5INSTALL WHERE INS_CODE = 'LIMITLEV'; 

  IF (@limitlevel = 'L') --Approval Limit is per line
    SELECT @reqvalue = MAX(CASE RQL_RTYPE WHEN 'SF' THEN RQL_PRICE ELSE RQL_QTY * RQL_PRICE END / ISNULL(RQL_EXCH, 1))
    FROM R5REQUISLINES
    WHERE RQL_REQ = @reqnum
      AND RQL_RSTATUS NOT IN ('J', 'C');
  ELSE --Approval Limit is total Req
    SELECT @reqvalue = SUM(CASE RQL_RTYPE WHEN 'SF' THEN RQL_PRICE ELSE RQL_QTY * RQL_PRICE END / ISNULL(RQL_EXCH, 1))
    FROM R5REQUISLINES
    WHERE RQL_REQ = @reqnum
      AND RQL_RSTATUS NOT IN ('J', 'C');

IF (@apprlimit >= @reqvalue) --Approve Req and Req Lines
  BEGIN
      UPDATE R5REQUISITIONS
      SET   REQ_STATUS = 'A'
          , REQ_RSTATUS = 'A'
          , REQ_AUTH = @user
          , REQ_DATEAPPROVED = GETDATE()
      WHERE REQ_CODE = @reqnum;

      UPDATE R5REQUISLINES
      SET RQL_STATUS = 'A'
      , RQL_RSTATUS = 'A'
      , RQL_ACTIVE = '+'
      WHERE RQL_REQ = @reqnum
          AND RQL_RSTATUS = 'U';
  END
ELSE IF (@usrapprgrp = @topapprgrp) --Limit above top approver limit, set Req to "Awaiting Higher Approval"
    BEGIN
      UPDATE R5REQUISITIONS
      SET REQ_STATUS = 'UNAP'
        , REQ_RSTATUS = 'A'
        , REQ_AUTH = @user
        , REQ_DATEAPPROVED = GETDATE()
      WHERE REQ_CODE = @reqnum;

      UPDATE R5REQUISLINES
      SET RQL_STATUS = 'UNAP'
        , RQL_RSTATUS = 'A'
        , RQL_ACTIVE = '+'
      WHERE RQL_REQ = @reqnum
        AND RQL_RSTATUS = 'U';
    END
ELSE 
  BEGIN --Change approver to line manager, change status to Authorised then to Awaiting approval to trigger approval email
    UPDATE R5REQUISITIONS
    SET REQ_STATUS = 'AUTH'
      , REQ_RSTATUS = 'U'
      , REQ_UDFCHAR12 = @linemgr
    WHERE REQ_CODE = @reqnum;

    UPDATE R5REQUISITIONS
    SET REQ_STATUS = 'R'
      , REQ_RSTATUS = 'R'
      , REQ_UDFCHAR12 = @linemgr
    WHERE REQ_CODE = @reqnum;
  END 

--------Set Approver Record-----------

IF (@usrapprgrp = 'GROUP A') 
  UPDATE R5REQUISITIONS SET REQ_UDFCHKBOX01 = '+', REQ_UDFCHAR20 = @user WHERE REQ_CODE = @reqnum;
IF (@usrapprgrp = 'GROUP B')
  UPDATE R5REQUISITIONS SET REQ_UDFCHKBOX02 = '+', REQ_UDFCHAR21 = @user WHERE REQ_CODE = @reqnum;
IF (@usrapprgrp = 'GROUP C')
  UPDATE R5REQUISITIONS SET REQ_UDFCHKBOX03 = '+', REQ_UDFCHAR22 = @user WHERE REQ_CODE = @reqnum;

END -- IF ( @status='APPR' )

----------------------Get WO Department----------------------------------------------------------------

IF @evnt IS NOT NULL 
	BEGIN
		SELECT  @Wmrc = EVT_MRC
		FROM R5EVENTS 
		WHERE EVT_CODE = @evnt;
	END	

---------------------Update Check Fields and ABN----------------------------------------------------------------

    BEGIN
      UPDATE R5REQUISITIONS
      SET  REQ_UDFCHAR10 = REQ_STATUS
          ,REQ_UDFCHAR09 = REQ_ORIGIN
          ,REQ_UDFCHAR08 =(SELECT COM_UDFCHAR01 FROM R5COMPANIES WHERE COM_CODE = REQ_FROMCODE)
          ,REQ_UDFCHAR11 = CASE WHEN @evnt IS NOT NULL THEN @Wmrc ELSE @mrc END
      WHERE REQ_SQLIDENTITY = :rowid;
    END

END