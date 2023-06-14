DECLARE
      @v_id integer,
      @date datetime,
      @user nvarchar(30),
      @status nvarchar(30), 
      @type nvarchar(30), 
      @wonum nvarchar(8),
      @wodesc nvarchar(80),
      @desc nvarchar(80),
      @changecheck nvarchar(1),
      @riskRating nvarchar(10);

EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT;
BEGIN
    SELECT  @wonum = CMF_EVENT,
            @wodesc = EVT_DESC, 
            @status = EVT_STATUS,
            @type = EVT_TYPE,
            @changecheck = EVT_UDFCHKBOX03,
            @riskRating = CMF_RISKTOTAL,
            @desc = CMF_DESCRIPTION,
            @date = EVT_UDFDATE02
        FROM U5CHMGMT
        LEFT OUTER JOIN R5EVENTS ON CMF_EVENT = EVT_CODE
          WHERE  SQLIDENTITY = :rowid

IF @desc is null 
  BEGIN
   SET @desc = @wodesc;
  END
IF @changecheck = '-' OR @changecheck IS NULL
  BEGIN
    RAISERROR('You can only fill out a change request for a Change type work order  ''%s''',16,1,@wonum);
  END

  BEGIN 
    IF @changecheck = '+'
      UPDATE U5CHMGMT
        SET U5CHMGMT.DESCRIPTION = @wodesc,
        CMF_UPDATEDBY = @user,
        CMF_EVTSTATUS = @status,
        CMF_EVTTYPE = dbo.repgetdesc('EN','UCOD',@type, 'JBTP',null),
        CMF_DESCRIPTION = @desc,
        CMF_REVIEWDUE = @date,
        CMF_CREATED = GETDATE(),
        CMF_CREATOR = @user,
        CMF_STATUS = 'Change Request',
        CMF_OWNER = NULL, --Set everything null on copy
        CMF_INVAPPCST = NULL,
        CMF_ENGAUTH = NULL,
        CMF_EXTENGREVIEW = NULL,
        CMF_CUSTREP = NULL,
        CMF_CHFLOW = NULL,
        CMF_CONOVERVIEW = NULL,
        CMF_CONALT1 = NULL,
        CMF_CONALT2 = NULL,
        CMF_CONDOC = NULL,
        CMF_CONDOCUPDATE = NULL,
        CMF_CONDELIVERABLES = NULL,
        CMF_CONESTLABOUR = NULL,
        CMF_CONESTMATERIALS = NULL,
        CMF_CONESTOTHER = NULL,
        CMF_CONESTTOTAL = NULL,
        CMF_DESESTLABOUR = NULL,
        CMF_DESESTMATERIALS = NULL,
        CMF_DESESTOTHER = NULL,
        CMF_DESESTTOTAL = NULL,
        CMF_CONENGAPPR = NULL,
        CMF_CONSEICOMM = NULL,
        CMF_CONEICOMMCHECK = NULL,
        CMF_CONMECHCOMM = NULL,
        CMF_CONMECHCOMMCHECK = NULL,
        CMF_CONPLANTCOMM = NULL,
        CMF_CONPLANTCOMMCHECK = NULL,
        CMF_CONCUSTAGREE = NULL,
        CMF_CONMANCOMM = NULL,
        CMF_CONMANCOMMCHECK = NULL,
        CMF_DESCHECK = NULL,
        CMF_DESADDCST = NULL,
        CMF_INBUDGET = NULL,
        CMF_BUDALLOC = NULL,
        CMF_PROJNUM = NULL,
        CMF_DESOVER = NULL,
        CMF_DESDOCPARA = NULL,
        CMF_DESDOC = NULL,
        CMF_DESDOCDRAW = NULL,
        CMF_PROJESTLABOUR = NULL,
        CMF_PROJESTMATERIALS = NULL,
        CMF_PROJESTOTHER = NULL,
        CMF_PROJESTTOTAL = NULL,
        CMF_PROJDESCOST = NULL,
        CMF_DESENGAPPR = NULL,
        CMF_DESSEICOMM = NULL,
        CMF_DESMECHCOMM = NULL,
        CMF_DESPLANTCOMM = NULL,
        CMF_DESCUSTAGREE = NULL,
        CMF_DESAMCOMM = NULL,
        CMF_DESOPSCOMM = NULL,
        CMF_IMPCHANGES = NULL,
        CMF_IMPDOCPARA = NULL,
        CMF_IMPDOC = NULL,
        CMF_IMPDRAW = NULL,
        CMF_IMPOUTSTAND = NULL,
        CMF_PROJLABOUR = NULL,
        CMF_PROJMATERIALS = NULL,
        CMF_PROJOTHER = NULL,
        CMF_PROJTOTAL = NULL,
        CMF_PROJDESCOSTFINAL = NULL,
        CMF_IMPENGAPPR = NULL,
        CMF_IMPSEICOMM = NULL,
        CMF_IMPEICOMMCHECK = NULL,
        CMF_IMPMECHCOMM = NULL,
        CMF_IMPMECHCOMMCHECK = NULL,
        CMF_IMPPLANTCOMM = NULL,
        CMF_IMPPLANTCOMMCHECK = NULL,
        CMF_IMPCUSTAGREE = NULL,
        CMF_IMPAMCOMM = NULL,
        CMF_IMPAMCOMMCHECK = NULL,
        CMF_IMPOPSCOMM = NULL,
        CMF_IMPOPSCOMMCHECK = NULL,
        CMF_IMPDOCCONTREVIEW = NULL,
        CMF_IMPDIRECTOR = NULL,
        CMF_REQBRIEF = 'Click here then Click Away',
        CMF_CHAPPR = 'Click here then Click Away',
        CMF_CONCDET = 'Click here then Click Away',
        CMF_CONCAPPR = 'Click here then Click Away',
        CMF_DETAILDESIGN = 'Click here then Click Away',
        CMF_DESAPPR = 'Click here then Click Away',
        CMF_IMPDETAIL = 'Click here then Click Away',
        CMF_IMPAPPR = 'Click here then Click Away',
        CMF_EXECSUMMARY = NULL
      WHERE SQLIDENTITY=:rowid;
  END
END
