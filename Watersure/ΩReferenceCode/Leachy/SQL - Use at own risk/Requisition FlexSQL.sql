DECLARE
  @v_id         INTEGER,
  @user         NVARCHAR(30),
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
      SELECT @usrapprgrp=usr_class FROM r5users WHERE usr_code=@user;
      SELECT @apprlimit=ISNULL(uog_reqauthappvlimit,0) FROM r5userorganization WHERE uog_user=@user AND uog_org=@reqorg;
      SELECT @limitlevel=ins_desc FROM r5install WHERE ins_code='LIMITLEV';
      IF ( @limitlevel='L' )
      	  	SELECT @reqvalue=MAX( CASE rql_rtype WHEN 'SF' THEN rql_price ELSE rql_qty * rql_price END / ISNULL(rql_exch,1) ) FROM r5requislines WHERE rql_req=@reqnum AND rql_rstatus NOT IN ('J','C');
      ELSE
        	SELECT @reqvalue=SUM( CASE rql_rtype WHEN 'SF' THEN rql_price ELSE rql_qty * rql_price END / ISNULL(rql_exch,1) ) FROM r5requislines WHERE rql_req=@reqnum AND rql_rstatus NOT IN ('J','C');
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
       UPDATE r5requisitions SET req_status='AUTH', req_rstatus='U' WHERE req_code=@reqnum;
      END
      IF ( @usrapprgrp='GROUP A' )
        UPDATE r5requisitions SET req_udfchkbox01='+', REQ_UDFCHAR20=@user WHERE req_code=@reqnum;
      IF ( @usrapprgrp='GROUP B' )
        UPDATE r5requisitions SET req_udfchkbox02='+', REQ_UDFCHAR21=@user WHERE req_code=@reqnum;
      IF ( @usrapprgrp='GROUP C' )
        UPDATE r5requisitions SET req_udfchkbox03='+', REQ_UDFCHAR22=@user WHERE req_code=@reqnum;
    END -- IF ( @status='APPR' )
END