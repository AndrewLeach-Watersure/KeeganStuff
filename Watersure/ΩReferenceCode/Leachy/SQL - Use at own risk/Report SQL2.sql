SELECT 
       EVT_CODE,
       EVT_DESC,
       EVT_JOBTYPE,
       DBO.REPGETDESC('EN','UCOD',EVT_JOBTYPE,'JBTP',NULL) 
       EVT_JOBTYPE_DESC,
       EVT_STATUS,
       DBO.REPGETDESC('EN','UCOD',EVT_STATUS,'EVST',NULL) EVT_STATUS_DESC,
       EVT_OBJECT,
       OBJ_DESC,
       EVT_CREATED,
       EVT_PRIORITY,
       EVT_TARGET,
       EVT_SCHEDGRP,
       EVT_UDFCHAR13,
       EVT_UDFCHAR15,
       EVT_UDFCHAR11,
       EVT_UDFCHAR07,
       EVT_UDFDATE02,
       EVT_UDFCHKBOX01,
       EVT_UDFCHKBOX02,
       EVT_UDFCHKBOX03,
       EVT_UDFCHKBOX04,
       EVT_UDFCHKBOX05,
       EVT_UDFNUM05,
       ACT_ACT, 
       DBO.REPGETADDTEXT('EVNT','EN',ACT_EVENT+'#'+CONVERT(NVARCHAR(10),ACT_ACT)) ACT_COMMENT,
       ACT_TRADE,
       EVT_PERSON,
       ACT_EST,
       EVT_MRC,
       ACT_PERCOMPLETE,
       ACT_REM,
       ACT_NOTE,
      JBA_ENDDATE

FROM R5EVENTS       
INNER JOIN R5OBJECTS ON EVT_OBJECT = OBJ_CODE AND EVT_OBJECT_ORG=OBJ_ORG
INNER JOIN R5ACTIVITIES ON EVT_CODE=ACT_EVENT
INNER JOIN R5JOBACT ON EVT_CODE = JBA_EVENT AND ACT_ACT = JBA_ACT
AND (EVT_JOBTYPE IN ('EMIN') OR EVT_JOBTYPE IN ('EMTM') OR EVT_JOBTYPE IN ('EMPM'))
AND EVT_UDFCHKBOX01 NOT IN ('+')
AND EVT_RTYPE IN ('JOB')
AND EVT_STATUS NOT IN ('C','CANC','CLOS','HOLD')
