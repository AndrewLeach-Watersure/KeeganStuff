DECLARE
@v_id integer,
@user nvarchar(100),
@group nvarchar(100),
@transcode nvarchar(80),
@promptdata1 nvarchar(80),
@po NVARCHAR(80),
@poline NVARCHAR(80),
@req NVARCHAR(80),
@reqline NVARCHAR(80),
@evt NVARCHAR(80),
@act NVARCHAR(80),
@mrc NVARCHAR(80),
@cc NVARCHAR(80),
@i nvarchar(1);

EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;
SELECT @group = USR_GROUP FROM R5USERS WHERE USR_CODE = @user;

BEGIN

SELECT
@promptdata1 = tkd_promptdata1,
@po = tkd_promptdata2,
@poline = tkd_promptdata3,
@req = tkd_promptdata4,
@reqline = tkd_promptdata5,
@evt = tkd_promptdata6,
@act = tkd_promptdata7,
@mrc = tkd_promptdata8,
@cc = tkd_promptdata9,
@transcode = tkd_trans

FROM R5TRACKINGDATA
WHERE tkd_sqlidentity = :rowid
AND tkd_trans = 'UPLO' AND tkd_promptdata1 = 'FinanceFix';

IF(@group <> 'ADMIN' AND @transcode = 'UPLO' AND @promptdata1 = 'FinanceFix')
BEGIN
RAISERROR('Admin Only Upload, send to service desk.',16,1)
END

IF (@transcode = 'UPLO' AND @promptdata1 = 'FinanceFix')
  BEGIN
      UPDATE R5REQUISLINES
        SET RQL_UDFCHAR02 = @po,
            RQL_UDFCHAR03 = @poline,
            RQL_EVENT = @evt,
            RQL_ACT = @act,
            RQL_UDFCHAR05 = @mrc,
            RQL_COSTCODE = @cc
        WHERE RQL_REQ = @req
            AND RQL_REQLINE = @reqline    

      UPDATE R5ORDERLINES
        SET ORL_REQ = @req,
            ORL_REQLINE = @reqline,
            ORL_EVENT = @evt,
            ORL_ACT = @act,
            ORL_UDFCHAR07 = @mrc,
            ORL_COSTCODE = @cc
        WHERE ORL_ORDER = @po
            AND ORL_ORDLINE = @poline

      UPDATE R5ACTIVITIES
        SET ACT_REQ = @req,
            ACT_ORDLINE = @poline,
            ACT_REQLINE = @reqline,
            ACT_ORDER = @po,
            ACT_ORDER_ORG = 'VDP'
        WHERE ACT_EVENT = @evt
            AND ACT_ACT = @act 
    END

DELETE FROM r5trackingdata
WHERE tkd_sqlidentity = :rowid AND tkd_trans = 'UPLO' AND @promptdata1 = 'FinanceFix' ;

END;
