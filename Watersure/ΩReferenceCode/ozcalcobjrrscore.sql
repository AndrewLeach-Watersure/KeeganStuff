USE [EAMTEST]
GO
/****** Object:  StoredProcedure [dbo].[O7CALCOBJRRSCORE]    Script Date: 06/25/2021 12:12:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[O7CALCOBJRRSCORE]
  @sObj          NVARCHAR(30),
  @sOrg          NVARCHAR(15),
  @sStype        NVARCHAR(1),
  @sRanking      NVARCHAR(30),
  @sRankingorg   NVARCHAR(15),
  @nRankingrev   NUMERIC(4),
  @sLanguage     NVARCHAR(2),
  @nScore        NUMERIC(24,6)  OUTPUT,
  @sRrindex      NVARCHAR(8)    OUTPUT,
  @sMessage      NVARCHAR(2000) OUTPUT,
  @nRecsdone     NUMERIC(4)     OUTPUT,
  @nRecslocked   NUMERIC(4)     OUTPUT,
  @sChk          NVARCHAR(4)    OUTPUT
AS
  DECLARE @sChk2                  NVARCHAR(4)
  DECLARE @sMessage2              NVARCHAR(500)
  DECLARE @sExtramessage          NVARCHAR(100)
  DECLARE @sErrorfound            NVARCHAR(1)
  DECLARE @sDeflang               NVARCHAR(10)
  DECLARE @sLang                  NVARCHAR(10)
  DECLARE @dDateeffective         DATETIME
  DECLARE @nServicelife           NUMERIC(3)
  DECLARE @nServicelifeusage      NUMERIC(24,6)
  DECLARE @nIncrement             NUMERIC(30,12)
  DECLARE @dEndoflife             DATETIME
  DECLARE @nAgecorrection         NUMERIC(24,6)
  DECLARE @nRefpoint              NUMERIC(24,6)
  DECLARE @nAge                   NUMERIC(24,6)
  DECLARE @nThreshold             NUMERIC(24,6)
  DECLARE @nAgepercentage         NUMERIC(24,6)
  DECLARE @nUsagecorrection       NUMERIC(24,6)
  DECLARE @nUsage                 NUMERIC(24,6)
  DECLARE @nUsagepercentage       NUMERIC(24,6)

  DECLARE @dAckupdated            DATETIME
  DECLARE @sAckcode               NVARCHAR(30)
  DECLARE @sAckevent              NVARCHAR(30)
  DECLARE @sAckoperatorcl         NVARCHAR(30)
  DECLARE @sAckvalue              NVARCHAR(10)
  DECLARE @sAckvalue2             NVARCHAR(10)
  DECLARE @nAcknvalue             NUMERIC(24,6)

  DECLARE @sToplevelpk            NVARCHAR(30)
  DECLARE @sLeveldesc             NVARCHAR(80)
  DECLARE @sTopleveldesc          NVARCHAR(80)
  DECLARE @sAnswerpk              NVARCHAR(30)
  DECLARE @nAnswervalue           NUMERIC(24,6)
  DECLARE @nNorm                  NUMERIC(24,6)
  DECLARE @nResult                NUMERIC(24,6)
  DECLARE @sLevelpk               NVARCHAR(30)
  DECLARE @sParent                NVARCHAR(30)
  DECLARE @sCode                  NVARCHAR(30)
  DECLARE @sDesc                  NVARCHAR(80)
  DECLARE @sFormula               NVARCHAR(4000)
  DECLARE @sString                NVARCHAR(4000)
  DECLARE @sQresult               NVARCHAR(4000)
  DECLARE @sCharacter             NVARCHAR(1)
  DECLARE @sInlevel               NVARCHAR(1)
  DECLARE @sX                     NVARCHAR(1)
  DECLARE @nCnt                   NUMERIC
  DECLARE @nRecs                  NUMERIC
  DECLARE @nReturn                INTEGER
  DECLARE @sCsccode               NVARCHAR(30)
  DECLARE @nCscvalue              NUMERIC(24,6)
  DECLARE @nLoops                 INT
  DECLARE @sCompleted             NVARCHAR(1)
  DECLARE @sToplevelonly          NVARCHAR(1)
  DECLARE @nJ                     INTEGER
  DECLARE @nErrorscore            NUMERIC(24,6)

  DECLARE @nRefreshsequence       NUMERIC(6)
  DECLARE @sEqrrankingcode        NVARCHAR(30)
  DECLARE @sEqrrankingorg         NVARCHAR(15)
  DECLARE @nEqrrankingrev         NUMERIC(4)
  DECLARE @sRrkdesc               NVARCHAR(80)
  DECLARE @sRrktype               NVARCHAR(4)
  DECLARE @sRrkrtype              NVARCHAR(4)
  DECLARE @sRrkconditionprotocol  NVARCHAR(8)
  DECLARE @nRrkcondscorestart     NUMERIC(24,6)
  DECLARE @nRrkcondscoreend       NUMERIC(24,6)
  DECLARE @nRrkcondscorethreshold NUMERIC(24,6)
  DECLARE @sRrkdecaycurve         NVARCHAR(30)
  DECLARE @sRrkdecaycurveorg      NVARCHAR(15)
  DECLARE @sRrktrackhistory       NVARCHAR(1)
  DECLARE @nRrkprecision          NUMERIC(1)
  DECLARE @sEqrdefault            NVARCHAR(1)
  DECLARE @sEqrlocked             NVARCHAR(1)
  DECLARE @nObjservicelife        NUMERIC(3)
  DECLARE @nObjservicelifeusage   NUMERIC(24,6)
  DECLARE @sObjcategory           NVARCHAR(30)
  DECLARE @sObjclass              NVARCHAR(8)
  DECLARE @sObjclassorg           NVARCHAR(15)
  DECLARE @sObjprimaryuom         NVARCHAR(30)
  DECLARE @nObjcorrconditionscore NUMERIC(24,6)
  DECLARE @dObjcorrconditiondate  DATETIME
  DECLARE @nObjcorrconditionusage NUMERIC(24,6)
  DECLARE @nObjlength             NUMERIC(24,6)
  DECLARE @dObjcommiss            DATETIME
  DECLARE @nObjfrompoint          NUMERIC(24,6)
  DECLARE @dRefdate               DATETIME
  DECLARE @nStartscore            NUMERIC(24,6)
  DECLARE @nOudtotalusage         NUMERIC(24,6)
  DECLARE @sOuduom                NVARCHAR(30)
  DECLARE @nDailyusage            NUMERIC(24,6)
  DECLARE @nUsagecorr             NUMERIC(24,6)
  DECLARE @nStartscoreusage       NUMERIC(24,6)
  DECLARE @sCheckrefpoint         NVARCHAR(1)
  DECLARE @sDcrmetuom             NVARCHAR(30)
  DECLARE @nLrfid                 NUMERIC
  DECLARE @nLrflength             NUMERIC(24,6)
  DECLARE @dLrfdateeffective      DATETIME
  DECLARE @dLrfdateexpired        DATETIME
  DECLARE @nLrffrompoint          NUMERIC(24,6)
  DECLARE @nLrftopoint            NUMERIC(24,6)

  DECLARE @sRrlpk                 NVARCHAR(30)
  DECLARE @sRrlnumeric            NVARCHAR(1)
  DECLARE @sRrlinteger            NVARCHAR(1)
  DECLARE @sRrlcode               NVARCHAR(30)
  DECLARE @sQuecode               NVARCHAR(8)
  DECLARE @sQuetext               NVARCHAR(4000)
  DECLARE @sRrlaspect             NVARCHAR(30)
  DECLARE @sRrlchecklisttype      NVARCHAR(8)
  DECLARE @sRrlallowoperatorcl    NVARCHAR(1)
  DECLARE @sTypedesc              NVARCHAR(80)

  DECLARE @sRrlcalculated         NVARCHAR(1)
  DECLARE @sRrlquerycode          NVARCHAR(8)

  DECLARE @sGtcrankingcode        NVARCHAR(30)
  DECLARE @sGtcrankingorg         NVARCHAR(15)
  DECLARE @nGtcrankingrevision    NUMERIC(4)
  DECLARE @sGtcrtype              NVARCHAR(8)
  DECLARE @nGtcprecision          NUMERIC(1)
  DECLARE @sGtctrackhistory       NVARCHAR(1)
  DECLARE @nGtcaverage            NUMERIC(24,6)

  DECLARE @nEqrrankingscore       NUMERIC(24,6)
  DECLARE @sRkkperfformula        NVARCHAR(30)
  DECLARE @sRkkperfformulaorg     NVARCHAR(15)
  DECLARE @sPerfformuladate       DATETIME
  DECLARE @sPerfformula           NVARCHAR(30)
  DECLARE @sPerfformulaorg        NVARCHAR(15)
  DECLARE @dPerfformuladate       DATETIME
  DECLARE @sAutocreateclass       NVARCHAR(1)
  DECLARE @sAutocreatecat         NVARCHAR(1)
  DECLARE @sOcdpk                 NVARCHAR(30)
  DECLARE @sPk                    NVARCHAR(30)
  DECLARE @sRollup                NVARCHAR(1)
  DECLARE @sRstatus               NVARCHAR(8)
  DECLARE @sCapacitycode          NVARCHAR(8)
  DECLARE @sIncludechildren       NVARCHAR(1)
  DECLARE @nMaxfailures           NUMERIC(18)
  DECLARE @sUsagebased            NVARCHAR(1)
  DECLARE @sUsageuom              NVARCHAR(30)
  DECLARE @nUsageperday           NUMERIC(24,6)
  DECLARE @sUsedowntime           NVARCHAR(1)
  DECLARE @sRepairtimecalc        NVARCHAR(8)
  DECLARE @nMaxrepairhours        NUMERIC(24,6)
  DECLARE @sVarquery              NVARCHAR(8)
  DECLARE @nCondweight            NUMERIC(7,6)
  DECLARE @nCapweight             NUMERIC(7,6)
  DECLARE @nMtbfweight            NUMERIC(7,6)
  DECLARE @nMttrweight            NUMERIC(7,6)
  DECLARE @nVar1weight            NUMERIC(7,6)
  DECLARE @nVar2weight            NUMERIC(7,6)
  DECLARE @nVar3weight            NUMERIC(7,6)
  DECLARE @nVar4weight            NUMERIC(7,6)
  DECLARE @nVar5weight            NUMERIC(7,6)
  DECLARE @nVar6weight            NUMERIC(7,6)
  DECLARE @nConditionrating       NUMERIC(9,6)
  DECLARE @nRange                 NUMERIC(24,6)
  DECLARE @nMinscore              NUMERIC(24,6)
  DECLARE @nMaxscore              NUMERIC(24,6)
  DECLARE @nAdjustedscore         NUMERIC(24,6)
  DECLARE @nCapacity              NUMERIC(24,6)
  DECLARE @nDesiredcapacity       NUMERIC(24,6)
  DECLARE @nTotdesiredcapacity    NUMERIC(24,6)
  DECLARE @nDummycapacity         NUMERIC(24,6)
  DECLARE @nCapacityrating        NUMERIC(9,6)
  DECLARE @nNumberoffailures      NUMERIC(10)
  DECLARE @nEvtdowntime           NUMERIC(24,6)
  DECLARE @nEvtcomprrepdt         NUMERIC(24,6)
  DECLARE @nEvtcomprrepdt2        NUMERIC(24,6)
  DECLARE @nMtbf                  NUMERIC(24,6)
  DECLARE @nMtbfrating            NUMERIC(9,6)
  DECLARE @nMubf                  NUMERIC(24,6)
  DECLARE @nMubfrating            NUMERIC(9,6)
  DECLARE @nUomconvfactor         NUMERIC(24,6)
  DECLARE @nConvupd               NUMERIC(24,6)
  DECLARE @nFailureusagemax       NUMERIC(24,6)
  DECLARE @nFailureusage          NUMERIC(24,6)
  DECLARE @nFailures              NUMERIC(24,6)
  DECLARE @nDowntime              NUMERIC(24,6)
  DECLARE @nMttrhours             NUMERIC(24,6)
  DECLARE @nMttrrating            NUMERIC(9,6)
  DECLARE @nBookeddowntime        NUMERIC(24,6)
  DECLARE @nVar1result            NUMERIC(24,6)
  DECLARE @nVar1rating            NUMERIC(9,6)
  DECLARE @nVar2result            NUMERIC(24,6)
  DECLARE @nVar2rating            NUMERIC(9,6)
  DECLARE @nVar3result            NUMERIC(24,6)
  DECLARE @nVar3rating            NUMERIC(9,6)
  DECLARE @nVar4result            NUMERIC(24,6)
  DECLARE @nVar4rating            NUMERIC(9,6)
  DECLARE @nVar5result            NUMERIC(24,6)
  DECLARE @nVar5rating            NUMERIC(9,6)
  DECLARE @nVar6result            NUMERIC(24,6)
  DECLARE @nVar6rating            NUMERIC(9,6)
  DECLARE @nVarweight             NUMERIC(7,6)
  DECLARE @nVarbest               NUMERIC(24,6)
  DECLARE @nVarworst              NUMERIC(24,6)
  DECLARE @nVarresult             NUMERIC(24,6)
  DECLARE @nVarrating             NUMERIC(24,6)
  DECLARE @nPerformance           NUMERIC(9,6)
  DECLARE @i                      INTEGER
  DECLARE @nTotcapacity           NUMERIC(24,6)

BEGIN
  /* Initialize. */
  SET @sChk        = N'0'
  SET @nLoops      = 0
  SET @nRecs       = 0
  SET @nRecsdone   = 0
  SET @nRecslocked = 0

  EXECUTE dbo.O7DFLT @sDeflang OUTPUT, N'DEFLANG', @sChk2 OUTPUT
  SET @sLang = ISNULL( @sLanguage, @sDeflang )

  CREATE TABLE #r5calcobjrrscore(
    gtc_rankingcode               NVARCHAR(30) COLLATE Latin1_General_BIN,
    gtc_rankingorg                NVARCHAR(15) COLLATE Latin1_General_BIN,
    gtc_rankingrevision           NUMERIC(4),
    gtc_precision                 NUMERIC(1),
    gtc_rtype                     NVARCHAR(8)  COLLATE Latin1_General_BIN,
    gtc_trackhistory              NVARCHAR(1)  COLLATE Latin1_General_BIN,
    gtc_score                     NUMERIC(24,6),
    gtc_length                    NUMERIC(24,6) )

  CREATE TABLE #calculatescore(
    csc_levelpk                   NVARCHAR(30) COLLATE Latin1_General_BIN,
    csc_parent                    NVARCHAR(30) COLLATE Latin1_General_BIN,
    csc_code                      NVARCHAR(30) COLLATE Latin1_General_BIN,
    csc_value                     NUMERIC(24,6) )

  IF @sStype = N'O'
    BEGIN
      /* Retrieve reliability ranking info. */
      SELECT @sX = N'x'
      FROM   r5objects
      WHERE  obj_code = @sObj
      AND    obj_org  = @sOrg
      /* Check whether equipment exists, if not set chk to '1' and abort. */
      IF @sX IS NULL
        BEGIN
          SET @sChk = N'1'
          RETURN
        END
    END
  ELSE IF @sStype = N'J'
    BEGIN
      SET @sX = NULL
      /* Check whether objective exists, if not set chk to '1' and abort. */
      SELECT @sX= N'x'
      FROM   r5objectives
      WHERE  ojv_code = @sObj
      AND    ojv_org  = @sOrg
      IF @sX IS NULL
        BEGIN
          SET @sChk = N'1'
          RETURN
        END
    END
  ELSE IF @sStype = N'P'
    BEGIN
      SET @sX = NULL
      /* Check whether policy exists, if not set chk to '1' and abort. */
      SELECT @sX= N'x'
      FROM   r5policies
      WHERE  pol_code = @sObj
      AND    pol_org  = @sOrg
      IF @sX IS NULL
        BEGIN
          SET @sChk = N'1'
          RETURN
        END
    END
  ELSE IF @sStype = N'T'
    BEGIN
      SET @sX = NULL
      /* Check whether strategy exists, if not set chk to '1' and abort. */
      SELECT @sX= N'x'
      FROM   r5strategies
      WHERE  stg_code = @sObj
      AND    stg_org  = @sOrg
      IF @sX IS NULL
        BEGIN
          SET @sChk = N'1'
          RETURN
        END
    END
  ELSE
    BEGIN
      /* Retrieve reliability ranking info. */
      SELECT @sX = N'x'
      FROM   r5reliabilityrankingvalues
      WHERE  rrv_pk = @sObj
      /* Check whether batch record exists, if not set chk to '1' and abort. */
      IF @sX IS NULL
        BEGIN
          SET @sChk = N'1'
          RETURN
        END
    END

  IF @sStype = N'O'
    BEGIN
      /* Check whether equipment has reliability ranking code, if not, set chk to '2' and abort. */
      SELECT @nCnt = COUNT(*)
      FROM   r5equipmentrankings
      WHERE  eqr_objcode = @sObj
      AND    eqr_objorg  = @sOrg
      IF @nCnt = 0
        BEGIN
          SET @sChk = N'2'
          RETURN
        END

      /* Check whether all questions answered, if not set chk to '4' and abort. */
      SELECT @nCnt = COUNT(*)
      FROM   r5reliabilityrankinglevels, r5equipmentrankings
      WHERE  eqr_objcode            = @sObj
      AND    eqr_objorg             = @sOrg
      AND    eqr_rankingcode        = ISNULL( @sRanking, eqr_rankingcode )
      AND    eqr_rankingorg         = ISNULL( @sRankingorg, eqr_rankingorg )
      AND    eqr_rankingrevision    = ISNULL( @nRankingrev, eqr_rankingrevision )
      AND    rrl_reliabilityranking = eqr_rankingcode
      AND    rrl_org                = eqr_rankingorg
      AND    rrl_revision           = eqr_rankingrevision
      AND    rrl_questionlevel      = N'+'
      AND    rrl_calculated         = N'-'
      AND    eqr_lockrankingvalues  = N'-'
      AND    rrl_checklisttype IS NULL
      AND    NOT EXISTS ( SELECT 'x'
                          FROM   r5objectsurvey
                          WHERE  obs_object     = @sObj
                          AND    obs_object_org = @sOrg
                          AND    obs_type       = N'O'
                          AND    obs_levelpk    = rrl_pk
                          AND    (    obs_answerpk IS NOT NULL
                                   OR obs_value    IS NOT NULL ) )
      IF @nCnt > 0
        BEGIN
          SET @sChk = N'4'
          RETURN
        END
    END
  ELSE IF @sStype = N'J'
    BEGIN
      /* Check whether objective has reliability ranking code, if not, set chk to '2' and abort. */
      SELECT @nCnt = COUNT(*)
      FROM   r5objectives
      WHERE  ojv_code = @sObj
      AND    ojv_org  = @sOrg
      AND    ojv_rankingcode IS NOT NULL
      IF @nCnt = 0
        BEGIN
          SET @sChk = N'2'
          RETURN
        END

      /* Check whether all questions answered, if not, set chk to '4' and abort. */
      SELECT @nCnt = COUNT( * )
      FROM   r5reliabilityrankinglevels, r5objectives
      WHERE  ojv_code               = @sObj
      AND    ojv_org                = @sOrg
      AND    rrl_reliabilityranking = ojv_rankingcode
      AND    rrl_org                = ojv_rankingorg
      AND    rrl_revision           = ojv_rankingrevision
      AND    rrl_questionlevel      = N'+'
      AND    rrl_calculated         = N'-'
      AND    ojv_lockrankingvalues  = N'-'
      AND    rrl_checklisttype IS NULL
      AND    NOT EXISTS ( SELECT 'x'
                          FROM   r5objectsurvey
                          WHERE  obs_object     = @sObj
                          AND    obs_object_org = @sOrg
                          AND    obs_type       = N'J'
                          AND    obs_levelpk    = rrl_pk
                          AND    (    obs_answerpk IS NOT NULL
                                   OR obs_value    IS NOT NULL ) )
      IF @nCnt > 0
        BEGIN
          SET @sChk = N'4'
          RETURN
        END
    END
  ELSE IF @sStype = N'P'
    BEGIN
      /* Check whether policy has reliability ranking code, if not, set chk to '2' and abort. */
      SELECT @nCnt = COUNT(*)
      FROM   r5policies
      WHERE  pol_code = @sObj
      AND    pol_org  = @sOrg
      AND    pol_rankingcode IS NOT NULL
      IF @nCnt = 0
        BEGIN
          SET @sChk = N'2'
          RETURN
        END

      /* Check whether all questions answered, if not, set chk to '4' and abort. */
      SELECT @nCnt = COUNT( * )
      FROM   r5reliabilityrankinglevels, r5policies
      WHERE  pol_code               = @sObj
      AND    pol_org                = @sOrg
      AND    rrl_reliabilityranking = pol_rankingcode
      AND    rrl_org                = pol_rankingorg
      AND    rrl_revision           = pol_rankingrevision
      AND    rrl_questionlevel      = N'+'
      AND    rrl_calculated         = N'-'
      AND    pol_lockrankingvalues  = N'-'
      AND    rrl_checklisttype IS NULL
      AND    NOT EXISTS ( SELECT 'x'
                          FROM   r5objectsurvey
                          WHERE  obs_object     = @sObj
                          AND    obs_object_org = @sOrg
                          AND    obs_type       = N'P'
                          AND    obs_levelpk    = rrl_pk
                          AND    (    obs_answerpk IS NOT NULL
                                   OR obs_value    IS NOT NULL ) )
      IF @nCnt > 0
        BEGIN
          SET @sChk = N'4'
          RETURN
        END
    END
  ELSE IF @sStype = N'T'
    BEGIN
      /* Check whether strategy has reliability ranking code, if not, set chk to '2' and abort. */
      SELECT @nCnt = COUNT(*)
      FROM   r5strategies
      WHERE  stg_code = @sObj
      AND    stg_org  = @sOrg
      AND    stg_rankingcode IS NOT NULL
      IF @nCnt = 0
        BEGIN
          SET @sChk = N'2'
          RETURN
        END

      /* Check whether all questions answered, if not, set chk to '4' and abort. */
      SELECT @nCnt = COUNT( * )
      FROM   r5reliabilityrankinglevels, r5strategies
      WHERE  stg_code               = @sObj
      AND    stg_org                = @sOrg
      AND    rrl_reliabilityranking = stg_rankingcode
      AND    rrl_org                = stg_rankingorg
      AND    rrl_revision           = stg_rankingrevision
      AND    rrl_questionlevel      = N'+'
      AND    rrl_calculated         = N'-'
      AND    stg_lockrankingvalues  = N'-'
      AND    rrl_checklisttype IS NULL
      AND    NOT EXISTS ( SELECT 'x'
                          FROM   r5objectsurvey
                          WHERE  obs_object     = @sObj
                          AND    obs_object_org = @sOrg
                          AND    obs_type       = N'T'
                          AND    obs_levelpk    = rrl_pk
                          AND    (    obs_answerpk IS NOT NULL
                                   OR obs_value    IS NOT NULL ) )
      IF @nCnt > 0
        BEGIN
          SET @sChk = N'4'
          RETURN
        END
    END
  ELSE
    BEGIN
      /* Check whether all questions answered, if not, set chk to '4' and abort. */
      SELECT @nCnt = COUNT( * )
      FROM   r5reliabilityrankinglevels, r5reliabilityrankingvalues
      WHERE  rrl_reliabilityranking = rrv_reliabilityranking
      AND    rrl_org                = rrv_reliabilityranking_org
      AND    rrl_revision           = rrv_reliabilityrankingrev
      AND    rrl_questionlevel      = N'+'
      AND    rrl_calculated         = N'-'
      AND    rrv_pk                 = @sObj
      AND    NOT EXISTS ( SELECT 'x'
                          FROM   r5objectsurvey
                          WHERE  obs_object  = @sObj
                          AND    obs_type    = N'S'
                          AND    obs_levelpk = rrl_pk
                          AND    (    obs_answerpk IS NOT NULL
                                   OR obs_value    IS NOT NULL ) )
      IF @nCnt > 0
        BEGIN
          SET @sChk = N'4'
          RETURN
        END
    END

  /* Cursor to retrieve linear equipment without linear condition records. */
  DECLARE lrf CURSOR LOCAL STATIC FOR
    SELECT DISTINCT dbo.o7pointuomconv( obj_lengthuom, obj_linearrefuom ) * obj_length
    FROM   r5reliabilityrankings, r5equipmentrankings, r5objects
    WHERE  rrk_code            = eqr_rankingcode
    AND    rrk_org             = eqr_rankingorg
    AND    rrk_revision        = eqr_rankingrevision
    AND    obj_code            = eqr_objcode
    AND    obj_org             = eqr_objorg
    AND    eqr_objcode         = @sObj
    AND    eqr_objorg          = @sOrg
    AND    eqr_rankingcode     = ISNULL( @sRanking, eqr_rankingcode )
    AND    eqr_rankingorg      = ISNULL( @sRankingorg, eqr_rankingorg )
    AND    eqr_rankingrevision = ISNULL( @nRankingrev, eqr_rankingrevision )
    AND    @sStype             = N'O'
    AND    rrk_rtype          IN ( N'CI', N'RPI', N'CRI' )
    AND    obj_length IS NOT NULL
    AND    NOT EXISTS ( SELECT 1
                        FROM   r5objlinearref
                        WHERE  lrf_objcode = eqr_objcode
                        AND    lrf_objorg  = eqr_objorg
                        AND    lrf_linear_reftype = N'I'
                        AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN lrf_dateeffective AND lrf_dateexpired )
  OPEN lrf
  FETCH NEXT FROM lrf INTO @nObjlength
  WHILE @@FETCH_STATUS = 0
    BEGIN
      /* Check if there is record in the future. */
      SET @dDateeffective = NULL
      SELECT @dDateeffective = MIN( lrf_dateeffective )
      FROM   r5objlinearref
      WHERE  lrf_objcode        = @sObj
      AND    lrf_objorg         = @sOrg
      AND    lrf_linear_reftype = N'I'
      AND    lrf_dateeffective  > dbo.F_TRUNC_DATE( GETDATE(), N'DD' )
      INSERT INTO r5objlinearref( lrf_objcode, lrf_objorg, lrf_refrtype, lrf_reftype, lrf_frompoint, lrf_topoint,
             lrf_dateeffective, lrf_dateexpired, lrf_linear_reftype, lrf_created, lrf_createdby )
      SELECT @sObj, @sOrg, N'POI', uco_code, 0, @nObjlength,
             dbo.F_TRUNC_DATE( GETDATE(), N'DD' ), ISNULL( @dDateeffective - 1, dbo.TO_DATE( N'2099-12-31', N'YYYY-MM-DD' ) ), N'I', GETDATE(), N'R5'
      FROM   r5ucodes
      WHERE  uco_rentity = N'LRTP'
      AND    uco_rcode   = N'POI'
      AND    uco_system  = N'+'
      FETCH NEXT FROM lrf INTO @nObjlength
    END
  CLOSE lrf
  DEALLOCATE lrf

  /* Cursor to retrieve all rankings of current object. */
  DECLARE eqr CURSOR LOCAL STATIC FOR
    SELECT ISNULL( eqr_refreshsequence, 0 ),
           eqr_rankingcode,
           eqr_rankingorg,
           eqr_rankingrevision,
           rrk_desc,
           rrk_type,
           rrk_rtype,
           rrk_conditionprotocol,
           rrk_condscorestart,
           rrk_condscoreend,
           rrk_condscorethreshold,
           rrk_decaycurve,
           rrk_decaycurve_org,
           rrk_trackhistory,
           rrk_precision,
           dcr_metuom,
           eqr_default,
           eqr_lockrankingvalues,
           obj_servicelife,
           obj_servicelifeusage,
           obj_category,
           obj_class,
           obj_class_org,
           obj_primaryuom,
           obj_corrconditionscore,
           CASE WHEN obj_corrconditionscore IS NULL THEN NULL ELSE obj_corrconditiondate END,
           CASE WHEN obj_corrconditionscore IS NULL THEN NULL ELSE obj_corrconditionusage END,
           obj_commiss,
           obj_frompoint,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           dbo.F_LEAST_DATE( CASE WHEN obj_corrconditionscore IS NULL THEN obj_commiss ELSE
             CASE WHEN obj_corrconditiondate > GETDATE() THEN obj_commiss ELSE ISNULL( obj_corrconditiondate, obj_commiss ) END END, dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) ),
           CASE WHEN obj_corrconditionscore IS NULL THEN rrk_condscorestart ELSE
             CASE WHEN obj_corrconditiondate > GETDATE() THEN rrk_condscorestart ELSE ISNULL( obj_corrconditionscore, rrk_condscorestart ) END END,
           oud_totalusage,
           oud_uom,
           CASE COALESCE( oud_calcdailyusg, oud_dfltdailyusg, oud_totalusage / dbo.F_GREATEST_NUMBER( DATEDIFF( dd, obj_commiss, dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) ), 1 ) ) WHEN 0 THEN NULL
             ELSE COALESCE( oud_calcdailyusg, oud_dfltdailyusg, oud_totalusage / dbo.F_GREATEST_NUMBER(  DATEDIFF( dd, obj_commiss, dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) ), 1 ) ) END,
           CASE WHEN obj_corrconditionscore IS NOT NULL AND obj_corrconditionusage <= oud_totalusage THEN obj_corrconditionusage ELSE 0 END,
           CASE WHEN obj_corrconditionscore IS NOT NULL AND obj_corrconditionusage <= oud_totalusage THEN obj_corrconditionscore ELSE rrk_condscorestart END,
           CASE WHEN obj_corrconditionscore IS NOT NULL AND obj_corrconditiondate <= GETDATE() THEN '+' ELSE '-' END
    FROM   r5reliabilityrankings LEFT OUTER JOIN r5decaycurve ON ( dcr_code = rrk_decaycurve AND dcr_org = rrk_decaycurve_org ),
           r5equipmentrankings, r5objects
           LEFT OUTER JOIN r5objusagedefs ON ( oud_object = obj_code AND oud_object_org = obj_org AND oud_uom = obj_primaryuom )
    WHERE  rrk_code            = eqr_rankingcode
    AND    rrk_org             = eqr_rankingorg
    AND    rrk_revision        = eqr_rankingrevision
    AND    obj_code            = eqr_objcode
    AND    obj_org             = eqr_objorg
    AND    eqr_objcode         = @sObj
    AND    eqr_objorg          = @sOrg
    AND    eqr_rankingcode     = ISNULL( @sRanking, eqr_rankingcode )
    AND    eqr_rankingorg      = ISNULL( @sRankingorg, eqr_rankingorg )
    AND    eqr_rankingrevision = ISNULL( @nRankingrev, eqr_rankingrevision )
    AND    @sStype             = N'O'
    AND    ( obj_length IS NULL OR rrk_rtype IN ( N'RI', N'FCI' ) )
    UNION
    SELECT ISNULL( ojv_refreshsequence, 0 ),
           ojv_rankingcode,
           ojv_rankingorg,
           ojv_rankingrevision,
           rrk_desc,
           rrk_type,
           rrk_rtype,
           rrk_conditionprotocol,
           rrk_condscorestart,
           rrk_condscoreend,
           rrk_condscorethreshold,
           rrk_decaycurve,
           rrk_decaycurve_org,
           rrk_trackhistory,
           rrk_precision,
           NULL,
           NULL,
           ojv_lockrankingvalues,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL
    FROM   r5reliabilityrankings, r5objectives
    WHERE  rrk_code            = ojv_rankingcode
    AND    rrk_org             = ojv_rankingorg
    AND    rrk_revision        = ojv_rankingrevision
    AND    ojv_code            = @sObj
    AND    ojv_org             = @sOrg
    AND    @sStype             = N'J'
    UNION
    SELECT ISNULL( pol_refreshsequence, 0 ),
           pol_rankingcode,
           pol_rankingorg,
           pol_rankingrevision,
           rrk_desc,
           rrk_type,
           rrk_rtype,
           rrk_conditionprotocol,
           rrk_condscorestart,
           rrk_condscoreend,
           rrk_condscorethreshold,
           rrk_decaycurve,
           rrk_decaycurve_org,
           rrk_trackhistory,
           rrk_precision,
           NULL,
           NULL,
           pol_lockrankingvalues,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL
    FROM   r5reliabilityrankings, r5policies
    WHERE  rrk_code            = pol_rankingcode
    AND    rrk_org             = pol_rankingorg
    AND    rrk_revision        = pol_rankingrevision
    AND    pol_code            = @sObj
    AND    pol_org             = @sOrg
    AND    @sStype             = N'P'
    UNION
    SELECT ISNULL( stg_refreshsequence, 0 ),
           stg_rankingcode,
           stg_rankingorg,
           stg_rankingrevision,
           rrk_desc,
           rrk_type,
           rrk_rtype,
           rrk_conditionprotocol,
           rrk_condscorestart,
           rrk_condscoreend,
           rrk_condscorethreshold,
           rrk_decaycurve,
           rrk_decaycurve_org,
           rrk_trackhistory,
           rrk_precision,
           NULL,
           NULL,
           stg_lockrankingvalues,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL
    FROM   r5reliabilityrankings, r5strategies
    WHERE  rrk_code            = stg_rankingcode
    AND    rrk_org             = stg_rankingorg
    AND    rrk_revision        = stg_rankingrevision
    AND    stg_code            = @sObj
    AND    stg_org             = @sOrg
    AND    @sStype             = N'T'
    UNION
    SELECT ISNULL( eqr_refreshsequence, 0 ) refreshsequence,
           eqr_rankingcode,
           eqr_rankingorg,
           eqr_rankingrevision,
           rrk_desc,
           rrk_type,
           rrk_rtype,
           rrk_conditionprotocol,
           rrk_condscorestart,
           rrk_condscoreend,
           rrk_condscorethreshold,
           rrk_decaycurve,
           rrk_decaycurve_org,
           rrk_trackhistory,
           rrk_precision,
           dcr_metuom,
           eqr_default,
           eqr_lockrankingvalues,
           ISNULL( lrf_servicelife, obj_servicelife ) obj_servicelife,
           ISNULL( lrf_servicelifeusage, obj_servicelifeusage ) obj_servicelifeusage,
           obj_category,
           obj_class,
           obj_class_org,
           obj_primaryuom,
           ISNULL( lrf_corrconditionscore, obj_corrconditionscore ) obj_corrconditionscore,
           CASE WHEN ISNULL( lrf_corrconditionscore, obj_corrconditionscore ) IS NULL THEN NULL
             ELSE CASE WHEN lrf_corrconditionscore IS NOT NULL THEN lrf_corrconditiondate ELSE obj_corrconditiondate END END obj_corrconditiondate,
           CASE WHEN ISNULL( lrf_corrconditionscore, obj_corrconditionscore ) IS NULL THEN NULL
             ELSE CASE WHEN lrf_corrconditionscore IS NOT NULL THEN lrf_corrconditionusage ELSE obj_corrconditionusage END END obj_corrconditionusage,
           ISNULL( lrf_commissiondate, obj_commiss ) obj_commiss,
           obj_frompoint,
           lrf_id,
           ABS( lrf_topoint - lrf_frompoint ),
           lrf_dateeffective,
           lrf_dateexpired,
           lrf_frompoint,
           lrf_topoint,
           dbo.F_LEAST_DATE(
             CASE WHEN ISNULL( lrf_corrconditionscore, obj_corrconditionscore ) IS NULL THEN
                ISNULL( lrf_commissiondate, obj_commiss )
              ELSE
                CASE WHEN lrf_corrconditionscore IS NOT NULL THEN
                  CASE WHEN lrf_corrconditiondate > GETDATE() THEN
                    ISNULL( lrf_commissiondate, obj_commiss )
                  ELSE
                    lrf_corrconditiondate
                  END
                ELSE
                  CASE WHEN obj_corrconditiondate > GETDATE() THEN
                    ISNULL( lrf_commissiondate, obj_commiss )
                  ELSE
                    obj_corrconditiondate
                  END
                END
              END, dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) ),
           CASE WHEN ISNULL( lrf_corrconditionscore, obj_corrconditionscore ) IS NULL THEN
             rrk_condscorestart
           ELSE
             CASE WHEN ISNULL( lrf_corrconditiondate, obj_corrconditiondate ) > GETDATE() THEN
               rrk_condscorestart
             ELSE
               ISNULL( lrf_corrconditionscore, obj_corrconditionscore )
             END
           END,
           oud_totalusage,
           oud_uom,
           CASE COALESCE( oud_calcdailyusg, oud_dfltdailyusg, oud_totalusage /
             dbo.F_GREATEST_NUMBER( DATEDIFF( dd, ISNULL( lrf_commissiondate, obj_commiss ), dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) ), 1 ) ) WHEN 0 THEN NULL
             ELSE COALESCE( oud_calcdailyusg, oud_dfltdailyusg, oud_totalusage /
             dbo.F_GREATEST_NUMBER(  DATEDIFF( dd, ISNULL( lrf_commissiondate, obj_commiss ), dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) ), 1 ) ) END,
           CASE WHEN ISNULL( lrf_corrconditionscore, obj_corrconditionscore ) IS NOT NULL AND ISNULL( lrf_corrconditionusage, obj_corrconditionusage ) <= oud_totalusage
             THEN obj_corrconditionusage ELSE 0 END,
           CASE WHEN ISNULL( lrf_corrconditionscore, obj_corrconditionscore ) IS NOT NULL AND ISNULL( lrf_corrconditionusage, obj_corrconditionusage ) <= oud_totalusage
             THEN obj_corrconditionscore ELSE rrk_condscorestart END,
           CASE WHEN ISNULL( lrf_corrconditionscore, obj_corrconditionscore ) IS NOT NULL AND ISNULL( lrf_corrconditiondate, obj_corrconditiondate ) <= GETDATE() THEN '+' ELSE '-' END
    FROM   r5reliabilityrankings LEFT OUTER JOIN r5decaycurve ON ( dcr_code = rrk_decaycurve AND dcr_org = rrk_decaycurve_org ),
           r5equipmentrankings, r5objlinearref, r5objects
           LEFT OUTER JOIN r5objusagedefs ON ( oud_object = obj_code AND oud_object_org = obj_org AND oud_uom = obj_primaryuom )
    WHERE  lrf_objcode         = eqr_objcode
    AND    lrf_objorg          = eqr_objorg
    AND    rrk_code            = eqr_rankingcode
    AND    rrk_org             = eqr_rankingorg
    AND    rrk_revision        = eqr_rankingrevision
    AND    obj_code            = eqr_objcode
    AND    obj_org             = eqr_objorg
    AND    eqr_objcode         = @sObj
    AND    eqr_objorg          = @sOrg
    AND    eqr_rankingcode     = ISNULL( @sRanking, eqr_rankingcode )
    AND    eqr_rankingorg      = ISNULL( @sRankingorg, eqr_rankingorg )
    AND    eqr_rankingrevision = ISNULL( @nRankingrev, eqr_rankingrevision )
    AND    @sStype             = N'O'
    AND    lrf_linear_reftype  = N'I'
    AND    obj_length IS NOT NULL
    AND    rrk_rtype IN ( N'CI', N'RPI', N'CRI' )
    AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN lrf_dateeffective AND lrf_dateexpired
    UNION
    SELECT 0,
           rrv_reliabilityranking,
           rrv_reliabilityranking_org,
           rrv_reliabilityrankingrev,
           rrk_desc,
           rrk_type,
           rrk_rtype,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           rrk_precision,
           NULL,
           N'-',
           N'-',
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL
    FROM   r5reliabilityrankings, r5reliabilityrankingvalues
    WHERE  rrk_code     = rrv_reliabilityranking
    AND    rrk_org      = rrv_reliabilityranking_org
    AND    rrk_revision = rrv_reliabilityrankingrev
    AND    rrv_pk       = @sObj
    AND    @sStype      = N'S'
    ORDER BY 1

  OPEN eqr
  FETCH NEXT FROM eqr INTO @nRefreshsequence, @sEqrrankingcode, @sEqrrankingorg, @nEqrrankingrev, @sRrkdesc, @sRrktype, @sRrkrtype, @sRrkconditionprotocol,
                           @nRrkcondscorestart, @nRrkcondscoreend, @nRrkcondscorethreshold, @sRrkdecaycurve, @sRrkdecaycurveorg, @sRrktrackhistory, @nRrkprecision, @sDcrmetuom,
                           @sEqrdefault, @sEqrlocked, @nObjservicelife, @nObjservicelifeusage, @sObjcategory, @sObjclass, @sObjclassorg, @sObjprimaryuom,
                           @nObjcorrconditionscore, @dObjcorrconditiondate, @nObjcorrconditionusage, @dObjcommiss, @nObjfrompoint,
                           @nLrfid, @nLrflength, @dLrfdateeffective, @dLrfdateexpired, @nLrffrompoint, @nLrftopoint, @dRefdate, @nStartscore, @nOudtotalusage,
                           @sOuduom, @nDailyusage, @nUsagecorr, @nStartscoreusage, @sCheckrefpoint
  WHILE @@FETCH_STATUS = 0
    BEGIN
      SET @nScore            = NULL
      SET @sRrindex          = NULL
      SET @sCompleted        = N'-'
      SET @sToplevelpk       = NULL
      SET @sTopleveldesc     = NULL
      SET @nRecs             = @nRecs + 1
      SET @nLoops            = 0
      SET @dEndoflife        = NULL
      SET @nServicelife      = NULL
      SET @nServicelifeusage = NULL
      SET @nUsagecorrection  = 0
      SET @sErrorfound       = N'-'

      IF @sEqrlocked = N'+'
        BEGIN
          SET @nRecslocked = @nRecslocked + 1
          GOTO END_OF_EQR
        END

      IF @nLrffrompoint IS NOT NULL
        SET @sExtramessage = ' ' + CAST( @nLrffrompoint + ISNULL( @nObjfrompoint, 0 ) AS NVARCHAR ) + ' ' + CAST( @nLrftopoint + ISNULL( @nObjfrompoint, 0 ) AS NVARCHAR )
      ELSE
        SET @sExtramessage = ''

      IF @sRrkconditionprotocol IS NOT NULL AND @sRrkconditionprotocol <> N'CI'
        BEGIN
          /* Condition Protocol ... */
          IF @sRrkconditionprotocol IN ( N'U', N'DCU', N'DCPU' ) AND @sOuduom IS NULL
            BEGIN
              /* Give error if no primary UOM found. */
              SET @sChk        = N'14'
              SET @nScore      = NULL
              SET @sRrindex    = NULL
              GOTO END_OF_EQR
            END
          /* First calculate 'things' used in multiple protocols. */
          IF @sRrkconditionprotocol IN ( N'A', N'DCPA' )
            BEGIN
              /* Calculate service life. */
              SET @nServicelife = @nObjservicelife
              IF @nServicelife IS NULL
                BEGIN
                  /* Get service life from category. */
                  SELECT @nServicelife = ocd_servicelife
                  FROM   r5assetclassdefinition
                  WHERE  ocd_org       = @sOrg
                  AND    ocd_category  = @sObjcategory
                  AND    ocd_class     = @sObjclass
                  AND    ocd_class_org = @sObjclassorg
                  IF @nServicelife IS NULL
                    BEGIN
                      /* Get service life from class. */
                      SELECT @nServicelife = ocd_servicelife
                      FROM   r5assetclassdefinition
                      WHERE  ocd_org       = @sOrg
                      AND    ocd_class     = @sObjclass
                      AND    ocd_class_org = @sObjclassorg
                      IF @nServicelife IS NULL
                        BEGIN
                          /* Get service life from '*' class. */
                          SELECT @nServicelife = ocd_servicelife
                          FROM   r5assetclassdefinition
                          WHERE  ocd_org       = @sOrg
                          AND    ocd_class     = N'*'
                          AND    ocd_class_org = N'*'
                          IF @nServicelife IS NULL
                            /* Get service life from '*' class within '*' organization. */
                            SELECT @nServicelife = ocd_servicelife
                            FROM   r5assetclassdefinition
                            WHERE  ocd_org       = N'*'
                            AND    ocd_class     = N'*'
                            AND    ocd_class_org = N'*'
                        END
                    END
                END
              IF ISNULL( @nServicelife, 0 ) = 0
                BEGIN
                  /* Give error if no service life. */
                  SET @sChk        = N'13'
                  SET @nScore      = NULL
                  SET @sRrindex    = NULL
                  GOTO END_OF_EQR
                END
            END
          IF @sRrkconditionprotocol IN ( N'U', N'DCPU' )
            BEGIN
              SET @nServicelifeusage = @nObjservicelifeusage
              IF @nServicelifeusage IS NULL
                BEGIN
                  /* Get service life from category. */
                  SELECT @nServicelifeusage = adu_servicelifeusage
                  FROM   r5assetclassdefusages, r5assetclassdefinition
                  WHERE  adu_ocdpk     = ocd_pk
                  AND    ocd_org       = @sOrg
                  AND    ocd_class     = @sObjclass
                  AND    ocd_class_org = @sObjclassorg
                  AND    adu_uom       = @sObjprimaryuom
                  AND    ocd_category  = @sObjcategory
                  IF @nServicelifeusage IS NULL
                    BEGIN
                      SELECT @nServicelifeusage = ocd_servicelifeusage
                      FROM   r5assetclassdefinition
                      WHERE  ocd_org       = @sOrg
                      AND    ocd_category  = @sObjcategory
                      AND    ocd_class     = @sObjclass
                      AND    ocd_class_org = @sObjclassorg
                      AND    ocd_metuom    = @sObjprimaryuom
                      IF @nServicelifeusage IS NULL
                        BEGIN
                          /* Get service life from class. */
                          SELECT @nServicelifeusage = adu_servicelifeusage
                          FROM   r5assetclassdefusages, r5assetclassdefinition
                          WHERE  adu_ocdpk     = ocd_pk
                          AND    ocd_org       = @sOrg
                          AND    ocd_class     = @sObjclass
                          AND    ocd_class_org = @sObjclassorg
                          AND    adu_uom       = @sObjprimaryuom
                          IF @nServicelifeusage IS NULL
                            BEGIN
                              SELECT @nServicelifeusage = ocd_servicelifeusage
                              FROM   r5assetclassdefinition
                              WHERE  ocd_org       = @sOrg
                              AND    ocd_class     = @sObjclass
                              AND    ocd_class_org = @sObjclassorg
                              AND    ocd_metuom    = @sObjprimaryuom
                              IF @nServicelifeusage IS NULL
                                BEGIN
                                  /* Get service life from '*' class. */
                                  SELECT @nServicelifeusage = adu_servicelifeusage
                                  FROM   r5assetclassdefusages, r5assetclassdefinition
                                  WHERE  adu_ocdpk     = ocd_pk
                                  AND    ocd_org       = @sOrg
                                  AND    ocd_class     = N'*'
                                  AND    ocd_class_org = N'*'
                                  AND    adu_uom       = @sObjprimaryuom
                                  IF @nServicelifeusage IS NULL
                                    BEGIN
                                      SELECT @nServicelifeusage = ocd_servicelifeusage
                                      FROM   r5assetclassdefinition
                                      WHERE  ocd_org       = @sOrg
                                      AND    ocd_class     = N'*'
                                      AND    ocd_class_org = N'*'
                                      AND    ocd_metuom    = @sObjprimaryuom
                                      IF @nServicelifeusage IS NULL
                                        BEGIN
                                          /* Get service life from * class and * org. */
                                          SELECT @nServicelifeusage = adu_servicelifeusage
                                          FROM   r5assetclassdefusages, r5assetclassdefinition
                                          WHERE  adu_ocdpk     = ocd_pk
                                          AND    ocd_org       = N'*'
                                          AND    ocd_class     = N'*'
                                          AND    ocd_class_org = N'*'
                                          AND    adu_uom       = @sObjprimaryuom
                                          IF @nServicelifeusage IS NULL
                                            SELECT @nServicelifeusage = ocd_servicelifeusage
                                            FROM   r5assetclassdefinition
                                            WHERE  ocd_org       = N'*'
                                            AND    ocd_class     = N'*'
                                            AND    ocd_class_org = N'*'
                                            AND    ocd_metuom    = @sObjprimaryuom
                                        END
                                    END
                                END
                            END
                        END
                    END
                END
              IF ISNULL( @nServicelifeusage, 0 ) = 0
                BEGIN
                  /* Give error if no service life usage. */
                  SET @sChk        = N'13'
                  SET @nScore      = NULL
                  SET @sRrindex    = NULL
                  GOTO END_OF_EQR
                END
            END

          IF @sRrkconditionprotocol = N'DCU'
            BEGIN
              /* Check if the meter UOM of the decay curve matches the primary UOM of the equipment. */
              IF ISNULL( @sDcrmetuom, N'@#$' ) <> ISNULL( @sObjprimaryuom, N'$#@' )
                BEGIN
                  SET @sChk        = N'18'
                  SET @nScore      = NULL
                  SET @sRrindex    = NULL
                  GOTO END_OF_EQR
                END
            END

          IF @sRrkconditionprotocol IN ( N'DCA', N'DCPA' )
            BEGIN
              /* Calculate age correction and age. */
              IF @sCheckrefpoint = N'-'
                SET @nAgecorrection = 0
              ELSE
                BEGIN
                  /* Try to find the age correction using points on the decay curve. */
                  SET @nRefpoint = NULL
                  SELECT @nRefpoint = MIN( cpd_periodusage )
                  FROM   r5decaycurvepoints
                  WHERE  cpd_dccode = @sRrkdecaycurve
                  AND    cpd_dcorg  = @sRrkdecaycurveorg
                  AND    ABS( cpd_conditionscore - @nObjcorrconditionscore ) =
                         ( SELECT MIN( ABS( cpd_conditionscore - @nObjcorrconditionscore ) )
                           FROM   r5decaycurvepoints
                           WHERE  cpd_dccode = @sRrkdecaycurve
                           AND    cpd_dcorg  = @sRrkdecaycurveorg )
                  IF @sRrkconditionprotocol IN ( N'DCPA' )
                    SET @nRefpoint = @nRefpoint * @nServicelife / 100.0
                  SET @nAgecorrection = ( DATEDIFF( dd, dbo.F_LEAST_DATE( @dObjcommiss, GETDATE() ), @dObjcorrconditiondate ) / 365.0 ) - @nRefpoint
                END
              SET @nAge = ( DATEDIFF( dd, dbo.F_LEAST_DATE( @dObjcommiss, GETDATE() ), GETDATE() ) / 365.0 ) - ISNULL( @nAgecorrection, 0 )
            END
          IF @sRrkconditionprotocol IN ( N'DCU', N'DCPU' )
            BEGIN
              /* Calculate usage correction. */
              IF @nUsagecorr > 0
                BEGIN
                  /* Try to find the usage correction using points on the decay curve. */
                  SET @nRefpoint = NULL
                  SELECT @nRefpoint = MIN( cpd_periodusage )
                  FROM   r5decaycurvepoints
                  WHERE  cpd_dccode = @sRrkdecaycurve
                  AND    cpd_dcorg  = @sRrkdecaycurveorg
                  AND    ABS( cpd_conditionscore - @nObjcorrconditionscore ) =
                         ( SELECT MIN( ABS( cpd_conditionscore - @nObjcorrconditionscore ) )
                           FROM   r5decaycurvepoints
                           WHERE  cpd_dccode = @sRrkdecaycurve
                           AND    cpd_dcorg  = @sRrkdecaycurveorg )
                  IF @sRrkconditionprotocol IN ( N'DCPU' )
                    SET @nRefpoint = @nRefpoint * @nServicelifeusage / 100.0
                  SET @nUsagecorrection = @nObjcorrconditionusage - @nRefpoint
                END
              SET @nUsage = @nOudtotalusage - ISNULL( @nUsagecorrection, 0 )
            END
          IF @sRrkconditionprotocol IN ( N'DCA', N'DCPA', N'DCU', N'DCPU' )
            BEGIN
              /* Calculate threshold. */
              SET @nThreshold = NULL
              SELECT @nThreshold = MIN( cpd_periodusage )
              FROM   r5decaycurvepoints
              WHERE  cpd_dccode = @sRrkdecaycurve
              AND    cpd_dcorg  = @sRrkdecaycurveorg
              AND    ABS( cpd_conditionscore - @nRrkcondscorethreshold) =
                     ( SELECT MIN( ABS( cpd_conditionscore - @nRrkcondscorethreshold ) )
                       FROM   r5decaycurvepoints
                       WHERE  cpd_dccode = @sRrkdecaycurve
                       AND    cpd_dcorg  = @sRrkdecaycurveorg )
            END
          IF @sRrkconditionprotocol = N'A'
            BEGIN
              /* Age based Condition Protocol. */
              SET @nIncrement = ( @nRrkcondscoreend - @nRrkcondscorestart ) / @nServicelife
              SET @nScore     = ( DATEDIFF( dd, @dRefdate, GETDATE() ) / 365.0 * @nIncrement ) + ISNULL( @nStartscore, 0 )
              SET @dEndoflife = dbo.F_TRUNC_DATE( GETDATE() + ( ( @nRrkcondscorethreshold - @nScore ) / @nIncrement * 365.0 ), N'DD' )
            END
          ELSE IF @sRrkconditionprotocol = N'U'
            BEGIN
              /* Usage based Condition Protocol. */
              SET @nIncrement = ( @nRrkcondscoreend - @nRrkcondscorestart ) / @nServicelifeusage
              SET @nScore     = ( ( @nOudtotalusage - @nUsagecorr ) * @nIncrement ) + @nStartscoreusage
              SET @dEndoflife = dbo.F_TRUNC_DATE( GETDATE() + ( ( @nRrkcondscorethreshold - @nScore ) / @nIncrement / @NDailyusage ), N'DD' )
            END
          ELSE IF @sRrkconditionprotocol = N'DCA'
            BEGIN
              /* Age based Decay Curve Condition Protocol. */
              SET @nScore     = dbo.O7CALCOBJRRSCORE_GETSCORE( @sRrkdecaycurve, @sRrkdecaycurveorg, @nAge )
              SET @dEndoflife = dbo.F_TRUNC_DATE( GETDATE() + ( ( @nThreshold - @nAge ) * 365.0 ), N'DD' )
            END
          ELSE IF @sRrkconditionprotocol = N'DCPA'
            BEGIN
              /* Age percentage based Decay Curve Condition Protocol. */
              SET @nAgepercentage = @nAge / @nServicelife * 100.0
              SET @nScore         = dbo.O7CALCOBJRRSCORE_GETSCORE( @sRrkdecaycurve, @sRrkdecaycurveorg, @nAgepercentage )
              SET @dEndoflife     = dbo.F_TRUNC_DATE( GETDATE() + ( ( ( @nThreshold / 100.0 * @nServicelife ) - @nAge  ) * 365.0 ), N'DD' )
            END
          ELSE IF @sRrkconditionprotocol = N'DCU'
            BEGIN
              /* Usage based Decay Curve Condition Protocol. */
              SET @nScore     = dbo.O7CALCOBJRRSCORE_GETSCORE( @sRrkdecaycurve, @sRrkdecaycurveorg, @nUsage )
              SET @dEndoflife = dbo.F_TRUNC_DATE( GETDATE() + ( ( @nThreshold - @nUsage ) / @nDailyusage ), N'DD' )
            END
          ELSE IF @sRrkconditionprotocol = N'DCPU'
            BEGIN
              /* Usage percentage based Decay Curve Condition Protocol. */
              SET @nUsagepercentage = @nUsage / @nServicelifeusage * 100.0
              SET @nScore           = dbo.O7CALCOBJRRSCORE_GETSCORE( @sRrkdecaycurve, @sRrkdecaycurveorg, @nUsagepercentage )
              SET @dEndoflife       = dbo.F_TRUNC_DATE( GETDATE() + ( ( @nThreshold / 100.0 * @nServicelifeusage - @nUsage ) / @nDailyusage ), N'DD' )
            END
        END
      ELSE
        BEGIN
          /* Normal Ranking. */
          /* Find highest level pk. */
          SELECT @sToplevelpk   = rrl_pk,
                 @sTopleveldesc = rrl_desc
          FROM   r5reliabilityrankinglevels
          WHERE  rrl_reliabilityranking = @sEqrrankingcode
          AND    rrl_org                = @sEqrrankingorg
          AND    rrl_revision           = @nEqrrankingrev
          AND    rrl_parent IS NULL
          IF @sToplevelpk IS NULL
            BEGIN
              SET @sChk        = N'3'
              SET @nScore      = NULL
              SET @sRrindex    = NULL
              GOTO END_OF_EQR
            END

          /* Cursor to retrieve all to be calculated questions. */
          DECLARE rrlc CURSOR LOCAL STATIC FOR
            SELECT rrl_pk, rrl_numeric, rrl_integer, rrl_code, que_code, que_text
            FROM   r5queries, r5reliabilityrankinglevels
            WHERE  que_code               = rrl_querycode
            AND    rrl_reliabilityranking = @sEqrrankingcode
            AND    rrl_org                = @sEqrrankingorg
            AND    rrl_revision           = @nEqrrankingrev
            AND    rrl_calculated         = N'+'

          OPEN rrlc
          FETCH NEXT FROM rrlc INTO @sRrlpk, @sRrlnumeric, @sRrlinteger, @sRrlcode, @sQuecode, @sQuetext
          WHILE @@FETCH_STATUS = 0
            BEGIN
              SET @sString = @sQuetext
              SET @sString = REPLACE( @sString, ''':OBJECTORG''', '''' + @sOrg + '''' )
              SET @sString = REPLACE( @sString, ':OBJECTORG', '''' + @sOrg + '''' )
              SET @sString = REPLACE( @sString, ''':OBJECT''', '''' + @sObj + '''' )
              SET @sString = REPLACE( @sString, ':OBJECT', '''' + @sObj + '''' )
              SET @sString = REPLACE( @sString, ''':RANKINGLEVEL''', '''' + @sRrlcode + '''' )
              SET @sString = REPLACE( @sString, ':RANKINGLEVEL', '''' + @sRrlcode + '''' )
              SET @sString = REPLACE( @sString, ':FROMPOINT', ISNULL( CAST( @nLrffrompoint AS NVARCHAR ), '' ) )
              SET @sString = REPLACE( @sString, ':TOPOINT', ISNULL( CAST( @nLrftopoint AS NVARCHAR ), '' ) )
              SET @sString = REPLACE( @sString, ''':objectorg''', '''' + @sOrg + '''' )
              SET @sString = REPLACE( @sString, ':objectorg', '''' + @sOrg + '''' )
              SET @sString = REPLACE( @sString, ''':object''', '''' + @sObj + '''' )
              SET @sString = REPLACE( @sString, ':object', '''' + @sObj + '''' )
              SET @sString = REPLACE( @sString, ''':rankinglevel''', '''' + @sRrlcode + '''' )
              SET @sString = REPLACE( @sString, ':rankinglevel', '''' + @sRrlcode + '''' )
              SET @sString = REPLACE( @sString, ':frompoint', ISNULL( CAST( @nLrffrompoint AS NVARCHAR ), '' ) )
              SET @sString = REPLACE( @sString, ':topoint', ISNULL( CAST( @nLrftopoint AS NVARCHAR ), '' ) )
              BEGIN TRY
                SET @sString = SUBSTRING( @sString, 1, 7 ) + N' @sQresult = ' + SUBSTRING( @sString, 8, 4000 )
                EXECUTE sp_executesql @sString, N'@sQresult NVARCHAR( 4000 ) OUTPUT', @sQresult OUTPUT
                IF @sRrlnumeric = N'-' AND @sRrlinteger = N'-'
                  BEGIN
                    /* Try to find the answer PK. */
                    SET @sAnswerpk    = NULL
                    SET @nAnswervalue = NULL
                    SELECT @sAnswerpk = rrw_pk, @nAnswervalue = rrw_value
                    FROM   r5reliabilityrankinganswer
                    WHERE  rrw_levelpk = @sRrlpk
                    AND    rrw_code    = @sQresult
                    IF @sAnswerpk IS NULL
                      BEGIN
                        SET @sChk        = N'12'
                        SET @sMessage    = @sQuecode + N' (' + @sEqrrankingcode + @sExtramessage + N') '
                        SET @nScore      = NULL
                        SET @sRrindex    = NULL
                        CLOSE rrlc
                        DEALLOCATE rrlc
                        GOTO END_OF_EQR
                      END
                  END

                INSERT INTO r5objectsurvey( obs_object, obs_object_org, obs_type, obs_levelpk )
                SELECT @sObj, @sOrg, @sStype, @sRrlpk
                FROM   dual
                WHERE  NOT EXISTS ( SELECT 'x'
                                    FROM   r5objectsurvey
                                    WHERE  obs_object     = @sObj
                                    AND    obs_object_org = @sOrg
                                    AND    obs_type       = @sStype
                                    AND    obs_levelpk    = @sRrlpk )
                UPDATE r5objectsurvey
                SET    obs_calculatedanswer   = CASE WHEN CHARINDEX( N'+', @sRrlnumeric + @sRrlinteger ) = 0 THEN @sAnswerpk ELSE NULL END,
                       obs_calculatedvalue    = CASE WHEN CHARINDEX( N'+', @sRrlnumeric + @sRrlinteger ) > 0 THEN CAST( @sQresult AS NUMERIC( 24, 6 ) ) ELSE @nAnswervalue END,
                       obs_datelastcalculated = dbo.o7gttime2( @sEqrrankingorg )
                WHERE  obs_levelpk    = @sRrlpk
                AND    obs_object     = @sObj
                AND    obs_object_org = @sOrg
                AND    obs_type       = @sStype
              END TRY
              BEGIN CATCH
                SET @sChk        = N'11'
                SET @sMessage    = @sQuecode + N' (' + @sEqrrankingcode + @sExtramessage + N') '
                SET @nScore      = NULL
                SET @sRrindex    = NULL
                CLOSE rrlc
                DEALLOCATE rrlc
                GOTO END_OF_EQR
              END CATCH
              FETCH NEXT FROM rrlc INTO @sRrlpk, @sRrlnumeric, @sRrlinteger, @sRrlcode, @sQuecode, @sQuetext
            END
          CLOSE rrlc
          DEALLOCATE rrlc

          /* Find the check list related records. */
          DECLARE rrlcl CURSOR LOCAL STATIC FOR
            SELECT rrl_pk, rrl_aspect, rrl_checklisttype, rrl_allowoperatorchecklist, rrl_integer,
                   CASE WHEN rrl_numeric = N'+' OR rrl_integer = N'+' THEN N'+' ELSE N'-' END,
                   dbo.r5o7_o7get_desc( @sLang, N'UCOD', rrl_checklisttype, 'CLTP', NULL )
            FROM   r5reliabilityrankinglevels
            WHERE  rrl_reliabilityranking = @sEqrrankingcode
            AND    rrl_org                = @sEqrrankingorg
            AND    rrl_revision           = @nEqrrankingrev
            AND    rrl_aspect        IS NOT NULL
            AND    rrl_checklisttype IS NOT NULL
          OPEN rrlcl
          FETCH NEXT FROM rrlcl INTO @sRrlpk, @sRrlaspect, @sRrlchecklisttype, @sRrlallowoperatorcl, @sRrlinteger, @sRrlnumeric, @sTypedesc
          WHILE @@FETCH_STATUS = 0
            BEGIN
              /* Find the latest checklist record. */
              SET @sAckcode       = NULL
              SET @sAckevent      = NULL
              SET @sAckoperatorcl = NULL
              SET @nAcknvalue     = NULL
              SET @sAckvalue      = NULL
              SET @sAckvalue2     = NULL
              DECLARE ack CURSOR LOCAL STATIC FOR
                SELECT ack_updated,
                       ack_code,
                       ack_event,
                       NULL,
                       ack_value,
                       CASE ack_type
                         WHEN N'02' THEN CASE ack_yes  WHEN N'+' THEN N'YES'  ELSE CASE ack_no                 WHEN N'+' THEN N'NO'   ELSE NULL END END
                         WHEN N'03' THEN ack_finding
                         WHEN N'06' THEN ack_finding
                         WHEN N'07' THEN CASE ack_ok   WHEN N'+' THEN N'OK'   ELSE CASE ack_repairsneeded      WHEN N'+' THEN N'RN'   ELSE NULL END END
                         WHEN N'08' THEN CASE ack_good WHEN N'+' THEN N'GOOD' ELSE CASE ack_poor               WHEN N'+' THEN N'POOR' ELSE NULL END END
                         WHEN N'09' THEN CASE ack_ok   WHEN N'+' THEN N'OK'   ELSE CASE ack_adjusted           WHEN N'+' THEN N'ADJ'  ELSE NULL END END
                         WHEN N'10' THEN CASE ack_ok   WHEN N'+' THEN N'OK'   ELSE CASE ack_adjusted           WHEN N'+' THEN N'ADJ'  ELSE NULL END END
                         WHEN N'11' THEN CASE ack_ok   WHEN N'+' THEN N'OK'   ELSE CASE ack_nonconformityfound WHEN N'+' THEN N'NCF'  ELSE NULL END END
                         WHEN N'12' THEN CASE ack_ok   WHEN N'+' THEN N'OK'   ELSE CASE ack_nonconformityfound WHEN N'+' THEN N'NCF'  ELSE NULL END END
                         ELSE NULL END,
                       CASE ack_type
                         WHEN N'07' THEN ack_resolution
                         WHEN N'11' THEN ack_severity
                         WHEN N'12' THEN ack_severity
                         ELSE NULL END
                FROM   r5install, r5events, r5actchecklists
                WHERE  evt_code       = ack_event
                AND    ack_object     = @sObj
                AND    ack_object_org = @sOrg
                AND    ack_aspect     = @sRrlaspect
                AND    ack_type       = @sRrlchecklisttype
                AND    (    @nLrffrompoint IS NULL
                         OR ack_frompoint IS NULL
                         OR ( ack_frompoint >= @nLrffrompoint AND ack_topoint <= @nLrftopoint ) )
                AND    ins_code       = N'CANCSTAT'
                AND    evt_rstatus    = N'C'
                AND    evt_status    <> ins_desc
                AND    ( ( @sRrlnumeric = N'+' AND ack_value IS NOT NULL ) OR ( @sRrlnumeric = N'-' AND ack_updated IS NOT NULL ) )
                UNION
                SELECT ack_updated, ack_code, NULL, ack_entitykey, ack_value,
                       CASE ack_type
                         WHEN N'02' THEN CASE ack_yes  WHEN N'+' THEN N'YES'  ELSE CASE ack_no                 WHEN N'+' THEN N'NO'   ELSE NULL END END
                         WHEN N'03' THEN ack_finding
                         WHEN N'06' THEN ack_finding
                         WHEN N'07' THEN CASE ack_ok   WHEN N'+' THEN N'OK'   ELSE CASE ack_repairsneeded      WHEN N'+' THEN N'RN'   ELSE NULL END END
                         WHEN N'08' THEN CASE ack_good WHEN N'+' THEN N'GOOD' ELSE CASE ack_poor               WHEN N'+' THEN N'POOR' ELSE NULL END END
                         WHEN N'09' THEN CASE ack_ok   WHEN N'+' THEN N'OK'   ELSE CASE ack_adjusted           WHEN N'+' THEN N'ADJ'  ELSE NULL END END
                         WHEN N'10' THEN CASE ack_ok   WHEN N'+' THEN N'OK'   ELSE CASE ack_adjusted           WHEN N'+' THEN N'ADJ'  ELSE NULL END END
                         WHEN N'11' THEN CASE ack_ok   WHEN N'+' THEN N'OK'   ELSE CASE ack_nonconformityfound WHEN N'+' THEN N'NCF'  ELSE NULL END END
                         WHEN N'12' THEN CASE ack_ok   WHEN N'+' THEN N'OK'   ELSE CASE ack_nonconformityfound WHEN N'+' THEN N'NCF'  ELSE NULL END END
                         ELSE NULL END,
                       CASE ack_type
                         WHEN N'07' THEN ack_resolution
                         WHEN N'11' THEN ack_severity
                         WHEN N'12' THEN ack_severity
                         ELSE NULL END
                FROM   r5operatorchecklists, r5actchecklists
                WHERE  ock_code       = ack_entitykey
                AND    ock_org        = ack_entityorg
                AND    'OPCK'         = ack_rentity
                AND    ack_object     = @sObj
                AND    ack_object_org = @sOrg
                AND    ack_aspect     = @sRrlaspect
                AND    ack_type       = @sRrlchecklisttype
                AND    (    @nLrffrompoint IS NULL
                         OR ack_frompoint IS NULL
                         OR ( ack_frompoint >= @nLrffrompoint AND ack_topoint <= @nLrftopoint ) )
                AND    ock_rstatus    = N'C'
                AND    @sRrlallowoperatorcl = N'+'
                AND    ( ( @sRrlnumeric = N'+' AND ack_value IS NOT NULL ) OR ( @sRrlnumeric = N'-' AND ack_updated IS NOT NULL ) )
                ORDER BY 1 DESC
              OPEN ack
              FETCH NEXT FROM ack INTO @dAckupdated, @sAckcode, @sAckevent, @sAckoperatorcl, @nAcknvalue, @sAckvalue, @sAckvalue2
              CLOSE ack
              DEALLOCATE ack
              IF @sAckcode IS NULL
                BEGIN
                  /* No Checklist item found. */
                  SET @sChk        = N'15'
                  SET @sMessage    = @sRrlaspect + N'/' + @sTypedesc + N' (' + @sEqrrankingcode + @sExtramessage + N') '
                  SET @nScore      = NULL
                  SET @sRrindex    = NULL
                  CLOSE rrlcl
                  DEALLOCATE rrlcl
                  GOTO END_OF_EQR
                END
              ELSE
                BEGIN
                  IF @sRrlnumeric = '-'
                    BEGIN
                      /* Find answer. */
                      SET @sAnswerpk    = NULL
                      SET @nAnswervalue = NULL
                      SELECT @sAnswerpk    = rrw_pk,
                             @nAnswervalue = rrw_value
                      FROM   r5reliabilityrankinganswer
                      WHERE  rrw_levelpk = @sRrlpk
                      AND    (    (     @sRrlchecklisttype = N'02'
                                    AND (    ( rrw_yes = N'+' AND @sAckvalue  = N'YES' )
                                          OR ( rrw_no  = N'+' AND @sAckvalue  = N'NO' )
                                          OR ( rrw_yes = N'-' AND rrw_no      = N'-' AND @sAckvalue IS NULL ) ) )
                               OR (     @sRrlchecklisttype IN ( N'03', N'06' )
                                    AND ISNULL( rrw_finding, N'x' ) = ISNULL( @sAckvalue, N'x' ) )
                               OR (     @sRrlchecklisttype = N'07'
                                    AND (    ( rrw_ok            = N'+' AND @sAckvalue        = N'OK' AND ISNULL( rrw_resolution, N'x' ) = ISNULL( @sAckvalue2, N'x' ) )
                                          OR ( rrw_repairsneeded = N'+' AND @sAckvalue        = N'RN' AND ISNULL( rrw_resolution, N'x' ) = ISNULL( @sAckvalue2, N'x' ) )
                                          OR ( rrw_ok            = N'-' AND rrw_repairsneeded = N'-'  AND @sAckvalue IS NULL ) ) )
                               OR (     @sRrlchecklisttype = N'08'
                                    AND (    ( rrw_good = N'+' AND @sAckvalue = N'GOOD' )
                                          OR ( rrw_poor = N'+' AND @sAckvalue = N'POOR' )
                                          OR ( rrw_good = N'-' AND rrw_poor   = N'-' AND @sAckvalue IS NULL ) ) )
                               OR (     @sRrlchecklisttype IN ( N'09', N'10' )
                                    AND (    ( rrw_ok       = N'+' AND @sAckvalue   = N'OK' )
                                          OR ( rrw_adjusted = N'+' AND @sAckvalue   = N'ADJ')
                                          OR ( rrw_ok       = N'-' AND rrw_adjusted = N'-' AND @sAckvalue IS NULL ) ) )
                               OR (     @sRrlchecklisttype IN ( N'11', N'12' )
                                    AND (    ( rrw_ok            = N'+' AND @sAckvalue        = N'OK' )
                                          OR ( rrw_nonconformity = N'+' AND @sAckvalue        = N'NCF' AND ISNULL( rrw_severity, N'x' ) = ISNULL( @sAckvalue2, N'x' ) )
                                          OR ( rrw_ok            = N'-' AND rrw_nonconformity = N'-'   AND @sAckvalue IS NULL ) ) ) )

                      IF @sAnswerpk IS NULL
                        BEGIN
                          /* No answer found. */
                          SET @sChk        = N'15'
                          SET @sMessage    = @sRrlaspect + N'/' + @sTypedesc + N' (' + @sEqrrankingcode + @sExtramessage + N') '
                          SET @nScore      = NULL
                          SET @sRrindex    = NULL
                          CLOSE rrlcl
                          DEALLOCATE rrlcl
                          GOTO END_OF_EQR
                        END
                    END
                  ELSE
                    BEGIN
                      IF @sRrlinteger = N'+' AND @nAcknvalue <> ROUND( @nAcknvalue, 0 )
                        BEGIN
                          /* The value is not an integer. */
                          SET @sChk        = N'17'
                          SET @sMessage    = @sRrlaspect + N'/' + @sTypedesc + N' (' + @sEqrrankingcode + @sExtramessage + N') '
                          SET @nScore      = NULL
                          SET @sRrindex    = NULL
                          CLOSE rrlcl
                          DEALLOCATE rrlcl
                          GOTO END_OF_EQR
                        END
                    END
                  INSERT INTO r5objectsurvey( obs_object, obs_object_org, obs_type, obs_levelpk )
                  SELECT @sObj, @sOrg, @sStype, @sRrlpk
                  FROM   dual
                  WHERE  NOT EXISTS ( SELECT 1
                                      FROM   r5objectsurvey
                                      WHERE  obs_object     = @sObj
                                      AND    obs_object_org = @sOrg
                                      AND    obs_type       = @sStype
                                      AND    obs_levelpk    = @sRrlpk )
                  UPDATE r5objectsurvey
                  SET    obs_calculatedanswer   = CASE WHEN @sRrlnumeric = N'-' THEN @sAnswerpk ELSE NULL END,
                         obs_calculatedvalue    = CASE WHEN @sRrlnumeric = N'+' THEN @nAcknvalue ELSE @nAnswervalue END,
                         obs_datelastcalculated = dbo.o7gttime2( @sEqrrankingorg ),
                         obs_workorder          = @sAckevent,
                         obs_operatorchecklist  = @sAckoperatorcl
                  WHERE  obs_levelpk    = @sRrlpk
                  AND    obs_object     = @sObj
                  AND    obs_object_org = @sOrg
                  AND    obs_type       = @sStype
                END
              FETCH NEXT FROM rrlcl INTO @sRrlpk, @sRrlaspect, @sRrlchecklisttype, @sRrlallowoperatorcl, @sRrlinteger, @sRrlnumeric, @sTypedesc
            END
          CLOSE rrlcl
          DEALLOCATE rrlcl

          /* Move all answers to the temporary table. */
          DELETE FROM #calculatescore
          INSERT INTO #calculatescore
          SELECT rrl_pk, rrl_parent, rrl_code, COALESCE( obs_value, obs_calculatedvalue, rrw_value )
          FROM   r5reliabilityrankinglevels, r5objectsurvey
                 LEFT OUTER JOIN r5reliabilityrankinganswer ON obs_answerpk = rrw_pk
          WHERE  obs_levelpk            = rrl_pk
          AND    obs_object             = @sObj
          AND    obs_object_org         = @sOrg
          AND    rrl_reliabilityranking = @sEqrrankingcode
          AND    rrl_org                = @sEqrrankingorg
          AND    rrl_revision           = @nEqrrankingrev

          WHILE @sCompleted = N'-'
            BEGIN
              SET @nLoops = @nLoops + 1
              /* This cursor retrieves all question level that have no numeric value yet, but
                 have no children without a numeric value, so by using the formula it should
                 be possible to calculate the value. This step will be repeated until the
                 highest level in the tree is reached. */
              DECLARE c_rrl CURSOR LOCAL STATIC FOR
                SELECT rrl_pk, rrl_formula, rrl_parent, rrl_code, rrl_desc, '-', NULL, NULL, NULL,
                       NULL, NULL, NULL
                FROM   r5reliabilityrankinglevels l1
                WHERE  rrl_reliabilityranking = @sEqrrankingcode
                AND    rrl_org                = @sEqrrankingorg
                AND    rrl_revision           = @nEqrrankingrev
                AND    rrl_questionlevel      = '-'
                AND NOT EXISTS( SELECT 'x'
                                FROM   #calculatescore
                                WHERE  csc_levelpk = rrl_pk )
                AND NOT EXISTS( SELECT 'x'
                                FROM   r5reliabilityrankinglevels l2
                                WHERE  l2.rrl_parent = l1.rrl_pk
                                AND NOT EXISTS( SELECT 'x'
                                                FROM   #calculatescore
                                                WHERE  csc_levelpk = l2.rrl_pk ) )
                UNION
                SELECT rrl_pk, rrl_formula, rrl_parent, rrl_code, rrl_desc, '+', csc_value, rrl_calculated, rrl_querycode,
                       rrl_aspect, rrl_checklisttype, rrl_allowoperatorchecklist
                FROM   #calculatescore, r5reliabilityrankinglevels l1
                WHERE  rrl_pk                 = csc_levelpk
                AND    rrl_reliabilityranking = @sEqrrankingcode
                AND    rrl_org                = @sEqrrankingorg
                AND    rrl_revision           = @nEqrrankingrev
                AND    rrl_questionlevel      = '+'
                AND    rrl_parent IS NULL
              OPEN c_rrl
              FETCH NEXT FROM c_rrl INTO @sLevelpk, @sFormula, @sParent, @sCode, @sDesc, @sToplevelonly, @nCscvalue, @sRrlcalculated, @sRrlquerycode,
                                       @sRrlaspect, @sRrlchecklisttype, @sRrlallowoperatorcl
              WHILE @@FETCH_STATUS = 0
                BEGIN
                  SET @nResult = NULL
                  IF @sFormula IS NULL
                    BEGIN
                      IF @sToplevelonly = '-'
                        BEGIN
                          /* If there is no formula, stop! */
                          SET @sChk = N'5'
                          SET @sErrorfound = N'+'
                        END
                      ELSE
                        /* Top level is a question, set the result to the value of that one question. */
                        SET @nResult = @nCscvalue
                    END
                  ELSE
                    BEGIN
                      /* Check whether formula is valid, if not set chk to '6' and abort. */
                      EXECUTE @nReturn = o7replacelevel '', '', '', 'CHECK', @sFormula, @sMessage2 OUTPUT, @sChk2 OUTPUT
                      IF @sChk2 <> N'0'
                        BEGIN
                          SET @sChk = N'6'
                          SET @sErrorfound = N'+'
                        END
                      ELSE
                        BEGIN
                          /* Uppercase the levels. */
                          SET @sString = ''
                          SET @sInlevel = N'-'
                          SET @nJ = 1
                          WHILE @nJ <= LEN( @sFormula )
                            BEGIN
                              SET @sCharacter = SUBSTRING( @sFormula, @nJ, 1 )
                              IF @sInlevel = N'-'
                                BEGIN
                                  SET @sString = @sString + @sCharacter
                                  IF @sCharacter = N':'
                                    SET @sInlevel = N'+'
                                  END
                              ELSE
                                BEGIN
                                  SET @sString = @sString + UPPER( @sCharacter )
                                  IF @sCharacter IN ( N' ', N',', N'*', N')', N'(', N'-', N'/', N'+' )
                                    SET @sInlevel = N'-'
                                END
                              SET @nJ = @nJ + 1
                            END
                          SET @sFormula = @sString

                          /* Cursor to find child levels, to construct correct formula. */
                          DECLARE c_csc CURSOR LOCAL STATIC FOR
                            SELECT csc_code, csc_value
                            FROM   #calculatescore
                            WHERE  csc_parent = @sLevelpk
                            ORDER BY LEN( csc_code ) DESC
                          OPEN c_csc
                          FETCH NEXT FROM c_csc INTO @sCsccode, @nCscvalue
                          WHILE @@FETCH_STATUS = 0
                            BEGIN
                              /* Replace the level codes with an actual numeric value. */
                              SET @sFormula = REPLACE( @sFormula, ':' + @sCsccode, ISNULL( CAST( @nCscvalue AS NVARCHAR ), 'NULL' ) )
                              FETCH NEXT FROM c_csc INTO @sCsccode, @nCscvalue
                            END
                          CLOSE c_csc
                          DEALLOCATE c_csc
                          SET @sFormula = N'SELECT @nOutput = ' + @sFormula + N' FROM DUAL'
                          BEGIN TRY
                            EXEC sp_executeSql @sFormula, N'@nOutput NUMERIC( 24, 6 ) OUTPUT', @nResult OUTPUT
                          END TRY
                          BEGIN CATCH
                            /* Unexpected error in formula, set chk to '6' and abort. */
                            SET @sChk = N'6'
                            SET @sErrorfound = N'+'
                          END CATCH
                        END
                    END

                  IF @sErrorfound = N'-'
                    BEGIN
                      /* Check normalization. */
                      SELECT @nCnt = COUNT(*)
                      FROM   r5reliabilityrankingnorms
                      WHERE  rrn_levelpk = @sLevelpk
                      IF @nCnt > 0
                        BEGIN
                          /* If necessary, do the normalization */
                          SET @nNorm = NULL
                          SELECT @nNorm = rrn_value
                          FROM   r5reliabilityrankingnorms
                          WHERE  rrn_levelpk = @sLevelpk
                          AND    @nResult BETWEEN  rrn_minvalue AND rrn_maxvalue
                          IF @nNorm IS NOT NULL
                              SET @nResult = @nNorm
                          ELSE
                            BEGIN
                              /* Something wrong with normalization, set chk to '7' and abort. */
                              SET @nScore = @nResult
                              SET @sChk = N'7'
                              SET @sErrorfound = N'+'
                            END
                        END
                    END

                  IF @sErrorfound = N'+'
                    BEGIN
                      IF @sParent IS NULL
                        /* Top level is missing the formula. */
                        SET @sMessage = @sTopleveldesc
                      ELSE
                        BEGIN
                          IF @sParent = @sToplevelpk
                            /* Level just below top is missing the formula. */
                            SET @sMessage = @sTopleveldesc + N'/' + @sDesc
                          ELSE
                            BEGIN
                              /* Another level is missing the formula. */
                              SELECT @sLeveldesc = rrl_desc
                              FROM   r5reliabilityrankinglevels
                              WHERE  rrl_pk = @sParent
                              SET @sMessage = @sTopleveldesc + N'/' + @sLeveldesc + N'/' + @sDesc
                            END
                        END
                      IF @sChk <> N'7'
                        SET @nScore = NULL
                      SET @sRrindex = NULL
                      CLOSE c_rrl
                      DEALLOCATE c_rrl
                      GOTO END_OF_EQR
                    END

                  IF @sToplevelonly = N'-'
                    BEGIN
                      /* Store temporary result */
                      BEGIN TRY
                        INSERT INTO #calculatescore( csc_levelpk, csc_parent, csc_code, csc_value )
                        VALUES( @sLevelpk, @sParent, @sCode, @nResult )
                      END TRY
                      BEGIN CATCH
                        /* Overflow. */
                        SET @sChk        = N'8'
                        SET @nScore      = NULL
                        SET @sRrindex    = NULL
                        CLOSE c_rrl
                        DEALLOCATE c_rrl
                        GOTO END_OF_EQR
                      END CATCH
                    END

                  IF @sParent IS NULL
                    BEGIN
                      SET @nScore     = @nResult
                      SET @sCompleted = N'+'
                    END

                  FETCH NEXT FROM c_rrl INTO @sLevelpk, @sFormula, @sParent, @sCode, @sDesc, @sToplevelonly, @nCscvalue, @sRrlcalculated, @sRrlquerycode,
                                             @sRrlaspect, @sRrlchecklisttype, @sRrlallowoperatorcl
                END
              CLOSE c_rrl
              DEALLOCATE c_rrl

              IF @nLoops > 100
                BEGIN
                  /* Never ending loop detected, return. */
                  GOTO END_OF_EQR
                END

            END
        END

      /* Round the score. */
      IF @nRrkprecision IS NOT NULL
        SET @nScore = ROUND( @nScore, @nRrkprecision )

      /* Do actual updates ... */
      IF @sRrkrtype <> N'FCI'
        BEGIN
          /* Find reliability ranking index, if not found set chk to '9'. */
          SELECT @sRrindex = ISNULL( rrr_rrindex, rrr_criticality )
          FROM   r5reliabilityrankingranks
          WHERE  rrr_reliabilityranking = @sEqrrankingcode
          AND    rrr_org                = @sEqrrankingorg
          AND    rrr_revision           = @nEqrrankingrev
          AND    @nScore BETWEEN rrr_minvalue AND rrr_maxvalue
          IF @sRrindex IS NULL
            BEGIN
              SET @sChk        = N'9'
              SET @nErrorscore = @nScore
              SET @sMessage    = ISNULL( @sTopleveldesc, @sRrkdesc )
              SET @sRrindex    = NULL
              GOTO END_OF_EQR
            END
        END
      /* Update the objects table with the found values. */
      IF @sStype = N'O'
        BEGIN
          UPDATE r5equipmentrankings
          SET    eqr_rankingscore         = @nScore,
                 eqr_rankingindex         = @sRrindex,
                 eqr_valueslastcalculated = dbo.o7gttime2( eqr_rankingorg ),
                 eqr_calculationerror     = N'-'
          WHERE  eqr_objcode          = @sObj
          AND    eqr_objorg           = @sOrg
          AND    eqr_rankingcode      = @sEqrrankingcode
          AND    eqr_rankingorg       = @sEqrrankingorg
          AND    eqr_rankingrevision  = @nEqrrankingrev
          IF @sEqrdefault = N'+' OR @sRrkrtype IN ( N'CI', N'FCI', N'CRI', N'RPI' )
            BEGIN
              IF @nLrfid IS NULL
                /* Update the equipment. */
                UPDATE r5objects
                SET    obj_reliabilityrankingscore = CASE @sEqrdefault WHEN N'+'   THEN @nScore     ELSE obj_reliabilityrankingscore END,
                       obj_reliabilityrankingindex = CASE @sEqrdefault WHEN N'+'   THEN @sRrindex   ELSE obj_reliabilityrankingindex END,
                       obj_rrvalueslastcalculated  = CASE @sEqrdefault WHEN N'+'   THEN dbo.o7gttime2( @sEqrrankingorg ) ELSE obj_rrvalueslastcalculated END,
                       obj_conditionscore          = CASE @sRrkrtype   WHEN N'CI'  THEN @nScore     ELSE obj_conditionscore END,
                       obj_conditionindex          = CASE @sRrkrtype   WHEN N'CI'  THEN @sRrindex   ELSE obj_conditionindex END,
                       obj_facilityconditionindex  = CASE @sRrkrtype   WHEN N'FCI' THEN @nScore     ELSE obj_facilityconditionindex END,
                       obj_criticalityscore        = CASE @sRrkrtype   WHEN N'CRI' THEN @nScore     ELSE obj_criticalityscore END,
                       obj_criticality             = CASE @sRrkrtype   WHEN N'CRI' THEN @sRrindex   ELSE obj_criticality END,
                       obj_riskpriorityindex       = CASE @sRrkrtype   WHEN N'RPI' THEN @sRrindex   ELSE obj_riskpriorityindex END,
                       obj_endusefullife           = CASE @sRrkrtype   WHEN N'CI'  THEN @dEndoflife ELSE obj_endusefullife END,
                       obj_rpn                     = CASE WHEN obj_rcmlevel IS NULL AND @sRrkrtype = N'RPI' THEN @nScore ELSE obj_rpn END
                WHERE  obj_code = @sObj
                AND    obj_org  = @sOrg
              ELSE
                BEGIN
                  IF @sRrktrackhistory = N'+' AND @dLrfdateeffective < dbo.F_TRUNC_DATE( GETDATE(), N'DD' )
                    BEGIN
                      /* Create history record (copy of current r5objlinearref record ), first expire the current record. */
                      UPDATE r5objlinearref
                      SET    lrf_dateexpired = dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) - 1
                      WHERE  lrf_id = @nLrfid
                      AND    lrf_dateexpired > dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) - 1
                      IF @@ROWCOUNT > 0
                        /* Then create a new active record. */
                        INSERT INTO r5objlinearref( lrf_objcode, lrf_objorg, lrf_refrtype, lrf_reftype, lrf_refdesc, lrf_re_objcode, lrf_re_objorg, lrf_frompoint, lrf_topoint,
                               lrf_georef, lrf_created, lrf_updated, lrf_class, lrf_class_org, lrf_part, lrf_part_org, lrf_condition, lrf_dateeffective, lrf_dateexpired,
                               lrf_inspectiondirection, lrf_flow, lrf_applytochildren, lrf_repeateverylength, lrf_repeateveryuom, lrf_startingsequence, lrf_setid, lrf_displayonoverview,
                               lrf_color, lrf_icon, lrf_iconpath, lrf_relationshiptype, lrf_horizontaloffset, lrf_horizontaloffsetuom, lrf_horizontaloffsettype, lrf_verticaloffset,
                               lrf_verticaloffsetuom, lrf_verticaloffsettype, lrf_qtyperuom, lrf_qtyuom, lrf_width, lrf_widthuom, lrf_height, lrf_heightuom, lrf_createdby, lrf_updatedby,
                               lrf_udfchar01, lrf_udfchar02, lrf_udfchar03, lrf_udfchar04, lrf_udfchar05, lrf_udfchar06, lrf_udfchar07, lrf_udfchar08, lrf_udfchar09, lrf_udfchar10,
                               lrf_udfchar11, lrf_udfchar12, lrf_udfchar13, lrf_udfchar14, lrf_udfchar15, lrf_udfchar16, lrf_udfchar17, lrf_udfchar18, lrf_udfchar19, lrf_udfchar20,
                               lrf_udfchar21, lrf_udfchar22, lrf_udfchar23, lrf_udfchar24, lrf_udfchar25, lrf_udfchar26, lrf_udfchar27, lrf_udfchar28, lrf_udfchar29, lrf_udfchar30,
                               lrf_udfdate01, lrf_udfdate02, lrf_udfdate03, lrf_udfdate04, lrf_udfdate05, lrf_udfnum01, lrf_udfnum02, lrf_udfnum03, lrf_udfnum04, lrf_udfnum05,
                               lrf_udfchkbox01, lrf_udfchkbox02, lrf_udfchkbox03, lrf_udfchkbox04, lrf_udfchkbox05, lrf_sequence, lrf_from_reference, lrf_from_offset, lrf_from_offset_percentage,
                               lrf_from_offset_direction, lrf_from_xcoordinate, lrf_from_ycoordinate, lrf_from_latitude, lrf_from_longitude, lrf_to_reference, lrf_to_offset,
                               lrf_to_offset_direction, lrf_to_offset_percentage, lrf_to_xcoordinate, lrf_to_ycoordinate, lrf_to_latitude, lrf_to_longitude, lrf_branch_point, lrf_identifier,
                               lrf_branch_direction, lrf_linear_reftype, lrf_pointreference, lrf_overviewsequence, lrf_applytorouterow, lrf_conditionscore, lrf_conditionindex,
                               lrf_riskprioritynumber, lrf_riskpriorityindex, lrf_criticalityscore, lrf_criticality, lrf_commissiondate, lrf_servicelife, lrf_servicelifeusage, lrf_endusefullife,
                               lrf_corrconditionscore, lrf_corrconditionreason, lrf_corrconditiondate, lrf_corrconditionusage, lrf_parentid )
                        SELECT lrf_objcode, lrf_objorg, lrf_refrtype, lrf_reftype, lrf_refdesc, lrf_re_objcode, lrf_re_objorg, lrf_frompoint, lrf_topoint,
                               lrf_georef, GETDATE(), NULL, lrf_class, lrf_class_org, lrf_part, lrf_part_org, lrf_condition, dbo.F_TRUNC_DATE( GETDATE(), N'DD' ),
                               dbo.F_GREATEST_DATE( @dLrfdateexpired, dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) ),
                               lrf_inspectiondirection, lrf_flow, lrf_applytochildren, lrf_repeateverylength, lrf_repeateveryuom, lrf_startingsequence, lrf_setid, lrf_displayonoverview,
                               lrf_color, lrf_icon, lrf_iconpath, lrf_relationshiptype, lrf_horizontaloffset, lrf_horizontaloffsetuom, lrf_horizontaloffsettype, lrf_verticaloffset,
                               lrf_verticaloffsetuom, lrf_verticaloffsettype, lrf_qtyperuom, lrf_qtyuom, lrf_width, lrf_widthuom, lrf_height, lrf_heightuom, lrf_createdby, lrf_updatedby,
                               lrf_udfchar01, lrf_udfchar02, lrf_udfchar03, lrf_udfchar04, lrf_udfchar05, lrf_udfchar06, lrf_udfchar07, lrf_udfchar08, lrf_udfchar09, lrf_udfchar10,
                               lrf_udfchar11, lrf_udfchar12, lrf_udfchar13, lrf_udfchar14, lrf_udfchar15, lrf_udfchar16, lrf_udfchar17, lrf_udfchar18, lrf_udfchar19, lrf_udfchar20,
                               lrf_udfchar21, lrf_udfchar22, lrf_udfchar23, lrf_udfchar24, lrf_udfchar25, lrf_udfchar26, lrf_udfchar27, lrf_udfchar28, lrf_udfchar29, lrf_udfchar30,
                               lrf_udfdate01, lrf_udfdate02, lrf_udfdate03, lrf_udfdate04, lrf_udfdate05, lrf_udfnum01, lrf_udfnum02, lrf_udfnum03, lrf_udfnum04, lrf_udfnum05,
                               lrf_udfchkbox01, lrf_udfchkbox02, lrf_udfchkbox03, lrf_udfchkbox04, lrf_udfchkbox05, lrf_sequence, lrf_from_reference, lrf_from_offset, lrf_from_offset_percentage,
                               lrf_from_offset_direction, lrf_from_xcoordinate, lrf_from_ycoordinate, lrf_from_latitude, lrf_from_longitude, lrf_to_reference, lrf_to_offset,
                               lrf_to_offset_direction, lrf_to_offset_percentage, lrf_to_xcoordinate, lrf_to_ycoordinate, lrf_to_latitude, lrf_to_longitude, lrf_branch_point, lrf_identifier,
                               lrf_branch_direction, lrf_linear_reftype, lrf_pointreference, lrf_overviewsequence, lrf_applytorouterow,
                               CASE @sRrkrtype WHEN N'CI'  THEN @nScore   ELSE lrf_conditionscore END,
                               CASE @sRrkrtype WHEN N'CI'  THEN @sRrindex ELSE lrf_conditionindex END,
                               CASE @sRrkrtype WHEN N'RPI' THEN @nScore   ELSE lrf_riskprioritynumber END,
                               CASE @sRrkrtype WHEN N'RPI' THEN @sRrindex ELSE lrf_riskpriorityindex END,
                               CASE @sRrkrtype WHEN N'CRI' THEN @nScore   ELSE lrf_criticalityscore END,
                               CASE @sRrkrtype WHEN N'CRI' THEN @sRrindex ELSE lrf_criticality END,
                               lrf_commissiondate, lrf_servicelife, lrf_servicelifeusage, CASE @sRrkrtype WHEN N'CI'  THEN @dEndoflife ELSE lrf_endusefullife END,
                               lrf_corrconditionscore, lrf_corrconditionreason, lrf_corrconditiondate, lrf_corrconditionusage, lrf_id
                        FROM   r5objlinearref
                        WHERE  lrf_id = @nLrfid
                      ELSE
                        /* A new record has been created, use the parentid.*/
                        UPDATE r5objlinearref
                        SET    lrf_conditionscore     = CASE @sRrkrtype WHEN N'CI'  THEN @nScore     ELSE lrf_conditionscore END,
                               lrf_conditionindex     = CASE @sRrkrtype WHEN N'CI'  THEN @sRrindex   ELSE lrf_conditionindex END,
                               lrf_endusefullife      = CASE @sRrkrtype WHEN N'CI'  THEN @dEndoflife ELSE lrf_endusefullife END,
                               lrf_riskprioritynumber = CASE @sRrkrtype WHEN N'RPI' THEN @nScore     ELSE lrf_riskprioritynumber END,
                               lrf_riskpriorityindex  = CASE @sRrkrtype WHEN N'RPI' THEN @sRrindex   ELSE lrf_riskpriorityindex END,
                               lrf_criticalityscore   = CASE @sRrkrtype WHEN N'CRI' THEN @nScore     ELSE lrf_criticalityscore END,
                               lrf_criticality        = CASE @sRrkrtype WHEN N'CRI' THEN @sRrindex   ELSE lrf_criticality END
                        WHERE  lrf_parentid = @nLrfid
                    END
                  ELSE
                    /* Update the linear reference record. */
                    UPDATE r5objlinearref
                    SET    lrf_conditionscore     = CASE @sRrkrtype WHEN N'CI'  THEN @nScore     ELSE lrf_conditionscore END,
                           lrf_conditionindex     = CASE @sRrkrtype WHEN N'CI'  THEN @sRrindex   ELSE lrf_conditionindex END,
                           lrf_endusefullife      = CASE @sRrkrtype WHEN N'CI'  THEN @dEndoflife ELSE lrf_endusefullife END,
                           lrf_riskprioritynumber = CASE @sRrkrtype WHEN N'RPI' THEN @nScore     ELSE lrf_riskprioritynumber END,
                           lrf_riskpriorityindex  = CASE @sRrkrtype WHEN N'RPI' THEN @sRrindex   ELSE lrf_riskpriorityindex END,
                           lrf_criticalityscore   = CASE @sRrkrtype WHEN N'CRI' THEN @nScore     ELSE lrf_criticalityscore END,
                           lrf_criticality        = CASE @sRrkrtype WHEN N'CRI' THEN @sRrindex   ELSE lrf_criticality END
                    WHERE  lrf_id = @nLrfid

                  /* Insert into temp table, for later processing. */
                  INSERT INTO #r5calcobjrrscore( gtc_rankingcode, gtc_rankingorg, gtc_rankingrevision, gtc_precision, gtc_rtype, gtc_trackhistory, gtc_score, gtc_length )
                  VALUES( @sEqrrankingcode, @sEqrrankingorg, @nEqrrankingrev, @nRrkprecision, @sRrkrtype, @sRrktrackhistory, @nScore, @nLrflength )
                END
            END

          IF @sRrktrackhistory = N'+' AND @nLrfid IS NULL
            BEGIN
              /* Create a history record, first delete it, if a record already exists for today. */
              DELETE FROM r5equipmentrankinghistory
              WHERE  erh_rankingtype     = @sRrktype
              AND    erh_objcode         = @sObj
              AND    erh_objorg          = @sOrg
              AND    erh_date            = dbo.F_TRUNC_DATE( GETDATE(), N'DD' )
              INSERT INTO r5equipmentrankinghistory( erh_rankingcode, erh_rankingorg, erh_rankingrevision, erh_rankingtype, erh_objcode, erh_objorg, erh_date,  erh_score, erh_index,
                     erh_endofusefullife, erh_conditionprotocol, erh_condscorestart, erh_condscoreend, erh_condscorethreshold, erh_decaycurve, erh_decaycurve_org, erh_corrconditionscore,
                     erh_corrconditionreason, erh_corrconditiondate, erh_corrconditionusage, erh_primaryuom, erh_servicelife, erh_dailyusageuom, erh_usage, erh_servicelifeusage, erh_risklevel )
              SELECT @sEqrrankingcode, @sEqrrankingorg, @nEqrrankingrev, @sRrktype, obj_code, obj_org, dbo.F_TRUNC_DATE( GETDATE(), N'DD' ), @nScore, @sRrindex,
                     CASE @sRrkrtype WHEN N'CI'  THEN @dEndoflife              ELSE NULL END,
                     CASE @sRrkrtype WHEN N'CI'  THEN @sRrkconditionprotocol   ELSE NULL END,
                     CASE @sRrkrtype WHEN N'CI'  THEN @nRrkcondscorestart      ELSE NULL END,
                     CASE @sRrkrtype WHEN N'CI'  THEN @nRrkcondscoreend        ELSE NULL END,
                     CASE @sRrkrtype WHEN N'CI'  THEN @nRrkcondscorethreshold  ELSE NULL END,
                     CASE @sRrkrtype WHEN N'CI'  THEN @sRrkdecaycurve          ELSE NULL END,
                     CASE @sRrkrtype WHEN N'CI'  THEN @sRrkdecaycurveorg       ELSE NULL END,
                     CASE @sRrkrtype WHEN N'CI'  THEN obj_corrconditionscore   ELSE NULL END,
                     CASE @sRrkrtype WHEN N'CI'  THEN obj_corrconditionreason  ELSE NULL END,
                     CASE @sRrkrtype WHEN N'CI'  THEN obj_corrconditiondate    ELSE NULL END,
                     CASE @sRrkrtype WHEN N'CI'  THEN obj_corrconditionusage   ELSE NULL END,
                     obj_primaryuom,
                     CASE @sRrkrtype WHEN N'CI'  THEN @nServicelife            ELSE NULL END,
                     obj_primaryuom,
                     @nOudtotalusage,
                     CASE @sRrkrtype WHEN N'CI'  THEN @nServicelifeusage       ELSE NULL END,
                     CASE @sRrkrtype WHEN N'RPI' THEN obj_risklevel            ELSE NULL END
              FROM   r5objects
              WHERE  obj_code = @sObj
              AND    obj_org  = @sOrg
            END
        END
      ELSE IF @sStype = N'J'
        UPDATE r5objectives
        SET    ojv_rankingscore         = @nScore,
               ojv_rankingindex         = @sRrindex,
               ojv_valueslastcalculated = dbo.o7gttime2( ojv_org ),
               ojv_calculationerror     = N'-'
        WHERE  ojv_code = @sObj
        AND    ojv_org  = @sOrg
      ELSE IF @sStype = N'P'
        UPDATE r5policies
        SET    pol_rankingscore         = @nScore,
               pol_rankingindex         = @sRrindex,
               pol_valueslastcalculated = dbo.o7gttime2( pol_org ),
               pol_calculationerror     = N'-'
        WHERE  pol_code = @sObj
        AND    pol_org  = @sOrg
      ELSE IF @sStype = N'T'
        UPDATE r5strategies
        SET    stg_rankingscore         = @nScore,
               stg_rankingindex         = @sRrindex,
               stg_valueslastcalculated = dbo.o7gttime2( stg_org ),
               stg_calculationerror     = N'-'
        WHERE  stg_code = @sObj
        AND    stg_org  = @sOrg
      ELSE
        UPDATE r5reliabilityrankingvalues
        SET    rrv_reliabilityrankingscore = @nScore,
               rrv_reliabilityrankingindex = @sRrindex,
               rrv_valueslastcalculated    = dbo.o7gttime2( @sOrg )
        WHERE  rrv_pk = @sObj

      SET @nRecsdone = @nRecsdone + 1

      END_OF_EQR:

      FETCH NEXT FROM eqr INTO @nRefreshsequence, @sEqrrankingcode, @sEqrrankingorg, @nEqrrankingrev, @sRrkdesc, @sRrktype, @sRrkrtype, @sRrkconditionprotocol,
                               @nRrkcondscorestart, @nRrkcondscoreend, @nRrkcondscorethreshold, @sRrkdecaycurve, @sRrkdecaycurveorg, @sRrktrackhistory, @nRrkprecision, @sDcrmetuom,
                               @sEqrdefault, @sEqrlocked, @nObjservicelife, @nObjservicelifeusage, @sObjcategory, @sObjclass, @sObjclassorg, @sObjprimaryuom,
                               @nObjcorrconditionscore, @dObjcorrconditiondate, @nObjcorrconditionusage, @dObjcommiss, @nObjfrompoint,
                               @nLrfid, @nLrflength, @dLrfdateeffective, @dLrfdateexpired, @nLrffrompoint, @nLrftopoint, @dRefdate, @nStartscore, @nOudtotalusage,
                               @sOuduom, @nDailyusage, @nUsagecorr, @nStartscoreusage, @sCheckrefpoint
    END
  CLOSE eqr
  DEALLOCATE eqr

  /* Summarize linear condition records. */
  IF @sStype = N'O'
    BEGIN
      /* Check division by zero. */
      SET @nCnt = 0
      SELECT @nCnt = SUM( gtc_length )
      FROM   #r5calcobjrrscore
      IF @nCnt > 0
        BEGIN
          DECLARE gtc CURSOR LOCAL STATIC FOR
            SELECT gtc_rankingcode, gtc_rankingorg, gtc_rankingrevision, gtc_rtype, gtc_precision, gtc_trackhistory, SUM( gtc_score * gtc_length ) / SUM( gtc_length )
            FROM   #r5calcobjrrscore
            GROUP BY gtc_rankingcode, gtc_rankingorg, gtc_rankingrevision, gtc_rtype, gtc_precision, gtc_trackhistory
          OPEN gtc
          FETCH NEXT FROM gtc INTO @sGtcrankingcode, @sGtcrankingorg, @nGtcrankingrevision, @sGtcrtype, @nGtcprecision, @sGtctrackhistory, @nGtcaverage
          WHILE @@FETCH_STATUS = 0
            BEGIN
              SET @nScore   = @nGtcaverage
              SET @sRrindex = NULL
              /* Round the score. */
              IF @nGtcprecision IS NOT NULL
                SET @nScore = ROUND( @nGtcaverage, @nGtcprecision )
              /* Get the index. */
              SELECT @sRrindex = ISNULL( rrr_rrindex, rrr_criticality )
              FROM   r5reliabilityrankingranks
              WHERE  rrr_reliabilityranking = @sGtcrankingcode
              AND    rrr_org                = @sGtcrankingorg
              AND    rrr_revision           = @nGtcrankingrevision
              AND    @nScore BETWEEN rrr_minvalue AND rrr_maxvalue
              IF @sRrindex IS NULL
                BEGIN
                  SET @sChk        = N'9'
                  SET @nErrorscore = @nScore
                  SET @sMessage    = @sGtcrankingcode
                  SET @sRrindex    = NULL
                  GOTO END_OF_GTC
                END
              /* Update the equipment ranking. */
              UPDATE r5equipmentrankings
              SET    eqr_rankingscore         = @nScore,
                     eqr_rankingindex         = @sRrindex,
                     eqr_valueslastcalculated = dbo.o7gttime2( eqr_rankingorg ),
                     eqr_calculationerror     = N'-'
              WHERE  eqr_objcode          = @sObj
              AND    eqr_objorg           = @sOrg
              AND    eqr_rankingcode      = @sGtcrankingcode
              AND    eqr_rankingorg       = @sGtcrankingorg
              AND    eqr_rankingrevision  = @nGtcrankingrevision
              /* Update the equipment. */
              UPDATE r5objects
              SET    obj_conditionscore    = CASE @sGtcrtype WHEN N'CI'  THEN @nScore   ELSE obj_conditionscore END,
                     obj_conditionindex    = CASE @sGtcrtype WHEN N'CI'  THEN @sRrindex ELSE obj_conditionindex END,
                     obj_criticalityscore  = CASE @sGtcrtype WHEN N'CRI' THEN @nScore   ELSE obj_criticalityscore END,
                     obj_criticality       = CASE @sGtcrtype WHEN N'CRI' THEN @sRrindex ELSE obj_criticality END,
                     obj_riskpriorityindex = CASE @sGtcrtype WHEN N'RPI' THEN @sRrindex ELSE obj_riskpriorityindex END,
                     obj_rpn               = CASE WHEN obj_rcmlevel IS NULL AND @sGtcrtype = N'RPI' THEN @nScore ELSE obj_rpn END
              WHERE  obj_code = @sObj
              AND    obj_org  = @sOrg
              IF @sGtctrackhistory = N'+'
                BEGIN
                  /* Create a history record, first delete it, if a record already exists for today. */
                  DELETE FROM r5equipmentrankinghistory
                  WHERE  erh_rankingtype     = @sGtcrtype
                  AND    erh_objcode         = @sObj
                  AND    erh_objorg          = @sOrg
                  AND    erh_date            = dbo.F_TRUNC_DATE( GETDATE(), N'DD' )
                  INSERT INTO r5equipmentrankinghistory( erh_rankingcode, erh_rankingorg, erh_rankingrevision, erh_rankingtype, erh_objcode, erh_objorg, erh_date,  erh_score, erh_index,
                         erh_conditionprotocol, erh_condscorestart, erh_condscoreend, erh_condscorethreshold, erh_decaycurve, erh_decaycurve_org, erh_corrconditionscore,
                         erh_corrconditionreason, erh_corrconditiondate, erh_corrconditionusage, erh_primaryuom, erh_dailyusageuom, erh_usage, erh_risklevel )
                  SELECT @sGtcrankingcode, @sGtcrankingorg, @nGtcrankingrevision, rrk_type, obj_code, obj_org, dbo.F_TRUNC_DATE( GETDATE(), N'DD' ), @nScore, @sRrindex,
                         CASE rrk_rtype WHEN N'CI'  THEN rrk_conditionprotocol   ELSE NULL END,
                         CASE rrk_rtype WHEN N'CI'  THEN rrk_condscorestart      ELSE NULL END,
                         CASE rrk_rtype WHEN N'CI'  THEN rrk_condscoreend        ELSE NULL END,
                         CASE rrk_rtype WHEN N'CI'  THEN rrk_condscorethreshold  ELSE NULL END,
                         CASE rrk_rtype WHEN N'CI'  THEN rrk_decaycurve          ELSE NULL END,
                         CASE rrk_rtype WHEN N'CI'  THEN rrk_decaycurve_org      ELSE NULL END,
                         CASE rrk_rtype WHEN N'CI'  THEN obj_corrconditionscore  ELSE NULL END,
                         CASE rrk_rtype WHEN N'CI'  THEN obj_corrconditionreason ELSE NULL END,
                         CASE rrk_rtype WHEN N'CI'  THEN obj_corrconditiondate   ELSE NULL END,
                         CASE rrk_rtype WHEN N'CI'  THEN obj_corrconditionusage  ELSE NULL END,
                         obj_primaryuom,
                         obj_primaryuom,
                         oud_totalusage,
                         CASE rrk_rtype WHEN 'RPI' THEN obj_risklevel           ELSE NULL END
                  FROM   r5reliabilityrankings, r5objects LEFT OUTER JOIN r5objusagedefs ON ( oud_object = obj_code AND oud_object_org = obj_org AND oud_uom = obj_primaryuom )
                  WHERE  rrk_code     = @sGtcrankingcode
                  AND    rrk_org      = @sGtcrankingorg
                  AND    rrk_revision = @nGtcrankingrevision
                  AND    obj_code     = @sObj
                  AND    obj_org      = @sOrg
                END
              END_OF_GTC:
              FETCH NEXT FROM gtc INTO @sGtcrankingcode, @sGtcrankingorg, @nGtcrankingrevision, @sGtcrtype, @nGtcprecision, @sGtctrackhistory, @nGtcaverage
            END
          CLOSE gtc
          DEALLOCATE gtc
        END
    END

  /* Do final commit. */
  IF @@TRANCOUNT > 0
    COMMIT

  /* If there is a ranking specified and at least one record is locked, if so, set chk to '10'. */
  IF @sRanking IS NOT NULL AND @nRecslocked >= 1
    SET @sChk = N'10'

  /* If there was something wrong with getting the index belonging to a score, use the score not found. */
  IF @sChk = N'9'
    BEGIN
      SET @nScore   = @nErrorscore
      SET @sRrindex = NULL
    END

  IF @sChk <> N'0'
    /* Make sure performance calculations are only done if nothing is wrong. */
    RETURN

  /* ***  P E R F O R M A N C E   C A L C U L A T I O N S  *** */

  SET @sEqrrankingcode = NULL

  SELECT @sEqrrankingcode           = eqr_rankingcode,
         @sEqrrankingorg            = eqr_rankingorg,
         @nEqrrankingrev            = eqr_rankingrevision,
         @sRrktype                  = rrk_rtype,
         @nRrkcondscorestart        = ISNULL( rrk_condscorestart, dcr_condscorestart ),
         @nRrkcondscoreend          = ISNULL( rrk_condscoreend, dcr_condscoreend ),
         @nEqrrankingscore          = eqr_rankingscore,
         @sRrktrackhistory          = rrk_trackhistory,
         @sRkkperfformula           = rrk_performanceformula,
         @sRkkperfformulaorg        = rrk_performanceformula_org,
         @sObjcategory              = obj_category,
         @sObjclass                 = obj_class,
         @sObjclassorg              = obj_class_org,
         @sObjprimaryuom            = obj_primaryuom,
         @nDailyusage               =
           CASE COALESCE( oud_calcdailyusg, oud_dfltdailyusg, oud_totalusage / dbo.F_GREATEST_NUMBER( DATEDIFF( dd, obj_commiss, dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) ), 1 ) ) WHEN 0 THEN NULL
             ELSE COALESCE( oud_calcdailyusg, oud_dfltdailyusg, oud_totalusage / dbo.F_GREATEST_NUMBER(  DATEDIFF( dd, obj_commiss, dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) ), 1 ) ) END
  FROM   r5reliabilityrankings LEFT OUTER JOIN r5decaycurve ON ( dcr_code = rrk_decaycurve AND dcr_org = rrk_decaycurve_org ),
         r5equipmentrankings, r5objects
         LEFT OUTER JOIN r5objusagedefs ON ( oud_object = obj_code AND oud_object_org = obj_org AND oud_uom = obj_primaryuom )
  WHERE  rrk_code            = eqr_rankingcode
  AND    rrk_org             = eqr_rankingorg
  AND    rrk_revision        = eqr_rankingrevision
  AND    obj_code            = eqr_objcode
  AND    obj_org             = eqr_objorg
  AND    eqr_objcode         = @sObj
  AND    eqr_objorg          = @sOrg
  AND    eqr_rankingcode     = ISNULL( @sRanking, eqr_rankingcode )
  AND    eqr_rankingorg      = ISNULL( @sRankingorg, eqr_rankingorg )
  AND    eqr_rankingrevision = ISNULL( @nRankingrev, eqr_rankingrevision )
  AND    @sStype             = 'O'
  AND    rrk_performanceformula IS NOT NULL

  IF @sEqrrankingcode IS NULL
    /* Exit if no ranking found. */
    RETURN

  /* Reset error flag. */
  UPDATE r5equipmentrankings
  SET    eqr_calculationerror = '-'
  WHERE  eqr_objcode          = @sObj
  AND    eqr_objorg           = @sOrg
  AND    eqr_rankingcode      = @sEqrrankingcode
  AND    eqr_rankingorg       = @sEqrrankingorg
  AND    eqr_rankingrevision  = @nEqrrankingrev

  /* Get performance formula. */
  SET @sPerfformula     = NULL
  SET @sPerfformulaorg  = NULL
  SET @sPerfformuladate = NULL
  SET @sAutocreateclass = NULL
  SET @sAutocreatecat   = NULL
  SET @sPk              = NULL
  SET @sRollup          = N'-'
  IF @sObjclass IS NOT NULL
    BEGIN
      /* First try for the class of the equipment. */
      SELECT @sPerfformula     = ocd_performanceformula,
             @sPerfformulaorg  = ocd_performanceformula_org,
             @sAutocreatecat   = ocd_autocreatecatlevel,
             @sPk              = ocd_pk
      FROM   r5assetclassdefinition
      WHERE  ocd_category IS NULL
      AND    ocd_org       = @sOrg
      AND    ocd_class     = @sObjclass
      AND    ocd_class_org = @sObjclassorg
      IF @sPerfformula IS NULL
        BEGIN
          /* Then try for the '*' class. */
          SELECT @sPerfformula     = ocd_performanceformula,
                 @sPerfformulaorg  = ocd_performanceformula_org,
                 @sAutocreateclass = ocd_autocreateclasslevel,
                 @sAutocreatecat   = ocd_autocreatecatlevel,
                 @sPk              = ocd_pk
          FROM   r5assetclassdefinition
          WHERE  ocd_category IS NULL
          AND    ocd_org       = @sOrg
          AND    ocd_class     = N'*'
          AND    ocd_class_org = N'*'
          IF @sPerfformula IS NULL
            BEGIN
              /* Finally try for the '*' class, in the '*' org. */
              SELECT @sPerfformula     = ocd_performanceformula,
                     @sPerfformulaorg  = ocd_performanceformula_org,
                     @sAutocreateclass = ocd_autocreateclasslevel,
                     @sAutocreatecat   = ocd_autocreatecatlevel,
                     @sPk              = ocd_pk
              FROM   r5assetclassdefinition
              WHERE  ocd_category IS NULL
              AND    ocd_org       = N'*'
              AND    ocd_class     = N'*'
              AND    ocd_class_org = N'*'
            END
        END
    END

  IF @sAutocreatecat = N'+' AND @sObjcategory IS NOT NULL
    BEGIN
      /* Create a category specific class definition record, if it doesn't exist yet. */
      EXECUTE r5o7_o7maxseq @sOcdpk OUTPUT, N'OCD', N'1', @sChk2 OUTPUT
      INSERT INTO r5assetclassdefinition( ocd_pk, ocd_org, ocd_class, ocd_class_org, ocd_category, ocd_autocreated )
      SELECT @sOcdpk, @sOrg, @sObjclass, @sObjclassorg, @sObjcategory, N'+'
      FROM   dual
      WHERE  NOT EXISTS ( SELECT 1
                          FROM   r5assetclassdefinition
                          WHERE  ocd_org       = @sOrg
                          AND    ocd_class     = @sObjclass
                          AND    ocd_class_org = @sObjclassorg
                          AND    ocd_category  = @sObjcategory )
    END

  IF @sAutocreateclass = N'+'
    BEGIN
      /* Create class definition record.*/
      EXECUTE r5o7_o7maxseq @sOcdpk OUTPUT, N'OCD', N'1', @sChk2 OUTPUT
      INSERT INTO r5assetclassdefinition( ocd_pk, ocd_org, ocd_class, ocd_class_org, ocd_performanceformula, ocd_performanceformula_org, ocd_autocreatecatlevel, ocd_autocreated )
      SELECT @sOcdpk, @sOrg, @sObjclass, @sObjclassorg, @sPerfformula, @sPerfformulaorg, @sAutocreatecat, N'+'
      FROM   dual
      WHERE  NOT EXISTS ( SELECT 1
                          FROM   r5assetclassdefinition
                          WHERE  ocd_org       = @sOrg
                          AND    ocd_class     = @sObjclass
                          AND    ocd_class_org = @sObjclassorg
                          AND    ocd_category  IS NULL )
    END

  IF @sPerfformula IS NULL
    BEGIN
      /* No performance formula found, use the one on the reliability ranking record. */
      SET @sPerfformula    = @sRkkperfformula
      SET @sPerfformulaorg = @sRkkperfformulaorg
    END
  ELSE
    /* Class specific record found, set the rollup flag. */
    SET @sRollup = N'+'

  IF @sPerfformula IS NULL
    /* No performance formula found, exit. */
    RETURN
  ELSE
    BEGIN
      /* Check system status of performance formula. */
      SELECT @sRstatus         = pff_rstatus,
             @dPerfformuladate = pff_dateapproved,
             @sCapacitycode    = pff_capacitycode,
             @sIncludechildren = pff_includechildren,
             @nMaxfailures     = pff_maxallowfailsperyear,
             @sUsagebased      = pff_usagebased,
             @sUsageuom        = pff_atusageperdayuom,
             @nUsageperday     = pff_atusageperday,
             @sUsedowntime     = pff_usedowntimehrsifpresent,
             @sRepairtimecalc  = pff_repairtimecalculation,
             @nMaxrepairhours  = pff_maxallowablerepairhours,
             @nCondweight      = pff_conditionratingweight,
             @nCapweight       = pff_capacityratingweight,
             @nMtbfweight      = pff_mtbfratingweight,
             @nMttrweight      = pff_mttrratingweight,
             @nVar1weight      = pff_variable1ratingweight,
             @nVar2weight      = pff_variable2ratingweight,
             @nVar3weight      = pff_variable3ratingweight,
             @nVar4weight      = pff_variable4ratingweight,
             @nVar5weight      = pff_variable5ratingweight,
             @nVar6weight      = pff_variable6ratingweight
      FROM   r5performanceformulas
      WHERE  pff_code = @sPerfformula
      AND    pff_org  = @sPerfformulaorg

      IF @sRstatus <> N'A'
        BEGIN
          /* If performance formula is not approved, give error and exit. */
          SET @sChk     = N'19'
          SET @sMessage = @sPerfformula + N' ' + @sPerfformulaorg
          GOTO checkerror
        END
    END

  IF @nCondweight > 0
    BEGIN
      /* Condition rating. */
      SET @nRange    = ABS( @nRrkcondscorestart - @nRrkcondscoreend )
      SET @nMinscore = dbo.F_LEAST_NUMBER( @nRrkcondscorestart, @nRrkcondscoreend )
      SET @nMaxscore = dbo.F_GREATEST_NUMBER( @nRrkcondscorestart, @nRrkcondscoreend )
      IF @nEqrrankingscore < @nMinscore
        SET @nAdjustedscore = @nMinscore
      ELSE IF @nEqrrankingscore > @nMaxscore
        SET @nAdjustedscore = @NMaxscore
      ELSE
        SET @nAdjustedscore = @nEqrrankingscore
      SET @nConditionrating = ROUND( ( ( @nAdjustedscore - @nMinscore ) * 100 ) / @nRange, 0 )
      IF @nRrkcondscorestart < @nRrkcondscoreend
        SET @nConditionrating = 100 - @nConditionrating
    END

  IF @nCapweight > 0
    BEGIN
      /* Available capacity. */
      SET @nCapacity = NULL
      SELECT @nCapacity = ocp_capacity
      FROM   r5objectcapacities
      WHERE  ocp_object       = @sObj
      AND    ocp_object_org   = @sOrg
      AND    ocp_capacitycode = @sCapacitycode
      AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ocp_effective AND ocp_expired
      IF @nCapacity IS NULL
        BEGIN
          /* Nothing on object level, try category. */
          SELECT @nCapacity = ccp_capacity
          FROM   r5assetclassdefcapacities, r5assetclassdefinition
          WHERE  ocd_pk           = ccp_ocdpk
          AND    ocd_org          = @sOrg
          AND    ocd_class        = @sObjclass
          AND    ocd_class_org    = @sObjclassorg
          AND    ccp_capacitycode = @sCapacitycode
          AND    ocd_category     = @sObjcategory
          AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ccp_effective AND ccp_expired
          IF @nCapacity IS NULL
            BEGIN
              /* Nothing on category, try class. */
              SELECT @nCapacity = ccp_capacity
              FROM   r5assetclassdefcapacities, r5assetclassdefinition
              WHERE  ocd_pk           = ccp_ocdpk
              AND    ocd_org          = @sOrg
              AND    ocd_class        = @sObjclass
              AND    ocd_class_org    = @sObjclassorg
              AND    ccp_capacitycode = @sCapacitycode
              AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ccp_effective AND ccp_expired
              IF @nCapacity IS NULL
                BEGIN
                  /* Nothing on class level, try '*' class. */
                  SELECT @nCapacity = ccp_capacity
                  FROM   r5assetclassdefcapacities, r5assetclassdefinition
                  WHERE  ocd_pk           = ccp_ocdpk
                  AND    ocd_org          = @sOrg
                  AND    ocd_class        = N'*'
                  AND    ocd_class_org    = N'*'
                  AND    ccp_capacitycode = @sCapacitycode
                  AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ccp_effective AND ccp_expired
                  IF @nCapacity IS NULL
                    BEGIN
                      /* Nothing on '*' class level, try '*' class in '*' org. */
                      SELECT @nCapacity = ccp_capacity
                      FROM   r5assetclassdefcapacities, r5assetclassdefinition
                      WHERE  ocd_pk           = ccp_ocdpk
                      AND    ocd_org          = N'*'
                      AND    ocd_class        = N'*'
                      AND    ocd_class_org    = N'*'
                      AND    ccp_capacitycode = @sCapacitycode
                      AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ccp_effective AND ccp_expired
                    END
                END
            END
        END

      /* Desired capacity. */
      SET @nDesiredcapacity = NULL
      SELECT @nDesiredcapacity = ocp_desiredcapacity
      FROM   r5objectcapacities
      WHERE  ocp_object       = @sObj
      AND    ocp_object_org   = @sOrg
      AND    ocp_capacitycode = @sCapacitycode
      AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ocp_effective AND ocp_expired
      IF @nDesiredcapacity IS NULL
        BEGIN
          /* Nothing on object level, try category. */
          SELECT @nDesiredcapacity = ccp_desiredcapacity
          FROM   r5assetclassdefcapacities, r5assetclassdefinition
          WHERE  ocd_pk           = ccp_ocdpk
          AND    ocd_org          = @sOrg
          AND    ocd_class        = @sObjclass
          AND    ocd_class_org    = @sObjclassorg
          AND    ccp_capacitycode = @sCapacitycode
          AND    ocd_category     = @sObjcategory
          AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ccp_effective AND ccp_expired
          IF @nDesiredcapacity IS NULL
            BEGIN
              /* Nothing on category, try class. */
              SELECT @nDesiredcapacity = ccp_desiredcapacity
              FROM   r5assetclassdefcapacities, r5assetclassdefinition
              WHERE  ocd_pk           = ccp_ocdpk
              AND    ocd_org          = @sOrg
              AND    ocd_class        = @sObjclass
              AND    ocd_class_org    = @sObjclassorg
              AND    ccp_capacitycode = @sCapacitycode
              AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ccp_effective AND ccp_expired
              IF @nDesiredcapacity IS NULL
                BEGIN
                  /* Nothing on class level, try '*' class. */
                  SELECT @nDesiredcapacity = ccp_desiredcapacity
                  FROM   r5assetclassdefcapacities, r5assetclassdefinition
                  WHERE  ocd_pk           = ccp_ocdpk
                  AND    ocd_org          = @sOrg
                  AND    ocd_class        = N'*'
                  AND    ocd_class_org    = N'*'
                  AND    ccp_capacitycode = @sCapacitycode
                  AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ccp_effective AND ccp_expired
                  IF @nDesiredcapacity IS NULL
                    BEGIN
                      /* Nothing on '*' class level, try '*' class in '*' org. */
                      SELECT @nDesiredcapacity = ccp_desiredcapacity
                      FROM   r5assetclassdefcapacities, r5assetclassdefinition
                      WHERE  ocd_pk           = ccp_ocdpk
                      AND    ocd_org          = N'*'
                      AND    ocd_class        = N'*'
                      AND    ocd_class_org    = N'*'
                      AND    ccp_capacitycode = @sCapacitycode
                      AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ccp_effective AND ccp_expired
                    END
                END
            END
        END

      /* Capacity rating. */
      IF ISNULL( @nDesiredcapacity, 0 ) = 0 OR @nCapacity IS NULL
        SET @nCapacityrating = 100
      ELSE
        SET @nCapacityrating = ROUND( dbo.F_LEAST_NUMBER( @nCapacity / @nDesiredcapacity * 100, 100 ), 0 )

    END

  IF @nMtbfweight > 0 OR @nMttrweight > 0
    BEGIN
      /* Number of failures. */
      IF @sIncludechildren = '-'
        /* No children, so use r5events. */
        SELECT @nNumberoffailures = COUNT(*),
               @nEvtdowntime      = SUM( evt_downtimehrs ),
               @nEvtcomprrepdt    = SUM( DATEDIFF( hh, evt_reported, evt_completed ) ),
               @nEvtcomprrepdt2   = SUM( CASE WHEN evt_downtimehrs IS NULL THEN DATEDIFF( hh, evt_reported, evt_completed ) ELSE 0 END )
        FROM   r5ucodes, r5events
        WHERE  uco_code       = evt_jobtype
        AND    uco_rcode      = N'BR'
        AND    uco_rentity    = N'JBTP'
        AND    evt_object     = @sObj
        AND    evt_object_org = @sOrg
        AND    evt_completed > dbo.O7ADD_MONTHS( GETDATE(), -12 )
        AND    evt_status NOT IN ( SELECT ins_desc FROM r5install WHERE ins_code IN ( N'CANCSTAT', N'REJSTAT' ) )
      ELSE
        /* Include children, so use r5eventobjects. */
        SELECT @nNumberoffailures = COUNT(*),
               @nEvtdowntime      = SUM( evt_downtimehrs ),
               @nEvtcomprrepdt    = SUM( DATEDIFF( hh, evt_reported, evt_completed ) ),
               @nEvtcomprrepdt2   = SUM( CASE WHEN evt_downtimehrs IS NULL THEN DATEDIFF( hh, evt_reported, evt_completed ) ELSE 0 END )
        FROM   r5ucodes, r5events, r5eventobjects
        WHERE  uco_code       = evt_jobtype
        AND    evt_code       = eob_event
        AND    uco_rcode      = N'BR'
        AND    uco_rentity    = N'JBTP'
        AND    eob_object     = @sObj
        AND    eob_object_org = @sOrg
        AND    evt_completed >= dbo.O7ADD_MONTHS( GETDATE(), -12 )
        AND    evt_status NOT IN ( SELECT ins_desc FROM r5install WHERE ins_code IN ( N'CANCSTAT', N'REJSTAT' ) );
    END

  IF @nMtbfweight > 0
    BEGIN
      /* Mean Time Between Failures. */
      IF @nNumberoffailures > 0
        SET @nMtbf = 365 / @nNumberoffailures
      ELSE
        SET @nMtbf = NULL

      /* MTBF rating. */
      IF @nNumberoffailures = 0
        SET @nMtbfrating = 100
      ELSE
        SET @nMtbfrating = 100 - ROUND( ( dbo.F_LEAST_NUMBER( @nNumberoffailures, @nMaxfailures ) * 100 ) / @nMaxfailures, 0 )

      /* Mean Usage Between Failures. */
      IF @sUsagebased = N'+'
        BEGIN
          IF @sObjprimaryuom IS NULL
            BEGIN
              /* No meter unit, exit. */
              SET @sChk = N'20'
              GOTO checkerror
            END
          IF @nNumberoffailures > 0
            SET @nMubf = 365 * @nDailyusage / @nNumberoffailures
          ELSE
            SET @nMubf = NULL
        END

      /* MUFB rating. */
      IF @sUsagebased = N'+'
        BEGIN
          IF @nNumberoffailures = 0
            SET @nMubfrating = 100
          ELSE
            BEGIN
              IF @sObjprimaryuom <> @sUsageuom
                BEGIN
                  /* Try to find a UOM conversion factor. */
                  SELECT @nUomconvfactor = uoc_confact
                  FROM   r5uomconversion
                  WHERE  uoc_baseuom = @sObjprimaryuom
                  AND    uoc_siteuom = @sUsageuom
                  IF @nUomconvfactor IS NULL
                    BEGIN
                      /* No meter unit conversion, exit. */
                      SET @sChk = N'21'
                      GOTO checkerror
                    END
                  SET @nConvupd = @nUsageperday * @nUomconvfactor
                END
              ELSE
                SET @nConvupd = @nUsageperday
              IF @nConvupd = 0 OR @nDailyusage = 0
                SET @nMubfrating = NULL
              ELSE
                BEGIN
                  SET @nFailureusagemax = @nMaxfailures / ( @nConvupd * 365 )
                  SET @nFailureusage    = @nNumberoffailures / ( @nDailyusage * 365 )
                  SET @nFailures        = dbo.F_LEAST_NUMBER( @nFailureusagemax, @nFailureusage )
                  SET @nMubfrating      = 100 - ROUND( ( @nFailures * 100 ) / @nFailureusagemax, 0 )
                END
            END
        END
    END

  IF @nMttrweight > 0
    BEGIN
      /* MTTR hours */
      IF @sRepairtimecalc = N'WOCR'
        BEGIN
          /* Use time between completed and reported. */
          IF @sUsedowntime = '+'
            /* Use downtime from WOs plus downtime from time between completed and reported (if no downtime specified). */
            SET @nDowntime = ISNULL( @nEvtdowntime, 0 ) + ISNULL( @nEvtcomprrepdt2, 0 )
          ELSE
            /* Use downtime from total time between completed and reported. */
            SET @nDowntime = ISNULL( @nEvtcomprrepdt, 0 )
        END
      ELSE
        BEGIN
          /* Use time on booked hours. */
          IF @sIncludechildren = N'-'
            /* No children, so use r5events. */
            SELECT @nBookeddowntime = SUM( maxhours )
            FROM   ( SELECT MAX( bhours ) maxhours, bdate, bevent
                     FROM   ( SELECT SUM( boo_hours ) bhours, boo_date bdate, boo_person bperson, boo_event bevent
                              FROM   r5bookedhours
                              WHERE  boo_person IS NOT NULL
                              AND    boo_event IN ( SELECT evt_code
                                                    FROM   r5ucodes, r5events
                                                    WHERE  uco_code       = evt_jobtype
                                                    AND    uco_rcode      = N'BR'
                                                    AND    uco_rentity    = N'JBTP'
                                                    AND    evt_object     = @sObj
                                                    AND    evt_object_org = @sOrg
                                                    AND    evt_completed > dbo.O7ADD_MONTHS( GETDATE(), -12 )
                                                    AND    evt_status NOT IN ( SELECT ins_desc FROM r5install WHERE ins_code IN ( N'CANCSTAT', N'REJSTAT' ) )
                                                    AND    ( evt_downtimehrs IS NULL OR @sUsedowntime = N'-' ) )
                              GROUP BY boo_date, boo_person, boo_event ) AS tab
                     GROUP BY bdate, bevent ) AS tab2
          ELSE
            /* Include children, so use r5eventobjects. */
            SELECT @nBookeddowntime = SUM( maxhours )
            FROM   ( SELECT MAX( bhours ) maxhours, bdate, bevent
                     FROM   ( SELECT SUM( boo_hours ) bhours, boo_date bdate, boo_person bperson, boo_event bevent
                              FROM   r5bookedhours
                              WHERE  boo_person IS NOT NULL
                              AND    boo_event IN ( SELECT evt_code
                                                    FROM   r5ucodes, r5events, r5eventobjects
                                                    WHERE  uco_code       = evt_jobtype
                                                    AND    evt_code       = eob_event
                                                    AND    uco_rcode      = N'BR'
                                                    AND    uco_rentity    = N'JBTP'
                                                    AND    eob_object     = @sObj
                                                    AND    eob_object_org = @sOrg
                                                    AND    evt_completed >= dbo.O7ADD_MONTHS( GETDATE(), -12 )
                                                    AND    evt_status NOT IN ( SELECT ins_desc FROM r5install WHERE ins_code IN ( N'CANCSTAT', N'REJSTAT' ) )
                                                    AND    ( evt_downtimehrs IS NULL OR @sUsedowntime = N'-' ) )
                              GROUP BY boo_date, boo_person, boo_event ) AS tab
                     GROUP BY bdate, bevent ) AS tab2

          IF @sUsedowntime = N'+'
            /* Use downtime from WOs plus downtime from booked hours (if no downtime specified). */
            SET @nDowntime = ISNULL( @nEvtdowntime, 0 ) + ISNULL( @nBookeddowntime, 0 )
          ELSE
            /* Use downtime from booked hours. */
            SET @nDowntime = ISNULL( @nBookeddowntime, 0 )
        END

      IF @nNumberoffailures = 0
        SET @nMttrhours = 0
      ELSE
        SET @nMttrhours = @nDowntime / @nNumberoffailures

      /* MTTR rating. */
      IF @nMttrhours = 0
        SET @nMttrrating = 100
      ELSE
        SET @nMttrrating = 100 - ROUND( ( dbo.F_LEAST_NUMBER( @nMttrhours, @nMaxrepairhours ) * 100 ) / @nMaxrepairhours, 0 )

    END

  /* Variable ratings. */
  SET @i = 1
  WHILE @i <= 6
    BEGIN
      /* Loop through all 6 variables. */
      SET @sVarquery  = NULL
      SET @nVarbest   = NULL
      SET @nVarworst  = NULL
      SET @nVarweight = NULL
      SET @sString    = NULL

      SELECT @sVarquery =
             CASE @i
               WHEN 1 THEN pff_variable1query
               WHEN 2 THEN pff_variable2query
               WHEN 3 THEN pff_variable3query
               WHEN 4 THEN pff_variable4query
               WHEN 5 THEN pff_variable5query
               WHEN 6 THEN pff_variable6query
             END,
             @nVarbest =
             CASE @i
               WHEN 1 THEN pff_bestacceptableresult1
               WHEN 2 THEN pff_bestacceptableresult2
               WHEN 3 THEN pff_bestacceptableresult3
               WHEN 4 THEN pff_bestacceptableresult4
               WHEN 5 THEN pff_bestacceptableresult5
               WHEN 6 THEN pff_bestacceptableresult6
             END,
             @nVarworst =
             CASE @i
               WHEN 1 THEN pff_worstacceptableresult1
               WHEN 2 THEN pff_worstacceptableresult2
               WHEN 3 THEN pff_worstacceptableresult3
               WHEN 4 THEN pff_worstacceptableresult4
               WHEN 5 THEN pff_worstacceptableresult5
               WHEN 6 THEN pff_worstacceptableresult6
             END,
             @nVarweight =
             CASE @i
               WHEN 1 THEN pff_variable1ratingweight
               WHEN 2 THEN pff_variable2ratingweight
               WHEN 3 THEN pff_variable3ratingweight
               WHEN 4 THEN pff_variable4ratingweight
               WHEN 5 THEN pff_variable5ratingweight
               WHEN 6 THEN pff_variable6ratingweight
             END
      FROM   r5performanceformulas
      WHERE  pff_code = @sPerfformula
      AND    pff_org  = @sPerfformulaorg

      IF @sVarquery IS NOT NULL AND @nVarweight > 0
        BEGIN
          SELECT @sString = que_text
          FROM   r5queries
          WHERE  que_code = @sVarquery

          SET @sString = REPLACE( @sString, ''':OBJECTORG''', '''' + @sOrg + '''' )
          SET @sString = REPLACE( @sString, ':OBJECTORG', '''' + @sOrg + '''' )
          SET @sString = REPLACE( @sString, ''':OBJECT''', '''' + @sObj + '''' )
          SET @sString = REPLACE( @sString, ':OBJECT', '''' + @sObj + '''' )
          SET @sString = REPLACE( @sString, ''':objectorg''', '''' + @sOrg + '''' )
          SET @sString = REPLACE( @sString, ':objectorg', '''' + @sOrg + '''' )
          SET @sString = REPLACE( @sString, ''':object''', '''' + @sObj + '''' )
          SET @sString = REPLACE( @sString, ':object', '''' + @sObj + '''' )

          BEGIN TRY
            SET @sString = SUBSTRING( @sString, 1, 7 ) + N' @sQresult = ' + SUBSTRING( @sString, 8, 4000 )
            EXECUTE sp_executesql @sString, N'@sQresult NVARCHAR( 4000 ) OUTPUT', @sQresult OUTPUT
            SET @nVarresult = CAST( @sQresult AS NUMERIC( 24, 6 ) )
          END TRY
          BEGIN CATCH
            SET @sChk        = N'22'
            SET @sMessage    = @sVarquery + '(' + @sPerfformula + ' ' + @sPerfformulaorg
            GOTO checkerror
          END CATCH

          SET @nRange    = ABS( @nVarbest - @nVarworst )
          SET @nMinscore = dbo.F_LEAST_NUMBER( @nVarbest, @nVarworst )
          SET @nMaxscore = dbo.F_GREATEST_NUMBER( @nVarbest, @nVarworst )

          IF @nVarresult < @nMinscore
            SET @nAdjustedscore = @nMinscore
          ELSE IF @nVarresult > @nMaxscore
            SET @nAdjustedscore = @nMaxscore
          ELSE
            SET @nAdjustedscore = @nVarresult

          SET @nVarrating = ROUND( ( ( @nAdjustedscore - @nMinscore ) * 100 ) / @nRange, 0 )

          IF @nVarbest < @nVarworst
            SET @nVarrating = 100 - @nVarrating

          IF @i = 1
            BEGIN
              SET @nVar1result = @nVarresult
              SET @nVar1rating = @nVarrating
            END
          ELSE IF @i = 2
            BEGIN
              SET @nVar2result = @nVarresult
              SET @nVar2rating = @nVarrating
            END
          ELSE IF @i = 3
            BEGIN
              SET @nVar3result = @nVarresult
              SET @nVar3rating = @nVarrating
            END
          ELSE IF @i = 4
            BEGIN
              SET @nVar4result = @nVarresult
              SET @nVar4rating = @nVarrating
            END
          ELSE IF @i = 5
            BEGIN
              SET @nVar5result = @nVarresult
              SET @nVar5rating = @nVarrating
            END
          ELSE IF @i = 6
            BEGIN
              SET @nVar6result = @nVarresult
              SET @nVar6rating = @nVarrating
            END
        END
      SET @i = @i + 1
    END

  SET @nPerformance = ( ISNULL( @nConditionrating, 0 ) * ISNULL( @nCondweight, 0 ) ) +
                      ( ISNULL( @nCapacityrating, 0 )  * ISNULL( @nCapweight, 0 ) ) +
                      ( ISNULL( @nMttrrating, 0 )      * ISNULL( @nMttrweight, 0 ) ) +
                      ( ISNULL( @nVar1rating, 0 )      * ISNULL( @nVar1weight, 0 ) ) +
                      ( ISNULL( @nVar2rating, 0 )      * ISNULL( @nVar2weight, 0 ) ) +
                      ( ISNULL( @nVar3rating, 0 )      * ISNULL( @nVar3weight, 0 ) ) +
                      ( ISNULL( @nVar4rating, 0 )      * ISNULL( @nVar4weight, 0 ) ) +
                      ( ISNULL( @nVar5rating, 0 )      * ISNULL( @nVar5weight, 0 ) ) +
                      ( ISNULL( @nVar6rating, 0 )      * ISNULL( @nVar6weight, 0 ) )

  IF @sUsagebased = N'-'
    SET @nPerformance = ROUND( @nPerformance + ( ISNULL( @nMtbfrating, 0 ) * ISNULL( @nMtbfweight, 0 ) ), 0 )
  ELSE
    SET @nPerformance = ROUND( @nPerformance + ( ISNULL( @nMubfrating, 0 ) * ISNULL( @nMtbfweight, 0 ) ), 0 )

  /* Update table r5objects with all results. */
  UPDATE r5objects
  SET    obj_performanceformula     = @sPerfformula,
         obj_performanceformula_org = @sPerfformulaorg,
         obj_performance            = @nPerformance,
         obj_performancelastupdated = GETDATE(),
         obj_conditionrating        = @nConditionrating,
         obj_capacitycode           = @sCapacitycode,
         obj_availablecapacity      = @nCapacity,
         obj_desiredcapacity        = @nDesiredcapacity,
         obj_capacityrating         = @nCapacityrating,
         obj_numberoffailures       = @nNumberoffailures,
         obj_mtbfdays               = @nMtbf,
         obj_mtbfrating             = @nMtbfrating,
         obj_mubf                   = @nMubf,
         obj_mubfrating             = @nMubfrating,
         obj_mttrhrs                = @nMttrhours,
         obj_mttrrating             = @nMttrrating,
         obj_variableresult1        = @nVar1result,
         obj_variablerating1        = @nVar1rating,
         obj_variableresult2        = @nVar2result,
         obj_variablerating2        = @nVar2rating,
         obj_variableresult3        = @nVar3result,
         obj_variablerating3        = @nVar3rating,
         obj_variableresult4        = @nVar4result,
         obj_variablerating4        = @nVar4rating,
         obj_variableresult5        = @nVar5result,
         obj_variablerating5        = @nVar5rating,
         obj_variableresult6        = @nVar6result,
         obj_variablerating6        = @nVar6rating
  WHERE  obj_code = @sObj
  AND    obj_org  = @sOrg

  IF @sRrktrackhistory = N'+'
    /* Update the history record. */
    UPDATE r5equipmentrankinghistory
    SET    erh_capacityrating   = @nCapacityrating,
           erh_numberoffailures = @nNumberoffailures,
           erh_mtbfdays         = @nMtbf,
           erh_mtbfrating       = @nMtbfrating,
           erh_mubf             = @nMubf,
           erh_mubfrating       = @nMubfrating,
           erh_mttrhrs          = @nMttrhours,
           erh_mttrrating       = @nMttrrating,
           erh_variableresult1  = @nVar1result,
           erh_variablerating1  = @nVar1rating,
           erh_variableresult2  = @nVar2result,
           erh_variablerating2  = @nVar2rating,
           erh_variableresult3  = @nVar3result,
           erh_variablerating3  = @nVar3rating,
           erh_variableresult4  = @nVar4result,
           erh_variablerating4  = @nVar4rating,
           erh_variableresult5  = @nVar5result,
           erh_variablerating5  = @nVar5rating,
           erh_variableresult6  = @nVar6result,
           erh_variablerating6  = @nVar6rating
    WHERE  erh_rankingcode     = @sEqrrankingcode
    AND    erh_rankingorg      = @sEqrrankingorg
    AND    erh_rankingrevision = @nEqrrankingrev
    AND    erh_rankingtype     = @sRrkrtype
    AND    erh_objcode         = @sObj
    AND    erh_objorg          = @sOrg
    AND    erh_date            = dbo.F_TRUNC_DATE( GETDATE(), N'DD' )

  IF @sRollup = '+' AND @sObjcategory IS NOT NULL
    BEGIN
      /* Check if category record exists. */
      SELECT @nCnt = COUNT(*)
      FROM   r5assetclassdefinition
      WHERE  ocd_category  = @sObjcategory
      AND    ocd_org       = @sOrg
      IF @nCnt > 0
        BEGIN
          /* Calculate average/sum for the category, using data from objects belonging to the category. */
          /* Exception for the number of objects in the category and total desired capacity. */
          SELECT @nCnt         = COUNT(*),
                 @nTotcapacity = SUM( obj_availablecapacity )
          FROM   r5objects
          WHERE  obj_category = @sObjcategory
          AND    obj_org      = @sOrg
          AND    obj_rstatus NOT IN ( N'A', N'D' )
          /* Total desired capacity. */
          SET @nTotdesiredcapacity = NULL
          SELECT @nTotdesiredcapacity = ccp_totaldesiredcapacity
          FROM   r5assetclassdefcapacities, r5assetclassdefinition
          WHERE  ocd_pk           = ccp_ocdpk
          AND    ocd_org          = @sOrg
          AND    ocd_class        = @sObjclass
          AND    ocd_class_org    = @sObjclassorg
          AND    ccp_capacitycode = @sCapacitycode
          AND    ocd_category     = @sObjcategory
          AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ccp_effective AND ccp_expired
          IF @nTotdesiredcapacity IS NULL
            BEGIN
              /* Nothing on category level, try class. */
              SELECT @nTotdesiredcapacity = ccp_totaldesiredcapacity
              FROM   r5assetclassdefcapacities, r5assetclassdefinition
              WHERE  ocd_pk           = ccp_ocdpk
              AND    ocd_org          = @sOrg
              AND    ocd_class        = @sObjclass
              AND    ocd_class_org    = @sObjclassorg
              AND    ccp_capacitycode = @sCapacitycode
              AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ccp_effective AND ccp_expired
              IF @nTotdesiredcapacity IS NULL
                BEGIN
                  /* Nothing on class level, try '*' class. */
                  SELECT @nTotdesiredcapacity = ccp_totaldesiredcapacity
                  FROM   r5assetclassdefcapacities, r5assetclassdefinition
                  WHERE  ocd_pk           = ccp_ocdpk
                  AND    ocd_org          = @sOrg
                  AND    ocd_class        = '*'
                  AND    ocd_class_org    = '*'
                  AND    ccp_capacitycode = @sCapacitycode
                  AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ccp_effective AND ccp_expired
                  IF @nTotdesiredcapacity IS NULL
                    BEGIN
                      /* Nothing on '*' class level, try '*' class in '*' org. */
                      SELECT @nTotdesiredcapacity = ccp_totaldesiredcapacity
                      FROM   r5assetclassdefcapacities, r5assetclassdefinition
                      WHERE  ocd_pk           = ccp_ocdpk
                      AND    ocd_org          = '*'
                      AND    ocd_class        = '*'
                      AND    ocd_class_org    = '*'
                      AND    ccp_capacitycode = @sCapacitycode
                      AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ccp_effective AND ccp_expired
                    END
                END
            END

          UPDATE a1
          SET    ocd_conditionrating        = t1.conditionrating,
                 ocd_capacitycode           = @sCapacitycode,
                 ocd_availablecapacity      = @nTotcapacity,
                 ocd_desiredcapacity        = @nTotdesiredcapacity,
                 ocd_capacityrating         = CASE WHEN ISNULL( @nCapweight, 0 ) = 0 THEN NULL ELSE
                                                CASE WHEN ISNULL( @nTotdesiredcapacity, 0 ) = 0 OR @nTotcapacity IS NULL THEN 100 ELSE
                                                  ROUND( dbo.F_LEAST_NUMBER( @nTotcapacity / @nTotdesiredcapacity * 100, 100 ), 0 ) END END,
                 ocd_equipcount             = @nCnt,
                 ocd_numberoffailures       = t1.numberoffailures,
                 ocd_mtbfdays               = t1.mtbf,
                 ocd_mtbfrating             = t1.mtbfrating,
                 ocd_mttrhrs                = t1.mttr,
                 ocd_mttrrating             = t1.mttrrating,
                 ocd_variableresult1        = t1.variableresult1,
                 ocd_variablerating1        = t1.variablerating1,
                 ocd_variableresult2        = t1.variableresult2,
                 ocd_variablerating2        = t1.variablerating2,
                 ocd_variableresult3        = t1.variableresult3,
                 ocd_variablerating3        = t1.variablerating3,
                 ocd_variableresult4        = t1.variableresult4,
                 ocd_variablerating4        = t1.variablerating4,
                 ocd_variableresult5        = t1.variableresult5,
                 ocd_variablerating5        = t1.variablerating5,
                 ocd_variableresult6        = t1.variableresult6,
                 ocd_variablerating6        = t1.variablerating6,
                 ocd_mubf                   = t1.mubf,
                 ocd_mubfuom                = @sUsageuom,
                 ocd_mubfrating             = t1.mubfrating,
                 ocd_equipincludedinperform = t1.equipincludedinperform,
                 ocd_performanceformula     = @sPerfformula,
                 ocd_performanceformula_org = @sPerfformulaorg
          FROM   r5assetclassdefinition a1,
                 ( SELECT ROUND( AVG( obj_conditionrating ), 0 ) AS conditionrating,
                          AVG( obj_numberoffailures ) AS numberoffailures,
                          AVG( obj_mtbfdays ) AS mtbf,
                          ROUND( AVG( obj_mtbfrating ), 0 ) AS mtbfrating,
                          AVG( obj_mttrhrs ) AS mttr,
                          ROUND( AVG( obj_mttrrating ), 0 ) AS mttrrating,
                          AVG( obj_variableresult1 ) AS variableresult1,
                          ROUND( AVG( obj_variablerating1 ), 0 ) AS variablerating1,
                          AVG( obj_variableresult2 ) AS variableresult2,
                          ROUND( AVG( obj_variablerating2 ), 0 ) AS variablerating2,
                          AVG( obj_variableresult3 ) AS variableresult3,
                          ROUND( AVG( obj_variablerating3 ), 0 ) AS variablerating3,
                          AVG( obj_variableresult4 ) AS variableresult4,
                          ROUND( AVG( obj_variablerating4 ), 0 ) AS variablerating4,
                          AVG( obj_variableresult5 ) AS variableresult5,
                          ROUND( AVG( obj_variablerating5 ), 0 ) AS variablerating5,
                          AVG( obj_variableresult6 ) AS variableresult6,
                          ROUND( AVG( obj_variablerating6 ), 0 ) AS variablerating6,
                          AVG( obj_mubf * CASE obj_primaryuom WHEN @sUsageuom THEN 1 ELSE uoc_confact END ) AS mubf,
                          ROUND( AVG( obj_mubfrating ), 0 ) AS mubfrating,
                          COUNT(*) AS equipincludedinperform
                   FROM   r5objects
                          LEFT OUTER JOIN r5uomconversion ON uoc_baseuom = @sUsageuom AND uoc_siteuom = obj_primaryuom
                   WHERE  obj_org                     = @sOrg
                   AND    obj_category                = @sObjcategory
                   AND    obj_performanceformula      = @sPerfformula
                   AND    obj_performanceformula_org  = @sPerfformulaorg
                   AND    obj_performancelastupdated >= @dPerfformuladate
                   AND    obj_rstatus NOT IN ( N'A', N'D' ) ) t1
          WHERE  ocd_org      = @sOrg
          AND    ocd_category = @sObjcategory

          /* Calculate the performance using the just updated data. */
          UPDATE r5assetclassdefinition
          SET    ocd_performancelastupdated = GETDATE(),
                 ocd_performance = ROUND( ( ISNULL( ocd_conditionrating, 0 ) * ISNULL( @nCondweight, 0 ) ) +
                                          ( ISNULL( ocd_capacityrating, 0 )  * ISNULL( @nCapweight, 0 ) ) +
                                          ( ISNULL( ocd_mttrrating, 0 )      * ISNULL( @nMttrweight, 0 ) ) +
                                          ( ISNULL( ocd_variablerating1, 0 ) * ISNULL( @nVar1weight, 0 ) ) +
                                          ( ISNULL( ocd_variablerating2, 0 ) * ISNULL( @nVar2weight, 0 ) ) +
                                          ( ISNULL( ocd_variablerating3, 0 ) * ISNULL( @nVar3weight, 0 ) ) +
                                          ( ISNULL( ocd_variablerating4, 0 ) * ISNULL( @nVar4weight, 0 ) ) +
                                          ( ISNULL( ocd_variablerating5, 0 ) * ISNULL( @nVar5weight, 0 ) ) +
                                          ( ISNULL( ocd_variablerating6, 0 ) * ISNULL( @nVar6weight, 0 ) ) +
                                          CASE @sUsagebased WHEN N'-' THEN ( ISNULL( ocd_mtbfrating, 0 ) * ISNULL( @nMtbfweight, 0 ) ) ELSE
                                                                           ( ISNULL( ocd_mubfrating, 0 ) * ISNULL( @nMtbfweight, 0 ) ) END, 0 )
          WHERE  ocd_org      = @sOrg
          AND    ocd_category = @sObjcategory
        END
    END

  IF @Srollup = N'+' AND @sObjclass IS NOT NULL
    BEGIN
      /* Check if class record exists. */
      SELECT @nCnt = COUNT(*)
      FROM   r5assetclassdefinition
      WHERE  ocd_class     = @sObjclass
      AND    ocd_class_org = @sObjclassorg
      AND    ocd_org       = @sOrg
      AND    ocd_category IS NULL
      IF @nCnt > 0
        BEGIN
          /* Calculate average/sum for the class, using data from objects belonging to the class. */
          /* Exception for the number of objects in the class and total desired capacity.. */
          SELECT @nCnt = COUNT(*),
                 @nTotcapacity = SUM( obj_availablecapacity )
          FROM   r5objects
          WHERE  obj_class     = @sObjclass
          AND    obj_class_org = @sObjclassorg
          AND    obj_org       = @sOrg
          AND    obj_rstatus NOT IN ( N'A', N'D' )

          /* Total desired capacity. */
          SET @nTotdesiredcapacity = NULL
          SELECT @nTotdesiredcapacity = ccp_totaldesiredcapacity
          FROM   r5assetclassdefcapacities, r5assetclassdefinition
          WHERE  ocd_pk           = ccp_ocdpk
          AND    ocd_org          = @sOrg
          AND    ocd_class        = @sObjclass
          AND    ocd_class_org    = @sObjclassorg
          AND    ccp_capacitycode = @sCapacitycode
          AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ccp_effective AND ccp_expired
          IF @nTotdesiredcapacity IS NULL
            BEGIN
              /* Nothing on class level, try '*' class. */
              SELECT @nTotdesiredcapacity = ccp_totaldesiredcapacity
              FROM   r5assetclassdefcapacities, r5assetclassdefinition
              WHERE  ocd_pk           = ccp_ocdpk
              AND    ocd_org          = @sOrg
              AND    ocd_class        = '*'
              AND    ocd_class_org    = '*'
              AND    ccp_capacitycode = @sCapacitycode
              AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ccp_effective AND ccp_expired
              IF @nTotdesiredcapacity IS NULL
                BEGIN
                  /* Nothing on '*' class level, try '*' class in '*' org. */
                  SELECT @nTotdesiredcapacity = ccp_totaldesiredcapacity
                  FROM   r5assetclassdefcapacities, r5assetclassdefinition
                  WHERE  ocd_pk           = ccp_ocdpk
                  AND    ocd_org          = '*'
                  AND    ocd_class        = '*'
                  AND    ocd_class_org    = '*'
                  AND    ccp_capacitycode = @sCapacitycode
                  AND    dbo.F_TRUNC_DATE( GETDATE(), N'DD' ) BETWEEN ccp_effective AND ccp_expired
                END
            END

          UPDATE a1
          SET    ocd_conditionrating        = t1.conditionrating,
                 ocd_capacitycode           = @sCapacitycode,
                 ocd_availablecapacity      = @nTotcapacity,
                 ocd_desiredcapacity        = @nTotdesiredcapacity,
                 ocd_capacityrating         = CASE WHEN ISNULL( @nCapweight, 0 ) = 0 THEN NULL ELSE
                                                CASE WHEN ISNULL( @nTotdesiredcapacity, 0 ) = 0 OR @nTotcapacity IS NULL THEN 100 ELSE
                                                  ROUND( dbo.F_LEAST_NUMBER( @nTotcapacity / @nTotdesiredcapacity * 100, 100 ), 0 ) END END,
                 ocd_equipcount             = @nCnt,
                 ocd_numberoffailures       = t1.numberoffailures,
                 ocd_mtbfdays               = t1.mtbf,
                 ocd_mtbfrating             = t1.mtbfrating,
                 ocd_mttrhrs                = t1.mttr,
                 ocd_mttrrating             = t1.mttrrating,
                 ocd_variableresult1        = t1.variableresult1,
                 ocd_variablerating1        = t1.variablerating1,
                 ocd_variableresult2        = t1.variableresult2,
                 ocd_variablerating2        = t1.variablerating2,
                 ocd_variableresult3        = t1.variableresult3,
                 ocd_variablerating3        = t1.variablerating3,
                 ocd_variableresult4        = t1.variableresult4,
                 ocd_variablerating4        = t1.variablerating4,
                 ocd_variableresult5        = t1.variableresult5,
                 ocd_variablerating5        = t1.variablerating5,
                 ocd_variableresult6        = t1.variableresult6,
                 ocd_variablerating6        = t1.variablerating6,
                 ocd_mubf                   = t1.mubf,
                 ocd_mubfuom                = @sUsageuom,
                 ocd_mubfrating             = t1.mubfrating,
                 ocd_equipincludedinperform = t1.equipincludedinperform
          FROM   r5assetclassdefinition a1,
                 ( SELECT ROUND( AVG( obj_conditionrating ), 0 ) AS conditionrating,
                          AVG( obj_numberoffailures ) AS numberoffailures,
                          AVG( obj_mtbfdays ) AS mtbf,
                          ROUND( AVG( obj_mtbfrating ), 0 ) AS mtbfrating,
                          AVG( obj_mttrhrs ) AS mttr,
                          ROUND( AVG( obj_mttrrating ), 0 ) AS mttrrating,
                          AVG( obj_variableresult1 ) AS variableresult1,
                          ROUND( AVG( obj_variablerating1 ), 0 ) AS variablerating1,
                          AVG( obj_variableresult2 ) AS variableresult2,
                          ROUND( AVG( obj_variablerating2 ), 0 ) AS variablerating2,
                          AVG( obj_variableresult3 ) AS variableresult3,
                          ROUND( AVG( obj_variablerating3 ), 0 ) AS variablerating3,
                          AVG( obj_variableresult4 ) AS variableresult4,
                          ROUND( AVG( obj_variablerating4 ), 0 ) AS variablerating4,
                          AVG( obj_variableresult5 ) AS variableresult5,
                          ROUND( AVG( obj_variablerating5 ), 0 ) AS variablerating5,
                          AVG( obj_variableresult6 ) AS variableresult6,
                          ROUND( AVG( obj_variablerating6 ), 0 ) AS variablerating6,
                          AVG( obj_mubf * CASE obj_primaryuom WHEN @sUsageuom THEN 1 ELSE uoc_confact END ) AS mubf,
                          ROUND( AVG( obj_mubfrating ), 0 ) AS mubfrating,
                          COUNT(*) AS equipincludedinperform
                   FROM   r5objects
                          LEFT OUTER JOIN r5uomconversion ON uoc_baseuom = @sUsageuom AND uoc_siteuom = obj_primaryuom
                   WHERE  obj_org                     = @sOrg
                   AND    obj_class                   = @sObjclass
                   AND    obj_class_org               = @sObjclassorg
                   AND    obj_performanceformula      = @sPerfformula
                   AND    obj_performanceformula_org  = @sPerfformulaorg
                   AND    obj_performancelastupdated >= @dPerfformuladate
                   AND    obj_rstatus NOT IN ( N'A', N'D' ) ) t1
          WHERE  ocd_org       = @sOrg
          AND    ocd_class     = @sObjclass
          AND    ocd_class_org = @sObjclassorg
          AND    ocd_category IS NULL

          /* Calculate the performance using the just updated data. */
          UPDATE r5assetclassdefinition
          SET    ocd_performancelastupdated = GETDATE(),
                 ocd_performance = ROUND( ( ISNULL( ocd_conditionrating, 0 ) * ISNULL( @nCondweight, 0 ) ) +
                                          ( ISNULL( ocd_capacityrating, 0 )  * ISNULL( @nCapweight, 0 ) ) +
                                          ( ISNULL( ocd_mttrrating, 0 )      * ISNULL( @nMttrweight, 0 ) ) +
                                          ( ISNULL( ocd_variablerating1, 0 ) * ISNULL( @nVar1weight, 0 ) ) +
                                          ( ISNULL( ocd_variablerating2, 0 ) * ISNULL( @nVar2weight, 0 ) ) +
                                          ( ISNULL( ocd_variablerating3, 0 ) * ISNULL( @nVar3weight, 0 ) ) +
                                          ( ISNULL( ocd_variablerating4, 0 ) * ISNULL( @nVar4weight, 0 ) ) +
                                          ( ISNULL( ocd_variablerating5, 0 ) * ISNULL( @nVar5weight, 0 ) ) +
                                          ( ISNULL( ocd_variablerating6, 0 ) * ISNULL( @nVar6weight, 0 ) ) +
                                          CASE @sUsagebased WHEN N'-' THEN ( ISNULL( ocd_mtbfrating, 0 ) * ISNULL( @nMtbfweight, 0 ) ) ELSE
                                                                           ( ISNULL( ocd_mubfrating, 0 ) * ISNULL( @nMtbfweight, 0 ) ) END, 0 )
          WHERE  ocd_org       = @sOrg
          AND    ocd_class     = @sObjclass
          AND    ocd_class_org = @sObjclassorg
          AND    ocd_category IS NULL
        END
    END

  checkerror:
  IF @sChk <> '0'
    UPDATE r5equipmentrankings
    SET    eqr_calculationerror = '+'
    WHERE  eqr_objcode          = @sObj
    AND    eqr_objorg           = @sOrg
    AND    eqr_rankingcode      = @sEqrrankingcode
    AND    eqr_rankingorg       = @sEqrrankingorg
    AND    eqr_rankingrevision  = @nEqrrankingrev

  /* Do final commit. */
  IF @@TRANCOUNT > 0
    COMMIT

END
