DECLARE
@supplier NVARCHAR(80)
,@abn NVARCHAR(80)
,@v_id         INTEGER
,@evnt nvarchar(30)
,@Wsyss nvarchar(30)
,@syss nvarchar(30)
,@Wmrc nvarchar(20)
,@Wclass nvarchar(20)
,@class nvarchar(20)
,@user nvarchar(30)
,@linemgr nvarchar(30)
,@mrc nvarchar(20);
BEGIN
SELECT 
	 @supplier = REQ_FROMCODE
	,@evnt = REQ_EVENT
	,@mrc = REQ_UDFCHAR11
	,@syss = REQ_UDFCHAR13
	,@class = REQ_UDFCHAR14
	,@user = REQ_ORIGIN

	FROM R5REQUISITIONS 
	WHERE REQ_SQLIDENTITY = :rowid

SELECT 
	@linemgr = USR_UDFCHAR01 
	FROM R5USERS 
	WHERE USR_CODE = @user

IF @supplier <> ' '
	BEGIN
		SELECT @abn = COM_UDFCHAR01  FROM R5COMPANIES WHERE COM_CODE=@supplier
	END
ELSE 
SET @abn = null;

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

UPDATE R5REQUISITIONS
SET 
REQ_UDFCHAR20=NULL
,REQ_UDFCHAR21=NULL
,REQ_UDFCHAR22=NULL
,REQ_UDFCHAR10 = REQ_STATUS
,REQ_UDFCHAR09 = REQ_ORIGIN
,REQ_UDFCHAR08 = @abn
,REQ_UDFCHKBOX01 = '-'
,REQ_UDFCHKBOX02 = '-'
,REQ_UDFCHKBOX03 = '-'
,REQ_UDFCHAR11 = @mrc
,REQ_UDFCHAR13 = @syss
,REQ_UDFCHAR14 = @class
,REQ_UDFCHAR12 = @linemgr
WHERE REQ_SQLIDENTITY = :rowid


END

'
Update the comparison fields, and Approver fields for cloned records
Update the Requisitions Supplier ABN
Update Requisition Department & System Superior from WO
'

