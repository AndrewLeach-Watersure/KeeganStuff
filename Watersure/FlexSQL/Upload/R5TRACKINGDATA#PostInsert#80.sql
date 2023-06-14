DECLARE @v_id integer
       ,@user nvarchar(100)
       ,@group nvarchar(100)
       ,@transcode nvarchar(80)
       ,@promptdata1 nvarchar(80)
       ,@wo NVARCHAR(80)
       ,@project NVARCHAR(80)
       ,@projbud NVARCHAR(80);

EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;

SELECT @group = USR_GROUP FROM R5USERS WHERE USR_CODE = @user;
     
BEGIN
  SELECT
    @promptdata1 = tkd_promptdata1
   ,@wo = tkd_promptdata2
   ,@project = COALESCE(tkd_promptdata3, EVT_PROJECT)
   ,@projbud = COALESCE(tkd_promptdata4, EVT_PROJBUD)
   ,@transcode = tkd_trans
  FROM R5TRACKINGDATA
  LEFT OUTER JOIN R5EVENTS ON EVT_CODE = tkd_promptdata2
  WHERE tkd_sqlidentity = :rowid 
        AND tkd_trans = 'UPLO' 
        AND tkd_promptdata1 = 'PROJ_UPDATE';

  IF(@group <> 'ADMIN' AND @transcode = 'UPLO' AND @promptdata1 = 'PROJ_UPDATE')
    BEGIN
      RAISERROR('Admin Only Upload, send to service desk.', 16, 1)
    END
    
  IF NOT EXISTS (
                SELECT 1
                FROM R5PROJBUDCLASSES PB
                INNER JOIN R5PROJECTS P ON PB.PCL_PROJECT = P.PRJ_CODE
                WHERE PB.PCL_PROJBUD = @projbud 
                      AND P.PRJ_CODE = @project 
                      AND P.PRJ_STATUS ='O'
                )
    BEGIN 
    RAISERROR('Project and budget combination does not exist OR Project has not been approved', 16, 1)
    END
    ELSE
    BEGIN
        UPDATE R5EVENTS       SET EVT_PROJECT = @project, EVT_PROJBUD = @projbud    WHERE EVT_CODE = @wo
        UPDATE R5ORDERLINES   SET ORL_PROJECT = @project, ORL_PROJBUD = @projbud    WHERE ORL_EVENT = @wo
        UPDATE R5REQUISLINES  SET RQL_PROJECT = @project, RQL_PROJBUD = @projbud    WHERE RQL_EVENT = @wo
        UPDATE R5ACTIVITIES   SET ACT_PROJECT = @project, ACT_PROJBUD = @projbud    WHERE ACT_EVENT = @wo 
     /* UPDATE R5TRANSLINES   SET TRL_PROJECT = @project, TRL_PROJBUD = @projbud    WHERE TRL_EVENT = @wo   */
    END
DELETE FROM R5TRACKINGDATA WHERE tkd_sqlidentity = :rowid AND tkd_trans = 'UPLO' AND   @promptdata1 = 'PROJ_UPDATE';
END