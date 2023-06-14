
DECLARE
	 @supplier			NVARCHAR(80)
	,@abn 				NVARCHAR(80)
	,@requestedby 		NVARCHAR(15)
	,@status 	 		NVARCHAR(4)
	,@oldstatus 	 	NVARCHAR(4)
	,@employee 	 		NVARCHAR(15)
	,@v_id 				INTEGER
	,@user 				NVARCHAR(30)
	,@org 				NVARCHAR(15)
	,@group 			NVARCHAR(12)
	,@oldrequested		NVARCHAR(80)
	,@evnt 				NVARCHAR(10)
	,@Wsyss 			NVARCHAR(4)
	,@syss 				NVARCHAR(4)
	,@Wmrc 				NVARCHAR(6)
	,@Wclass 			NVARCHAR(6)
	,@class 			NVARCHAR(20)
	,@mrc 				NVARCHAR(6)
	,@linemgr 			NVARCHAR(30)
	,@reqorg 			NVARCHAR(15)
	,@reqnum 			NVARCHAR(30)
	,@topapprgrp 		NVARCHAR(8)
	,@usrapprgrp 		NVARCHAR(8)
	,@apprlimit 		NUMERIC(24,6)
	,@limitlevel 		NVARCHAR(1)
	,@reqvalue 			NUMERIC(24,6)
	,@ammendment		NVARCHAR(12);
 
EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;

	SELECT 	 @employee = PER_CODE 
	FROM R5PERSONNEL 
	WHERE PER_NOTUSED = '-' AND PER_USER = @user;
	
	SELECT 	 @group = UOG_GROUP 
	FROM R5USERORGANIZATION 
	WHERE UOG_USER = @user;
	
	
	SELECT 	 @requestedby = REQ_ORIGIN
			,@supplier = REQ_FROMCODE
			,@status = REQ_STATUS
			,@oldstatus = REQ_UDFCHAR10 
			,@oldrequested = REQ_UDFCHAR09
			,@evnt = REQ_EVENT
			,@mrc = REQ_UDFCHAR11
			,@syss = REQ_UDFCHAR13
			,@class = REQ_UDFCHAR14 
			,@reqnum = REQ_CODE
			,@ammendment = REQ_UDFCHAR06
	FROM R5REQUISITIONS
	WHERE REQ_SQLIDENTITY = :rowid;
	
