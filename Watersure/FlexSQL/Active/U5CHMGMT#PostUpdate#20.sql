DECLARE
    @v_id integer,
    @date datetime,
    @user nvarchar(30),
    @updated nvarchar(40),
    @status nvarchar(30),
    @type nvarchar(80),
    @wonum nvarchar(8),
    @wodesc nvarchar(80),
    @changecheck nvarchar(1),
    @usercheck nvarchar(40),
    @chStatus nvarchar(80),
    @xStatus nvarchar(80),
    @dept nvarchar(10),
    @riskRating nvarchar(10),
    @rej nvarchar(1),
    @CMF_PRIORITY nvarchar(2),
    @CMF_COLLAB nvarchar(20),
    @CMF_EICOMM nvarchar(4000),
    @CMF_MECHCOMM nvarchar(4000),
    @CMF_PLANTCOMM nvarchar(4000),
    @CMF_SAFECOMM nvarchar(4000),
    @CMF_EICOMMCHECK nvarchar(4000),
    @CMF_MECHCOMMCHECK nvarchar(4000),
    @CMF_PLANTCOMMCHECK nvarchar(4000),
    @CMF_SAFECOMMCHECK nvarchar(4000),
    @CMF_MANCOMM nvarchar(4000),
    @CMF_MANCOMMCHECK  nvarchar(4000),
    @CMF_OWNER nvarchar(40),
    @CMF_INVAPPCST nvarchar(40),
    @CMF_ENGAUTH nvarchar(40),
    @CMF_CHFLOW nvarchar(45),
    @CMF_CONENGAPPR nvarchar(4000),
    @CMF_CONSEICOMM nvarchar(4000),
    @CMF_CONMECHCOMM nvarchar(4000),
    @CMF_CONPLANTCOMM nvarchar(4000),
    @CMF_CONMANCOMM nvarchar(4000),
    @CMF_BUDALLOC nvarchar(20),
    @CMF_DESENGAPPR nvarchar(4000),
    @CMF_DESSEICOMM nvarchar(4000),
    @CMF_DESMECHCOMM nvarchar(4000),
    @CMF_DESPLANTCOMM nvarchar(4000),
    @CMF_DESAMCOMM nvarchar(4000),
    @CMF_IMPENGAPPR NVARCHAR(4000),
    @CMF_IMPSEICOMM NVARCHAR(4000),
    @CMF_IMPMECHCOMM NVARCHAR(4000),
    @CMF_IMPPLANTCOMM NVARCHAR(4000),
    @CMF_IMPAMCOMM NVARCHAR(4000),
    @CMF_IMPDOCCONTREVIEW NVARCHAR(4000),
    @CMF_IMPDIRECTOR NVARCHAR(4000);

EXECUTE @v_id = O7SESS_CUR_USER @user OUTPUT

