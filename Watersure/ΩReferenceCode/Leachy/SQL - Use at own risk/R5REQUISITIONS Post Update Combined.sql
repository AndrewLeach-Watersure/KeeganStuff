
DECLARE
  @requestedby  nvarchar(15),
  @status       nvarchar(4),
  @oldstatus    nvarchar(4),
  @employee     nvarchar(15),
  @v_id         integer,
  @user         nvarchar(30);
EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;
BEGIN
  SELECT @requestedby=req_origin, @status=req_status, @oldstatus=req_udfchar10 FROM r5requisitions WHERE req_sqlidentity=:rowid;
  SELECT @employee=per_code FROM r5personnel WHERE per_notused='-' and per_user=@user;
  IF ( @oldstatus!=@status AND @status IN ('AUTH') AND ( @employee=@requestedby OR @employee IS NULL ) AND (@employee NOT IN ('JBELLI','EBERGSTROM','BTIZIANI','ALEACH') ))
    RAISERROR('Users may not Authorise or Approve their own requisitions.-20', 16, 1);
END

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

DECLARE
  @oldstatus  nvarchar(4),
  @v_id       integer,
  @user       nvarchar(100),
  @org        nvarchar(15),
  @group      nvarchar(12);
EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;
BEGIN
  SELECT @org=req_org, @oldstatus=req_udfchar10 FROM r5requisitions WHERE req_sqlidentity=:rowid;
  IF ( @user NOT IN ( SELECT usr_code FROM r5userorganization, r5auth, r5users
                       WHERE uog_group=aut_group AND uog_user=usr_code
                         AND uog_org=@org AND usr_class IS NOT NULL AND aut_entity='REQ'
                         AND aut_type='+' AND aut_status='R' AND aut_statnew='APPR'
                      UNION ALL
                      SELECT aut_user FROM r5auth WHERE aut_entity='REQ' AND aut_type='-'
                         AND aut_status='R' AND aut_statnew='APPR'
                      UNION ALL
                      SELECT usr_code FROM r5userorganization, r5users
                       WHERE uog_user=usr_code AND uog_org=@org AND usr_class IS NOT NULL
                         AND uog_group in ('STORES','STOREMGR') )
       AND @oldstatus='R' )
    RAISERROR('You do not have security rights to edit Authorised requisitions.-30', 16, 1);
END

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

DECLARE
  @v_id       integer,
  @user       nvarchar(100),
  @org        nvarchar(15),
  @status     nvarchar(4),
  @oldstatus  nvarchar(4),
  @group      nvarchar(12);
EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;
BEGIN
  SELECT @org=req_org, @status=req_status, @oldstatus=req_udfchar10 FROM r5requisitions WHERE req_sqlidentity=:rowid;
  SELECT @group=uog_group FROM r5userorganization WHERE uog_user=@user and uog_org=@org;
  IF ( @group NOT IN ('STORES','STOREMGR') AND @oldstatus='AUTH' AND @status!='RQST')
    RAISERROR('You do not have security rights to edit Authorised requisitions.-40', 16, 1);
  ELSE
    IF ( @oldstatus!=@status OR @oldstatus IS NULL )
      UPDATE r5requisitions SET req_udfchar10=req_status WHERE req_sqlidentity=:rowid;
END

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

DECLARE
  @requestedby   nvarchar(15),
  @oldrequested  nvarchar(80),
  @group         nvarchar(12),
  @status     nvarchar(12),
  @org           nvarchar(15),
  @v_id          integer,
  @user          nvarchar(30);
EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;
BEGIN
  SELECT @org=req_org, @requestedby=req_origin, @oldrequested=req_udfchar09, @status=req_status FROM r5requisitions WHERE req_sqlidentity=:rowid;
  SELECT @group=uog_group FROM r5userorganization WHERE uog_user=@user and uog_org=@org;
  IF ( @group NOT IN ('STOREMGR') AND ( @requestedby!=@oldrequested OR @requestedby IS NULL ) AND @oldrequested IS NOT NULL AND @status NOT IN ('RQST') )
    RAISERROR('You do not have security rights to edit the Requested By field.-50', 16, 1);
  IF ( @requestedby!=@oldrequested OR ( @requestedby IS NOT NULL AND @oldrequested IS NULL ) )
    UPDATE r5requisitions SET req_udfchar09=req_origin WHERE req_sqlidentity=:rowid;
END

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