IF (@group <> 'STOREMGR' AND @oldstatus IN ('RQST','CONT','CANC','Q')
	BEGIN
	RAISERROR('You do not have security rights to edit this requisition in this status.', 16, 1);
	END

IF (@group <> 'STOREMGR' AND @oldstatus = 'AUTH')
	BEGIN
	RAISERROR('You do not have security rights to edit Authorised requisitions.', 16, 1);
	END
	
IF (@group <> 'STOREMGR' AND (@requestedby <> @oldrequested OR (@requestedby IS NULL)))
	RAISERROR('You do not have security rights to edit the Requested By field.', 16, 1);
	
IF (@user NOT IN ( SELECT USR_CODE 
							FROM R5USERORGANIZATION, R5AUTH, R5USERS
							WHERE UOG_GROUP = AUT_GROUP 
							AND uog_user = usr_code
							AND usr_class IS NOT NULL 
							AND aut_entity = 'REQ'
							AND aut_type = '+' 
							AND aut_status = 'R' 
							AND aut_statnew = 'APPR'
				UNION ALL
					SELECT aut_user 
							FROM r5auth 
							WHERE aut_entity = 'REQ' 
							AND aut_type = '-'
							AND aut_status = 'R' 
							AND aut_statnew = 'APPR'
				UNION ALL
					SELECT usr_code 
							FROM r5userorganization, r5users
							WHERE uog_user = usr_code 
							AND usr_class IS NOT NULL
							AND uog_group = 'STOREMGR'
					)
 AND @oldstatus = 'R')
RAISERROR('You do not have security rights to edit Authorised requisitions.', 16, 1);

IF @supplier <> ' '
BEGIN
	SELECT @abn = COM_UDFCHAR01 FROM R5COMPANIES WHERE COM_CODE = @supplier
END
	
IF @evnt <> ' ' 
BEGIN
	SELECT 
		@Wsyss = EVT_UDFCHAR09
		,@Wmrc = EVT_MRC
		,@Wclass = EVT_CLASS 
		FROM R5EVENTS 
		WHERE EVT_CODE = @evnt;
	IF @mrc IS NULL 
		SET @mrc = @Wmrc;
	IF @syss IS NULL 
		SET @syss = @WSyss;
	IF @class IS NULL
		SET @class = @Wclass;
	IF @mrc IN ('FAC','PLANTOPS','SITEOPS')
		SET @mrc = 'OPS';
	IF @mrc IN ('EI','MECH','PROJ')
		SET @mrc = 'ENG';
END	

IF ( @status = 'APPR' )
BEGIN
	SELECT @limitlevel = INS_DESC 
	FROM R5INSTALL 
	WHERE INS_CODE = 'LIMITLEV';
	IF ( @limitlevel ! = 'H' )
		BEGIN
		RAISERROR('Install Parameter LIMITLEV Changed, Approval Process is turned off. See System Administrator', 16, 1);
		END
	
	SELECT TOP 1 @topapprgrp = CLS_CODE 
	FROM R5CLASSES 
	WHERE CLS_ENTITY = 'USER' 
	AND CLS_CODE LIKE 'GROUP%' 
	ORDER BY CLS_CODE DESC;
	
	SELECT 	@usrapprgrp = USR_CLASS
			,@linemgr = USR_UDFCHAR01 
	FROM R5USERS 
	WHERE USR_CODE = @user;
	
	SELECT @apprlimit = ISNULL(UOG_REQAUTHAPPVLIMIT,0) 
	FROM R5USERORGANIZATION 
	WHERE UOG_USER = @user 
	AND UOG_ORG = @reqorg;
IF @ammendment = ' '
	BEGIN
		SELECT @reqvalue = SUM( CASE RQL_RTYPE WHEN 'SF' THEN RQL_PRICE ELSE RQL_QTY * RQL_PRICE END / ISNULL(RQL_EXCH,1)) 
		FROM R5REQUISLINES 
		WHERE RQL_REQ = @reqnum 
			AND RQL_RSTATUS NOT IN ('J','C') ;
	END
ELSE
BEGIN
 SELECT @reqvalue = SUM( CASE RQL_RTYPE WHEN 'SF' THEN RQL_PRICE ELSE RQL_QTY * RQL_PRICE END / ISNULL(RQL_EXCH,1) ) + (SELECT ORD_PRICE/ISNULL(ORD_EXCH,1) FROM R5ORDERS WHERE ORD_CODE = @ammendment)
		FROM R5REQUISLINES 	
		WHERE RQL_REQ = @reqnum 
			AND RQL_RSTATUS NOT IN ('J','C') ;
END


IF ( @apprlimit > = @reqvalue )
BEGIN
	UPDATE R5REQUISITIONS 
		SET REQ_STATUS = 'A'
			,REQ_RSTATUS = 'A'
			,REQ_AUTH = @user
			,REQ_DATEAPPROVED = GETDATE() 
		WHERE REQ_CODE = @reqnum;
	UPDATE R5REQUISLINES 
		SET RQL_STATUS = 'A'
			,RQL_RSTATUS = 'A'
			,RQL_ACTIVE = '+' 
		WHERE RQL_REQ = @reqnum 
		AND RQL_RSTATUS = 'U';
END
ELSE
IF ( @usrapprgrp = @topapprgrp )
BEGIN
UPDATE r5requisitions SET req_status = 'UNAP', req_rstatus = 'A', req_auth = @user, req_dateapproved = GETDATE() WHERE req_code = @reqnum;
UPDATE r5requislines SET rql_status = 'UNAP', rql_rstatus = 'A', rql_active = '+' WHERE rql_req = @reqnum AND rql_rstatus = 'U';
END
ELSE
BEGIN
UPDATE r5requisitions SET req_status = 'AUTH', req_rstatus = 'U', REQ_UDFCHAR12 = @linemgr WHERE req_code = @reqnum;
UPDATE r5requisitions SET req_status = 'R', req_rstatus = 'R', REQ_UDFCHAR12 = @linemgr WHERE req_code = @reqnum;
END
IF ( @usrapprgrp = 'GROUP A' )
UPDATE r5requisitions SET req_udfchkbox01 = '+', REQ_UDFCHAR20 = @user WHERE req_code = @reqnum;
IF ( @usrapprgrp = 'GROUP B' )
UPDATE r5requisitions SET req_udfchkbox02 = '+', REQ_UDFCHAR21 = @user WHERE req_code = @reqnum;
IF ( @usrapprgrp = 'GROUP C' )
UPDATE r5requisitions SET req_udfchkbox03 = '+', REQ_UDFCHAR22 = @user WHERE req_code = @reqnum;


END -- IF ( @status = 'APPR' )
IF (@status = 'AUTH' AND @oldstatus = 'Q')
UPDATE r5requisitions SET REQ_UDFCHAR01 = NULL WHERE req_code = @reqnum;

UPDATE R5REQUISITIONS 
	SET REQ_UDFCHAR11 = @mrc
		,REQ_UDFCHAR13 = @syss
		,REQ_UDFCHAR14 = @class
		,REQ_UDFCHAR10 = @status
		,REQ_UDFCHAR08 = @abn
		,REQ_UDFCHAR09 = @requestedby
	WHERE REQ_SQLIDENTITY = :rowid;

'Update the Requisitions Supplier ABN when a Supplier is selected (Copying COM_UDFCHAR01 to REQ_UDFCHAR08).'
'Update Requisition Department & System Superior from WO'

'Prevent users not in the STOREMGR groups, or any group that may approve requisitions, from editing Awaiting Approval requisitions'
'Prevent users not in the STOREMGR groups from editing Authorised requisitions'
'Preventing changes to the Requested By field except by STOREMGR group users'


'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'