BEGIN
    SELECT @wonum = CMF_EVENT,
           @wodesc = EVT_DESC,
           @date = CMF_REVIEWDUE,
           @status = EVT_STATUS,
           @type = EVT_JOBTYPE,
           @dept = EVT_MRC,
           @changecheck = EVT_UDFCHKBOX03,
           @usercheck = CMF_UPDATEDBY,
           @riskRating = CMF_RISKTOTAL,
           @chStatus = CMF_STATUS,
           @xStatus = CMF_XSTATUS,
           @CMF_EICOMM = CMF_EICOMM,
           @CMF_MECHCOMM = CMF_MECHCOMM,
           @CMF_PLANTCOMM = CMF_PLANTCOMM,
           @CMF_SAFECOMM = CMF_SAFECOMM,
           @CMF_MANCOMM = CMF_MANCOMM,
           @CMF_OWNER = CMF_OWNER,
           @CMF_INVAPPCST = CMF_INVAPPCST,
           @CMF_ENGAUTH = CMF_ENGAUTH,
           @CMF_CHFLOW = CMF_CHFLOW,
           @CMF_PRIORITY = CMF_PRIORITY,
           @CMF_COLLAB = CMF_COLLAB,
           @rej = CMF_REJECTED,
           @CMF_CONENGAPPR = CMF_CONENGAPPR,
           @CMF_CONSEICOMM = CMF_CONSEICOMM,
           @CMF_CONMECHCOMM = CMF_CONMECHCOMM,
           @CMF_CONPLANTCOMM = CMF_CONPLANTCOMM,
           @CMF_CONMANCOMM = CMF_CONMANCOMM,
           @CMF_BUDALLOC = CMF_BUDALLOC,
           @CMF_DESENGAPPR = CMF_DESENGAPPR,
           @CMF_DESSEICOMM = CMF_DESSEICOMM,
           @CMF_DESMECHCOMM = CMF_DESMECHCOMM,
           @CMF_DESPLANTCOMM = CMF_DESPLANTCOMM,
           @CMF_DESAMCOMM = CMF_DESAMCOMM,
           @CMF_IMPENGAPPR = CMF_IMPENGAPPR,
           @CMF_IMPSEICOMM = CMF_IMPSEICOMM,
           @CMF_IMPMECHCOMM = CMF_IMPMECHCOMM,
           @CMF_IMPPLANTCOMM = CMF_IMPPLANTCOMM,
           @CMF_IMPAMCOMM = CMF_IMPAMCOMM,
           @CMF_MECHCOMMCHECK = CMF_MECHCOMMCHECK ,
           @CMF_PLANTCOMMCHECK =  CMF_PLANTCOMMCHECK,
           @CMF_SAFECOMMCHECK = CMF_SAFECOMMCHECK,
           @CMF_EICOMMCHECK = CMF_EICOMMCHECK,
           @CMF_MANCOMMCHECK = CMF_MANCOMMCHECK,
           @CMF_IMPDOCCONTREVIEW = CMF_IMPDOCCONTREVIEW,
           @CMF_IMPDIRECTOR = CMF_IMPDIRECTOR
    FROM U5CHMGMT
    LEFT OUTER JOIN R5EVENTS ON CMF_EVENT = EVT_CODE
    WHERE  SQLIDENTITY = :rowid

    IF (@usercheck <> @user)
        BEGIN 
            RAISERROR('Please enter your User Id in the Updated By field', 16, 1) 
        END

    IF (@chStatus = 'Change Review (4 Pillars)' AND @CMF_EICOMM IS NOT NULL AND @CMF_MECHCOMM IS NOT NULL AND @CMF_PLANTCOMM IS NOT NULL AND @CMF_SAFECOMM IS NOT NULL)
        BEGIN
            SELECT @status = 'CHWA', @type = 'CMCH', @chstatus = 'Change Review (Approval)' 
        END

    IF (@chStatus = 'Change Review (Approval)' AND @CMF_MANCOMM IS NOT NULL AND @CMF_OWNER IS NOT NULL AND @CMF_INVAPPCST IS NOT NULL AND @CMF_ENGAUTH IS NOT NULL AND @CMF_CHFLOW IS NOT NULL)
        BEGIN
            IF(@CMF_CHFLOW = '1. Start engineering investigation')
                BEGIN SELECT @type = 'EMIN', @status = 'PLAN', @chstatus = 'Implementation', @rej = '-'  END
            IF(@CMF_CHFLOW = '2. Proceed to Concept')
                BEGIN SELECT @type = 'CMCH', @status = 'CHCD', @chstatus = 'Concept Design', @rej = '-' END
            IF(@CMF_CHFLOW = '3. Proceed to implementation (Perm. Mod.)')
                BEGIN SELECT @type = 'EMPM', @status = 'PLAN', @chstatus = 'Implementation', @rej = '-' END
            IF(@CMF_CHFLOW = '4. Proceed to implementation (Temp. Mod.)')
                BEGIN SELECT @type = 'EMTM', @status = 'PLAN', @chstatus = 'Implementation', @rej = '-' END
            IF(@CMF_CHFLOW = '5. Cancel')
                BEGIN  SELECT @type = 'CMCH', @status = 'CANC', @chstatus = 'Cancelled', @rej = '-' END
            IF(@CMF_CHFLOW = '6. Reject')
                BEGIN SELECT @type = 'CMCH', @status = 'REJ', @chstatus = 'Request', @rej = '+' END
        END

    IF (@chStatus = 'Concept Review (3 Pillars)' AND @CMF_CONENGAPPR IS NOT NULL AND @CMF_CONSEICOMM IS NOT NULL AND @CMF_CONMECHCOMM IS NOT NULL AND @CMF_CONPLANTCOMM IS NOT NULL)
        BEGIN SELECT @status = 'CHWA', @type = 'CMCH', @chstatus = 'Concept Approval' END
    IF (@chStatus = 'Concept Approval' AND @CMF_CONMANCOMM IS NOT NULL AND @CMF_BUDALLOC IS NOT NULL)
    BEGIN
        IF(@CMF_CHFLOW = '1. Proceed to Detail Design')
            BEGIN SELECT @type = 'CMCH', @status = 'CHDD', @chstatus = 'Detail Design' END
        IF(@CMF_CHFLOW = '2. Proceed to implementation (Perm. Mod.)')
            BEGIN SELECT @type = 'EMPM', @status = 'PLAN', @chstatus = 'Implementation' END
        IF(@CMF_CHFLOW = '3. Proceed to implementation (Temp. Mod.)')
            BEGIN SELECT @type = 'EMTM', @status = 'PLAN', @chstatus = 'Implementation' END
        IF(@CMF_CHFLOW = '4. Cancel')
            BEGIN SELECT @type = 'CMCH', @status = 'CANC', @chstatus = 'Cancelled' END
    END
        IF (@chStatus = 'Detail Design Review (3 Pillars)' AND @CMF_DESENGAPPR IS NOT NULL AND @CMF_DESSEICOMM IS NOT NULL AND @CMF_DESMECHCOMM IS NOT NULL AND @CMF_DESPLANTCOMM IS NOT NULL)
            BEGIN SELECT @status = 'CHWA', @type = 'CMCH', @chstatus = 'Detail Design Approval' END
        IF (@chStatus = 'Detail Design Approval' AND @CMF_DESAMCOMM IS NOT NULL)
        BEGIN 
            IF(@CMF_CHFLOW = '1. Proceed to implementation (Perm. Mod.)')
                BEGIN SELECT @type = 'EMPM', @status = 'PLAN', @chstatus = 'Implementation' END
            IF(@CMF_CHFLOW = '2. Proceed to implementation (Temp. Mod.)')
                BEGIN SELECT @type = 'EMTM', @status = 'PLAN', @chstatus = 'Implementation' END
            IF(@CMF_CHFLOW = '3. Cancel')
                BEGIN SELECT @type = 'CMCH', @status = 'CANC', @chstatus = 'Cancelled' END
        END
    IF (@chStatus = 'Implementation Sign Off' AND @CMF_IMPENGAPPR IS NOT NULL AND @CMF_IMPSEICOMM IS NOT NULL AND @CMF_IMPMECHCOMM IS NOT NULL AND @CMF_IMPPLANTCOMM IS NOT NULL AND @CMF_IMPAMCOMM IS NOT NULL)
        BEGIN SELECT @status = 'C', @chstatus = 'Complete' END
    
    BEGIN
        SELECT @dept = (CASE WHEN @CMF_OWNER IN ('ENG','EI','ICT','MEC','OPS','PRO','LAB','DEF','MRA') THEN @CMF_OWNER ELSE @dept END) FROM DUAL
    END

    IF (@usercheck IS NOT NULL)
    BEGIN
        UPDATE U5CHMGMT 
        SET CMF_UPDATEDBY = NULL,
            CMF_STATUS = @chstatus,
            CMF_REJECTED = '-',
            CMF_MECHCOMMCHECK = CASE WHEN @rej = '+' THEN @CMF_MECHCOMM ELSE @CMF_MECHCOMMCHECK END,
            CMF_PLANTCOMMCHECK = CASE WHEN @rej = '+' THEN @CMF_PLANTCOMM ELSE @CMF_PLANTCOMMCHECK END,
            CMF_SAFECOMMCHECK = CASE WHEN @rej = '+' THEN @CMF_SAFECOMM ELSE @CMF_SAFECOMMCHECK  END,
            CMF_MANCOMMCHECK = CASE WHEN @rej = '+' THEN @CMF_MANCOMM ELSE  @CMF_MANCOMMCHECK END,
            CMF_EICOMMCHECK = CASE WHEN @rej = '+' THEN @CMF_EICOMM ELSE  @CMF_EICOMMCHECK END,
            CMF_MECHCOMM = CASE WHEN @rej = '+' THEN NULL ELSE @CMF_MECHCOMM END,
            CMF_PLANTCOMM = CASE WHEN @rej = '+' THEN NULL ELSE @CMF_PLANTCOMM END,
            CMF_SAFECOMM =  CASE WHEN @rej = '+' THEN NULL ELSE  @CMF_SAFECOMM END,
            CMF_EICOMM =  CASE WHEN @rej = '+' THEN NULL ELSE  @CMF_EICOMM END,
            CMF_MANCOMM = CASE WHEN @rej = '+' THEN NULL ELSE  @CMF_MANCOMM END,
            CMF_LASTUPDATEDBY = @user,
            CMF_LASTUPDATED = GETDATE(),
            CMF_EVTSTATUS =  dbo.repgetdesc('EN','UCOD',@status,'EVST',null),
            CMF_EVTTYPE = dbo.repgetdesc('EN','UCOD',@type, 'JBTP',null)
        WHERE CMF_EVENT = @wonum;

        UPDATE R5EVENTS
        SET EVT_UDFCHAR15 = @CMF_PRIORITY,
            EVT_SCHEDGRP = @CMF_COLLAB,
            EVT_MRC = @dept,
            EVT_UDFDATE02 = @date,
            EVT_UDFDATE03 = @date,
            EVT_JOBTYPE = @type,
            EVT_STATUS = @status
        WHERE EVT_CODE = @wonum;
    END
END