DECLARE
  @v_id         INTEGER,
  @user         NVARCHAR(30),
  @linemgr     NVARCHAR(30),
  @reqorg       NVARCHAR(15),
  @reqnum       NVARCHAR(30),
  @status       NVARCHAR(4),
  @topapprgrp   NVARCHAR(8),
  @usrapprgrp   NVARCHAR(8),
  @apprlimit    NUMERIC(24,6),
  @limitlevel   NVARCHAR(1),
  @reqvalue     NUMERIC(24,6);
EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;
BEGIN
  SELECT @status=req_status, @reqorg=req_org, @reqnum=req_code FROM r5requisitions WHERE req_sqlidentity=:rowid;
  IF ( @status='APPR' )
    BEGIN
      SELECT TOP 1 @topapprgrp=cls_code FROM r5classes WHERE cls_entity='USER' AND cls_code LIKE 'GROUP%' ORDER BY cls_code DESC;
      SELECT @usrapprgrp=usr_class, @linemgr=USR_UDFCHAR01 FROM r5users WHERE usr_code=@user;
      SELECT @apprlimit=ISNULL(uog_reqauthappvlimit,0) FROM r5userorganization WHERE uog_user=@user AND uog_org=@reqorg;
      SELECT @limitlevel=ins_desc FROM r5install WHERE ins_code='LIMITLEV';
      
      	IF ( @apprlimit >= @reqvalue )
        	BEGIN
        	  UPDATE r5requisitions SET req_status='A', req_rstatus='A', req_auth=@user, req_dateapproved=GETDATE() WHERE req_code=@reqnum;
        	  UPDATE r5requislines SET rql_status='A', rql_rstatus='A', rql_active='+' WHERE rql_req=@reqnum AND rql_rstatus='U';
        	END
      	ELSE
        IF ( @usrapprgrp=@topapprgrp )
         	BEGIN
          	  UPDATE r5requisitions SET req_status='UNAP', req_rstatus='A', req_auth=@user, req_dateapproved=GETDATE() WHERE req_code=@reqnum;
          	  UPDATE r5requislines SET rql_status='UNAP', rql_rstatus='A', rql_active='+' WHERE rql_req=@reqnum AND rql_rstatus='U';
          	END
        ELSE
       BEGIN
       UPDATE r5requisitions SET req_status='AUTH', req_rstatus='U', REQ_UDFCHAR12 = @linemgr WHERE req_code=@reqnum;
UPDATE r5requisitions SET req_status='R', req_rstatus='R', REQ_UDFCHAR12 = @linemgr WHERE req_code=@reqnum;
      END
      IF ( @usrapprgrp='GROUP A' )
        UPDATE r5requisitions SET req_udfchkbox01='+', REQ_UDFCHAR20=@user WHERE req_code=@reqnum;
      IF ( @usrapprgrp='GROUP B' )
        UPDATE r5requisitions SET req_udfchkbox02='+', REQ_UDFCHAR21=@user WHERE req_code=@reqnum;
      IF ( @usrapprgrp='GROUP C' )
        UPDATE r5requisitions SET req_udfchkbox03='+', REQ_UDFCHAR22=@user WHERE req_code=@reqnum;


    END -- IF ( @status='APPR' )
END

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

UPDATE r5requisitions SET req_udfchar08=(SELECT com_udfchar01 FROM r5companies WHERE com_code=req_fromcode) WHERE req_sqlidentity=:rowid AND req_fromcode IS NOT NULL

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'


declare 
	@evnt nvarchar(30),
	@Wsyss nvarchar(30),
	@syss nvarchar(30),	
	@Wmrc nvarchar(20),
        @Wclass nvarchar(20),
        @class nvarchar(20),
        @mrc nvarchar(20);

begin
	set @evnt = ' ';
	select @evnt = req_event, @mrc = req_udfchar11, @syss = req_udfchar13, @class = req_udfchar14 from r5requisitions where req_sqlidentity = :rowid;
	if @evnt <> ' ' 
	begin
		select @Wsyss = evt_udfchar09, @Wmrc = evt_mrc, @Wclass = evt_class from r5events where evt_code = @evnt;
		if @mrc IS NULL 
			set @mrc = @Wmrc;
		if @syss IS NULL 
			set @syss = @WSyss;
               if @class IS NULL
                        set @class = @Wclass;
               if @mrc IN ('FAC','PLANTOPS','SITEOPS')
                         set @mrc = 'OPS';
                if @mrc IN ('EI','MECH','PROJ')
                         set @mrc = 'ENG';
		update r5requisitions set req_udfchar11 = @mrc, req_udfchar13 = @syss, req_udfchar14 = @class where req_sqlidentity = :rowid;
	end	
end